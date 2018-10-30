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
#define DATA_WIDTH 16
#define DATA_BP 8

uint64_t pack_data(double x) {
  int64_t in_int = (int64_t)(x * (1L << DATA_BP));
  uint64_t pack = (uint64_t)in_int;
  return pack;
}

int64_t unpack_data(uint64_t packed) {
  uint64_t xpack = packed;
  return xpack;
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
  int64_t data_out;
  double data_out_double;
  // Rotating Mode Tests
  double in[24] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
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
    data_out = unpack_data(pack_out);
    data_out_double = (double) data_out / pow(2,DATA_BP);
    //printf("DATA = %d\n", data_out);
    if(check_tol(data_out_double,ex[i],tol)) ;
    else { printf("TEST %d FAILED!\n",(i+1)); test_failed = 1; all_tests_passed = 0;}
  }
  //if(test_failed) printf("!!! ROTATION TEST FAILED !!!\n");
  //else printf("ROTATION TEST PASSED!\n");

  if(all_tests_passed) printf("ALL TESTS PASSED!\n");

	return 0;
}
