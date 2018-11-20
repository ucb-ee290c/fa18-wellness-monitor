#define WELLNESS_WRITE 0x2000
#define WELLNESSCONF_WRITE 0x2200
#define WELLNESS_WRITE_COUNT 0x2008
#define WELLNESSCONF_WRITE_COUNT 0x2208
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
#define DATA_BP 8
#define DATA_MASK ((1L << DATA_WIDTH)-1)

#define DIMENSIONS 3         // number of channels going into the PCA
#define FEATURES 2           // number of reduced dimensions going into the SVM
#define SUPPORTS 2           // number of support vectors for SVM
#define CLASSES 2            // number of classes

#define CLASSIFIERS 1        // number of classifiers created

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
    printf("\n");
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

double PCA(double inputs[DIMENSIONS], double pcaVector[FEATURES][DIMENSIONS], int index) {

  int PCAout[FEATURES];

  for (int i=0 ; i<FEATURES ; i++) {
    PCAout[i] = 0;
    for (int j=0 ; j<DIMENSIONS ; j++) {
      PCAout[i] = PCAout[i] + inputs[j]*pcaVector[i][j];
    }
  }
  return PCAout[index];
}

double SVM(double inputs[FEATURES], double SVMSupportVector[SUPPORTS][FEATURES],
        double SVMAlphaVector[CLASSIFIERS][SUPPORTS], double SVMIntercept[CLASSIFIERS], int index) {

  int i,j;
  double SVMout[CLASSES];
  double kernel[SUPPORTS];

  // computation of the kernel (dot product of inputs and support vector)
  for(i=0 ; i < SUPPORTS ; i++) {
    kernel[i] = 0;
    for(j=0; j < FEATURES ; j++) {
      kernel[i] = kernel[i] + inputs[j]*SVMSupportVector[i][j];
      //printf("kernel %d %d %d\n",inputs[j],SVMSupportVector[i][j],kernel[i]);
    }
    //kernel[i] = pow(kernel[i],degree); // for polynomial degrees
  }

  int decision[CLASSIFIERS];

  // final dot product of the kernel with the weights (alphas)
  for(i=0 ; i < CLASSIFIERS ; i++) {
    decision[i] = 0;
    for(j=0 ; j < SUPPORTS ; j++) {
      decision[i] = decision[i] + SVMAlphaVector[i][j]*kernel[j];
    }
    decision[i] = decision[i] + SVMIntercept[i];
  }

  // voting time, depends on the classifier type and number of classifiers
  // try 2 first, just to have an initial test, just compute for the raw
  // this logic is a translation from svm.scala line 126-138

  if(decision[0] > 0) {
    SVMout[0] = 0;
    SVMout[1] = decision[0];
  } else {
    SVMout[0] = -1*decision[0];
    SVMout[1] = 0;
  }

  return SVMout[index];
}

int main(void)
{
  printf("%d\n", 3);

  uint64_t write_data, read_data;
  uint64_t rd_count;
  int64_t pack_out;
  int i,j;
  int32_t data_out_0;
  int32_t data_out_1;
  double data_out_double;
  double in[24] = {1,1,2.2,3,4,5.3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
  double ex[24] = {5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,3,2,1};
  double tol = 0.5;

  // the array constants, must be consistent with Wellness.scala
  double pcaVector[FEATURES][DIMENSIONS] = {{5.1,0.3,-2.15},{1,2,3}};
  double SVMSupportVector[SUPPORTS][FEATURES] = {{1,2.21},{3.33,4}};
  double SVMAlphaVector[CLASSIFIERS][SUPPORTS] = {{7,3.3}};
  double SVMIntercept[CLASSIFIERS] = {4.1};

  // TODO: Feed the computed features here
  double inputs[DIMENSIONS] = {36.1,56.9,21.5};

  double PCAout[FEATURES];
  double SVMout[CLASSES];

  for (i=0;i<FEATURES;i++) {
    // it seems like passing a pointer isn't supported in this system, lol
    PCAout[i] = PCA(inputs,pcaVector,i);
  }

  //printf("pca0 %d\n",PCAout[0]);
  //printf("pca1 %d\n",PCAout[1]);

  for (i=0;i<CLASSES;i++) {
    SVMout[i] = SVM(PCAout,SVMSupportVector,SVMAlphaVector,SVMIntercept,i);
  }

  printf("svm0 ");
  printDouble(SVMout[0],4);
  printf("svm1 ");
  printDouble(SVMout[1],4);
  // ##################################### END DIAGNOSTIC

  for(i=0;i<24;i++) {
    write_data = pack_data(in[i]);
  }

  // Write PCA Stuff
  for(i=1;i<=FEATURES;i++){
    for(j=1;j<=DIMENSIONS;j++){
        write_data = pack_conf_data(0,pcaVector[FEATURES-i][DIMENSIONS-j]);
        //printf("pcawr: %d\n ",write_data);
        //printf("Write Data: %d\n",write_data);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }

  for(i=1;i<=SUPPORTS;i++){
    for(j=1;j<=FEATURES;j++){
        write_data = pack_conf_data(1,SVMSupportVector[SUPPORTS-i][FEATURES-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }

  for(i=1;i<=CLASSIFIERS;i++){
    for(j=1;j<=SUPPORTS;j++){
        write_data = pack_conf_data(2,SVMAlphaVector[CLASSIFIERS-i][SUPPORTS-j]);
        reg_write64(WELLNESSCONF_WRITE, write_data);
        while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
    }
  }
  for(i=1;i<=CLASSIFIERS;i++){
    write_data = pack_conf_data(3,SVMIntercept[CLASSIFIERS-i]);
    reg_write64(WELLNESSCONF_WRITE, write_data);
    while(reg_read64(WELLNESSCONF_WRITE_COUNT) > 0);
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
  }
  for(i=0;i<24;i++)
  {
    while(reg_read64(WELLNESS_READ_COUNT) == 0) reg_write64(WELLNESS_WRITE, pack_data((double)0));
    pack_out = reg_read64(WELLNESS_READ);
    data_out_0 = unpack_pca_0(pack_out);
    data_out_1 = unpack_pca_1(pack_out);
    //data_out_double = (double) data_out / pow(2,DATA_BP);
    //printf("DATA0 = %d\n", data_out_0);
    printDouble(data_out_0,4);
    //printf("DATA1 = %d\n", data_out_1);
    printDouble(data_out_1,4);
    printf("----------\n");
    //if(check_tol(data_out_double,ex[i],tol)) ;
    //else { printf("TEST %d FAILED!\n",(i+1)); test_failed = 1; all_tests_passed = 0;}
  }


	return 0;
}
