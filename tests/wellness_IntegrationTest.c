#define WELLNESS_WRITE 0x2000
#define WELLNESS_WRITE_COUNT 0x2008
#define WELLNESS_READ 0x2100
#define WELLNESS_READ_COUNT 0x2108

#include <stdio.h>
#include <math.h>

#include "mmio.h"

/**
 * Make sure these #defines are correct for your chosen parameters.
 * You'll get really strange (and wrong) results if they do not match.
 */
#define DATA_WIDTH 32

uint64_t pack_data(double x) {
  uint64_t pack = (uint64_t)x;
  return pack;
}

int32_t unpack_pca_1(uint64_t packed) {
  uint64_t xpack = packed;
  int shift = 32;
  return ((int64_t)(xpack << shift)) >> shift;
}

int32_t unpack_pca_0(uint64_t packed) {
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
  printf("%d\n", 3);

  uint64_t write_data, read_data;
  uint64_t rd_count;
  int64_t pack_out;
  int i;
  int32_t data_out_0;
  int32_t data_out_1;
  double data_out_double;
  double in[24] = {1,2,3,4,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
  double ex[24] = {5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,3,2,1};
  double tol = 0.5;


  for(i=0;i<24;i++) {
    write_data = pack_data(in[i]);
  }

  int test_failed;
  int all_tests_passed;
  all_tests_passed = 1;
  test_failed = 0;
  for(i=0;i<24;i++)
  {
    write_data = pack_data(in[i]);
    reg_write64(WELLNESS_WRITE, write_data);
    while(reg_read64(WELLNESS_WRITE_COUNT) > 0);
    //printf("LABALOV");
  }
  for(i=0;i<24;i++)
  {
    while(reg_read64(WELLNESS_READ_COUNT) == 0) reg_write64(WELLNESS_WRITE, pack_data((double)0));
    pack_out = reg_read64(WELLNESS_READ);
    data_out_0 = unpack_pca_0(pack_out);
    data_out_1 = unpack_pca_1(pack_out);
    //data_out_double = (double) data_out / pow(2,DATA_BP);
    printf("DATA0 = %d\n", data_out_0);
    printf("DATA1 = %d\n", data_out_1);
    printf("----------\n");
    //if(check_tol(data_out_double,ex[i],tol)) ;
    //else { printf("TEST %d FAILED!\n",(i+1)); test_failed = 1; all_tests_passed = 0;}
  }


	return 0;
}
