
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <fcntl.h>


#define NUMHID 10
#define NUMOUT 1

#define rando() ((double)rand()/((double)RAND_MAX+1))

void neuralNetwork(int numOfPatterns, int numOfInputs , int select, double *inputValues,  double * outputValues, double *testInputValues, double *testOutputValues ) ;

