#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "input.h"
#include "output.h"


#define WIDTH 512
#define HEIGHT 512

void sobel_filter(unsigned char input[][WIDTH],
                  unsigned char output[][WIDTH]) {
    int i, j;
    int m, n;

    int gx_sum, gy_sum, sum;

    int gx[3][3] = {{-1, 0, 1},
                    {-2, 0, 2},
                    {-1, 0, 1}};

    int gy[3][3] = {{ 1,  2,  1},
                    { 0,  0,  0},
                    {-1, -2, -1}};

    for (i = 0; i < HEIGHT; i++) {
        for (j = 0; j < WIDTH; j++) {
            sum = 0;
            int outofbounds = 0;
            outofbounds |= (i < 1) | (i > (HEIGHT - 2));
            outofbounds |= (j < 1) | (j > (WIDTH - 2));

            gx_sum = 0;
            gy_sum = 0;
            for (m = -1; m <= 1; m++) {
                for (n = -1; n <= 1; n++) {
                    gx_sum += (outofbounds) ? 0 :
                        ((int)input[i + m][j + n]) * gx[m + 1][n + 1];
                    gy_sum += (outofbounds) ? 0 :
                        ((int)input[i + m][j + n]) * gy[m + 1][n + 1];
                }
            }

            gx_sum = (gx_sum < 0) ? -gx_sum : gx_sum;
            gy_sum = (gy_sum < 0) ? -gy_sum : gy_sum;

            sum = gx_sum + gy_sum;
            sum = (sum > 255) ? 255 : sum;

            output[i][j] = (unsigned int)sum;
        }
    }
}
float exponential(int n, float x)
{
    float sum = 1.0f; // initialize sum of series

    for (int i = n - 1; i > 0; --i )
        sum = 1 + x * sum / i;

    return sum;
}

#define NUMPAT 4
#define NUMIN  2
#define NUMHID 2
#define NUMOUT 1

#define rando() ((double)rand()/((double)RAND_MAX+1))

