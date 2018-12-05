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

#define CONF_DATA_MASK ((1L << DATA_WIDTH)-1)
#define CONF_ADDR_WIDTH 3
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
    int64_t dataint = (int64_t)(data * (1L << DATA_BP));
    int64_t addrint = (int64_t)(addr);

    uint64_t datapack = ((uint64_t) dataint) & CONF_DATA_MASK;
    uint64_t addrpack = ((uint64_t) addrint) & CONF_ADDR_MASK;

    return (addrpack << DATA_WIDTH) | datapack;
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

  double tol = 0.15; // percent tolerance

  printf("This test uses %d bits total data width with %d bits for binary places\n",DATA_WIDTH,DATA_BP);

  // pushing data into the configuration matrices

  // pcaVector
  for(i=1;i<=FEATURES;i++){
    for(j=1;j<=DIMENSIONS;j++){
        write_data = pack_conf_data(0,pcaVector[FEATURES-i][DIMENSIONS-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  printf("Done configuring PCA Vector: %d reduced dimension(s), %d original features\n",FEATURES,DIMENSIONS);

  // SVMSupportVector
  for(i=1;i<=SUPPORTS;i++){
    for(j=1;j<=FEATURES;j++){
        write_data = pack_conf_data(1,SVMSupportVector[SUPPORTS-i][FEATURES-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  printf("Done configuring SVM Support Vector: %d support vectors, %d reduced dimension(s)\n",SUPPORTS,FEATURES);

  // SVMAlphaVector
  for(i=1;i<=CLASSIFIERS;i++){
    for(j=1;j<=SUPPORTS;j++){
        write_data = pack_conf_data(2,SVMAlphaVector[CLASSIFIERS-i][SUPPORTS-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  printf("Done configuring SVM Alpha Vector: %d classifier(s), %d support vectors\n",CLASSIFIERS,SUPPORTS);

  // SVMIntercept
  for(i=1;i<=CLASSIFIERS;i++){
    write_data = pack_conf_data(3,SVMIntercept[CLASSIFIERS-i]);
    reg_write64(WELLNESSCONF_WRITE, write_data);
    while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
  }
  printf("Done configuring SVM Intercept: %d classifier(s)\n",CLASSIFIERS);

  // Mux select for streaming input, 0 if through C code
  write_data = pack_conf_data(4,0.0);
  reg_write64(WELLNESSCONF_WRITE, write_data);
  while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
  printf("Passing data through C test instead of external input\n");

  // PCANormVector
  for(i=1;i<=DIMENSIONS;i++){
    for(j=1;j<=2;j++){
        write_data = pack_conf_data(5,PCANormVector[DIMENSIONS-i][2-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  printf("Done configuring PCA Normalization Vector\n");

  // this is the main loop to feed the input vector one by one
  for(i=0;i<96;i++) {
    while(reg_read64(WELLNESS_READ_COUNT) == 0) {
        write_data = pack_data(in[i]);
        reg_write64(WELLNESS_WRITE, write_data);
    }
    pack_out = reg_read64(WELLNESS_READ);
    data_out_0 = unpack_pca_0(pack_out);
    data_out_1 = unpack_pca_1(pack_out);
    // converting the return value to doubles
    data_out_0double = (double) data_out_0 / pow(2,DATA_BP);
    data_out_1double = (double) data_out_1 / pow(2,DATA_BP);

    if (i > WINDOW+NUMTAPS+2) { // This is the part where the output starts being correct
        printf("Scores: ");
        printDouble(data_out_0double,4);
        printf(" ");
        printDouble(data_out_1double,4);
        printf(" ");

        printf("\tExpected: ");
        printDouble(ex[i-(WINDOW+NUMTAPS)][0],4);
        printf(" ");
        printDouble(ex[i-(WINDOW+NUMTAPS)][1],4);

        if (data_out_0double > 0) {
            if ((data_out_0double <= ex[i-(WINDOW+NUMTAPS)][0]*(1+tol)) && // tolerance check
                (data_out_0double >= ex[i-(WINDOW+NUMTAPS)][0]*(1-tol))) {
                printf("\tPASSED (within %d\%)", (int)(tol*100));
                }
            else { printf("\tFAIL (not within %d\%)", (int)(tol*100));}
            printf("\tPredicted label: No seizure");
        } else if (data_out_1double > 0) {
            if ((data_out_1double <= ex[i-(WINDOW+NUMTAPS)][1]*(1+tol)) && // tolerance check
                (data_out_1double >= ex[i-(WINDOW+NUMTAPS)][1]*(1-tol))) {
                printf("\tPASSED (within %d\%)", (int)(tol*100));
                }
            else { printf("\tFAIL (not within %d\%)", (int)(tol*100));}
            printf("\tPredicted label: SEIZURE");
        }

        printf("\n");
    }
  }
  return 0;
}