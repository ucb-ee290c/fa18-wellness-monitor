#define WELLNESS_WRITE 0x2000
#define WELLNESSCONF_WRITE 0x2200
#define WELLNESS_WRITE_COUNT 0x2008
#define WELLNESSCONF_WRITE_COUNT 0x2208
#define WELLNESS_READ 0x2100
#define WELLNESS_READ_COUNT 0x2108

#include <stdio.h>
#include <math.h>

#include "mmio.h"
#include "arrays.h"

/**
 * Make sure these #defines are correct for your chosen parameters.
 * You'll get really strange (and wrong) results if they do not match.
 */
#define DATA_MASK ((1L << DATA_WIDTH)-1)

#define CONF_DATA_WIDTH 32
#define CONF_DATA_BP 8
#define CONF_DATA_MASK ((1L << CONF_DATA_WIDTH)-1)
#define CONF_ADDR_WIDTH 2
#define CONF_ADDR_MASK ((1L << CONF_ADDR_WIDTH)-1)

void printDouble(double v, int decimalDigits)
{
    if(v<0){
      printf("-");
      v = -v;
    }
    printf("%d.", (int)v);
    for (int i=1; i<=decimalDigits; i++){
      v = v - (int)v;
      v *= 10;
      printf("%d", (int)v);
    }
    printf(" ");
}

uint64_t pack_data(double x) {
  int64_t dataint = (int64_t)(x * (1L << DATA_BP));

  uint64_t datapack = ((uint64_t) dataint) & DATA_MASK;

  return datapack;
}

uint64_t pack_conf_data(int addr,double data) {
    int64_t dataint = (int64_t)(data * (1L << CONF_DATA_BP));
    int64_t addrint = (int64_t)(addr);

    uint64_t datapack = ((uint64_t) dataint) & CONF_DATA_MASK;
    uint64_t addrpack = ((uint64_t) addrint) & CONF_ADDR_MASK;

    return (addrpack << CONF_DATA_WIDTH) | datapack;
}

int32_t unpack_pca_0(uint64_t packed) {
  uint64_t xpack = packed;
  int shift = 32;
  return ((int64_t)(xpack << shift)) >> shift;
}

int32_t unpack_pca_1(uint64_t packed) {
  uint64_t xpack = (packed >> 32);
  int shift = 32;
  return ((int64_t)(xpack << shift)) >> shift;
}

int check_tol(double x, double exp_x, double x_tol) {
  if(x > exp_x + x_tol) return 0;
  else if(x < exp_x - x_tol) return 0;
  return 1;
}

int main(void)
{
  uint64_t write_data, read_data;
  uint64_t rd_count;
  int64_t pack_out;
  int i,j;
  int32_t data_out_0;
  int32_t data_out_1;
  double data_out_0double;
  double data_out_1double;

  double tol = 0.1; // percent tolerance

  // pushing data into the configuration matrix
  // pcaVector
  for(i=1;i<=FEATURES;i++){
    for(j=1;j<=DIMENSIONS;j++){
        write_data = pack_conf_data(0,pcaVector[FEATURES-i][DIMENSIONS-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  // SVMSupportVector
  for(i=1;i<=SUPPORTS;i++){
    for(j=1;j<=FEATURES;j++){
        write_data = pack_conf_data(1,SVMSupportVector[SUPPORTS-i][FEATURES-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  // SVMAlphaVector
  for(i=1;i<=CLASSIFIERS;i++){
    for(j=1;j<=SUPPORTS;j++){
        write_data = pack_conf_data(2,SVMAlphaVector[CLASSIFIERS-i][SUPPORTS-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  // SVMIntercept
  for(i=1;i<=CLASSIFIERS;i++){
    write_data = pack_conf_data(3,SVMIntercept[CLASSIFIERS-i]);
    reg_write64(WELLNESSCONF_WRITE, write_data);
    while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
  }

  // this is the main loop to feed the input vector one by one
  for(i=0;i<100;i++) {
    while(reg_read64(WELLNESS_READ_COUNT) == 0) reg_write64(WELLNESS_WRITE, pack_data(in[i]));
    pack_out = reg_read64(WELLNESS_READ);
    data_out_0 = unpack_pca_0(pack_out);
    data_out_1 = unpack_pca_1(pack_out);
    // converting the return value to doubles
    data_out_0double = (double) data_out_0 / pow(2,DATA_BP);
    data_out_1double = (double) data_out_1 / pow(2,DATA_BP);

    if (i > WINDOW+NUMTAPS-1) { // This is the part where the output starts being correct
        printDouble(data_out_1double,4); // check only 1 of the outputs, the other one is always 0
        printDouble(ex[i-(WINDOW+NUMTAPS)][1],4); // adjust starting index 0
        if ((data_out_1double <= ex[i-(WINDOW+NUMTAPS)][1]*(1+tol)) && // tolerance check
            (data_out_1double >= ex[i-(WINDOW+NUMTAPS)][1]*(1-tol))) {
            printf(" PASSED (within 10\%)");
            }
        printf("\n");
    }
  }
  return 0;
}
