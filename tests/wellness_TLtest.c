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

uint16_t pack_data(double x) {
  int16_t in_int = (int16_t)(x * (1L << DATA_BP));
  uint16_t pack = (uint16_t)in_int;
  return pack;
}

int16_t unpack_data(uint16_t packed) {
  uint16_t xpack = packed >> (DATA_WIDTH);
  int shift = 16 - DATA_WIDTH;
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

  uint16_t write_data, read_data;
  uint16_t rd_count;
  int16_t pack_out;
  int i;
  int16_t data_out;
  double data_out_double;
  // Rotating Mode Tests
  double in[24] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};


  for(i=0;i<24;i++) {
    write_data = pack_data(in[i]);
  }

  int test_failed;
  int all_tests_passed;
  all_tests_passed = 1;
  test_failed = 0;
  for(i=0;i<23;i++)
  {
    write_data = pack_data(in[i]);
    reg_write16(WELLNESS_WRITE, write_data);
    while(reg_read16(WELLNESS_WRITE_COUNT) > 0);
    printf("LABALOV");
  }
  for(i=0;i<23;i++)
  {
    while(reg_read16(WELLNESS_READ_COUNT) == 0);
    pack_out = reg_read16(WELLNESS_READ);
    data_out = unpack_data(pack_out);
    data_out_double = (double) data_out / pow(2,DATA_BP);
    printf("DATA = %d\n", data_out);
    //if(check_tol(x_out_double,exp_xout[i],x_tol)) printf("ROTATION TEST %d PASSED!\n",(i+1));
    //else { printf("ROTATION TEST %d FAILED!\n",(i+1)); test_failed = 1; all_tests_passed = 0;}
  }
  //if(test_failed) printf("!!! ROTATION TEST FAILED !!!\n");
  //else printf("ROTATION TEST PASSED!\n");

  //if(all_tests_passed) printf("ALL TESTS PASSED!\n");

	return 0;
}