int main()
{

    int    i, j, k, p, np, op, ranpat[NUMPAT+1], epoch;
    int    NumPattern = NUMPAT, NumInput = NUMIN, NumHidden = NUMHID, NumOutput = NUMOUT;
    double Input[NUMPAT+1][NUMIN+1] = { {0, 0, 0},  {0, 0, 0},  {0, 1, 0},  {0, 0, 1},  {0, 1, 1} };
    double Target[NUMPAT+1][NUMOUT+1] = { {0, 0},  {0, 0},  {0, 1},  {0, 1},  {0, 0} };
    double SumH[NUMPAT+1][NUMHID+1], WeightIH[NUMIN+1][NUMHID+1], Hidden[NUMPAT+1][NUMHID+1];
    double SumO[NUMPAT+1][NUMOUT+1], WeightHO[NUMHID+1][NUMOUT+1], Output[NUMPAT+1][NUMOUT+1];
    double DeltaO[NUMOUT+1], SumDOW[NUMHID+1], DeltaH[NUMHID+1];
    double DeltaWeightIH[NUMIN+1][NUMHID+1], DeltaWeightHO[NUMHID+1][NUMOUT+1];
    double Error, eta = 0.5, alpha = 0.9, smallwt = 0.5;

 
    for( j = 1 ; j <= NumHidden ; j++ ) {    /* initialize WeightIH and DeltaWeightIH */
        for( i = 0 ; i <= NumInput ; i++ ) { 
            DeltaWeightIH[i][j] = 0.0 ;
            WeightIH[i][j] = 0.0 ;
        }
    }
    for( k = 1 ; k <= NumOutput ; k ++ ) {    
        for( j = 0 ; j <= NumHidden ; j++ ) {
            DeltaWeightHO[j][k] = 0.0 ;              
            WeightHO[j][k] = 0.0;
        }
    }

   for( epoch = 0 ; epoch < 10 ; epoch++) {    /* iterate weight updates */
        for( p = 1 ; p <= NumPattern ; p++ ) {    /* randomize order of training patterns */
            ranpat[p] = p ;
        }
        for( p = 1 ; p <= NumPattern ; p++) {
            np = p;
            op = ranpat[p] ; ranpat[p] = ranpat[np] ; ranpat[np] = op ;
        }
        Error = 0.0 ;
        for( np = 1 ; np <= NumPattern ; np++ ) {
            p = ranpat[np];
            for( j = 1 ; j <= NumHidden ; j++ ) {    /* compute hidden unit activations */
                SumH[p][j] = WeightIH[0][j] ;
                for( i = 1 ; i <= NumInput ; i++ ) {
                    SumH[p][j] += Input[p][i] * WeightIH[i][j] ;
                }
                Hidden[p][j] = 1.0/(1.0 + exponential(10,-SumH[p][j])) ;
                //Hidden[p][j] = 1.0/(1.0 + exp(-SumH[p][j])) ;
            }
            for( k = 1 ; k <= NumOutput ; k++ ) {    /* compute output unit activations and errors */
            SumO[p][k] = WeightHO[0][k] ;
            for( j = 1 ; j <= NumHidden ; j++ ) {
                SumO[p][k] += Hidden[p][j] * WeightHO[j][k] ;
            }
            Output[p][k] = 1.0/(1.0 + exponential(10,-SumO[p][k])) ;
            //Output[p][k] = 1.0/(1.0 + exp(-SumO[p][k])) ;
            //Output[p][k] = 1.0/(1.0 + -SumO[p][k]) ;   /* Sigmoidal Outputs */
/*          Output[p][k] = SumO[p][k];      Linear Outputs */
            Error += 0.5 * (Target[p][k] - Output[p][k]) * (Target[p][k] - Output[p][k]) ;   /* SSE */
/*          Error -= ( Target[p][k] * log( Output[p][k] ) + ( 1.0 - Target[p][k] ) * log( 1.0 - Output[p][k] ) ) ;    Cross-Entropy Error */
            DeltaO[k] = (Target[p][k] - Output[p][k]) * Output[p][k] * (1.0 - Output[p][k]) ;   /* Sigmoidal Outputs, SSE */
/*          DeltaO[k] = Target[p][k] - Output[p][k];     Sigmoidal Outputs, Cross-Entropy Error */
/*          DeltaltaO[k] = Target[p][k] - Output[p][k];     Linear Outputs, SSE */
            }
            for( j = 1 ; j <= NumHidden ; j++ ) {    /* 'back-propagate' errors to hidden layer */
                SumDOW[j] = 0.0 ;
                for( k = 1 ; k <= NumOutput ; k++ ) {
                    SumDOW[j] += WeightHO[j][k] * DeltaO[k] ;
                }
                DeltaH[j] = SumDOW[j] * Hidden[p][j] * (1.0 - Hidden[p][j]) ;
            }
            for( j = 1 ; j <= NumHidden ; j++ ) {     /* update weights WeightIH */
                DeltaWeightIH[0][j] = eta * DeltaH[j] + alpha * DeltaWeightIH[0][j] ;
                WeightIH[0][j] += DeltaWeightIH[0][j] ;
                for( i = 1 ; i <= NumInput ; i++ ) { 
                    DeltaWeightIH[i][j] = eta * Input[p][i] * DeltaH[j] + alpha * DeltaWeightIH[i][j];
                    WeightIH[i][j] += DeltaWeightIH[i][j] ;
                }
            }
            for( k = 1 ; k <= NumOutput ; k ++ ) {    /* update weights WeightHO */
                DeltaWeightHO[0][k] = eta * DeltaO[k] + alpha * DeltaWeightHO[0][k] ;
                WeightHO[0][k] += DeltaWeightHO[0][k] ;
                for( j = 1 ; j <= NumHidden ; j++ ) {
                    DeltaWeightHO[j][k] = eta * Hidden[p][j] * DeltaO[k] + alpha * DeltaWeightHO[j][k] ;
                    WeightHO[j][k] += DeltaWeightHO[j][k] ;
                }
            }

  
        }

        if( epoch%100 == 0 ) printf("rewriteC") ;
        if( Error < 0.0004 ) break ;  /* stop learning when 'near enough' */
    }



    ////BASIC CODE
    unsigned char sobel_output[HEIGHT][WIDTH];

    sobel_filter(elaine_512_input, sobel_output);

    int result = 0;
    //int i, j;

    for(i = 0; i < HEIGHT; i++) {
        for(j = 0; j < WIDTH; j++){
            if( sobel_output[i][j] != elaine_512_golden_output[i][j])
                result++;
        }
    }

    if (!result)
        printf("PASS!!!V2****\n");
    else
        printf("FAIL with %d differences\n", result);

    return 0;
}

