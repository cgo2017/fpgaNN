
#include <stdio.h>
#include <stdlib.h> 
#include <time.h>
//#include <math.h>

#define TEST 64
#define NUMHID 10
#define NUMOUT 1

//#define rando() ((double)rand()/((double)RAND_MAX+1))
double  exponential(int n, double x)
{int i;

        double sum = 1.0f; // initialize sum of series

        for ( i = n - 1; i > 0; --i )
                sum = 1 + x * sum / i;

        return sum;
}
void neuralNetwork(int numOfPatterns, int numOfInputs , int select , double *inputValues,  double * outputValues, double *testInputValues, double *testOutputValues) {

	int  NUMPAT = numOfPatterns;
	int  NUMIN = numOfInputs;
	int    i, j, k, p, np, op, ranpat[NUMPAT+1], epoch;
	int    NumPattern = NUMPAT, NumInput = NUMIN, NumHidden1 = NUMHID, NumOutput = NUMOUT , NumHidden2 = NUMHID , NumHidden3 = NUMHID  ;
	FILE *myfile;
	double Input[NUMPAT+1][NUMIN+1] ;
	double Target[NUMPAT+1][NUMOUT+1] ;
	int batchSize;
	if(select==1)
	{
		batchSize = 64;
	}
	else if (select==2)
	{
		batchSize = 8;
	}


	for(i=0;i<= NUMPAT ;i++)

	{
		for (j=0;j<=NUMIN;j++)
		{
			Input[i][j]=0;
		}
	}
int index=0;
	for(i = 1; i <=  NUMPAT ; i++)
	{
		for (j=1;j<=NUMIN;j++)
Input[i][j]=inputValues[index];
index++;
	}

index=0;
	for(i=0;i<= NUMPAT ;i++)

	{
		for (j=0;j<=1;j++)
		{
			Target[i][j]=0;
		}
	}
	for(i = 1; i <=  NUMPAT ; i++)
	{
		for (j=1;j<=1;j++)
		{
Target[i][j]=outputValues[index];
index++;

		}
	}

	double SumH[NUMPAT+1][NUMHID+1], WeightIH[NUMIN+1][NUMHID+1], Hidden1[NUMPAT+1][NUMHID+1] , Hidden2[NUMPAT+1][NUMHID+1] , Hidden3[NUMPAT+1][NUMHID+1], SumH1[NUMPAT+1][NUMHID+1], WeightHH1[NUMIN+1][NUMHID+1],SumH2[NUMPAT+1][NUMHID+1], WeightHH2[NUMIN+1][NUMHID+1];
	double SumO[NUMPAT+1][NUMOUT+1], WeightHO[NUMHID+1][NUMOUT+1], Output[NUMPAT+1][NUMOUT+1];
	double DeltaO[NUMOUT+1], SumDOW[NUMHID+1], DeltaH1[NUMHID+1] , DeltaH2[NUMHID+1] , DeltaH3[NUMHID+1] ;
	double DeltaWeightIH[NUMIN+1][NUMHID+1], DeltaWeightHO[NUMHID+1][NUMOUT+1],DeltaWeightHH1[NUMIN+1][NUMHID+1],DeltaWeightHH2[NUMIN+1][NUMHID+1];
	double Error, eta = 0.0005, alpha =0.0009, smallwt =0.0004;


	for( j = 1 ; j <= NumHidden1 ; j++ ) {    
		for( i = 0 ; i <= NumInput ; i++ ) { 
			DeltaWeightIH[i][j] = 0.0 ;
//			WeightIH[i][j] = 2.0 * ( rando() - 0.5 ) * smallwt ;
  WeightIH[i][j] =0;
		}
	}
	for( j = 1 ; j <= NumHidden2 ; j++ ) {    
		for( i = 0 ; i <= NumHidden1 ; i++ ) {
			DeltaWeightHH1[i][j] = 0.0 ;
		//	WeightHH1[i][j] = 2.0 * ( rando() - 0.5 ) * smallwt ;
  WeightIH[i][j] =0;
		}
	}

	for( j = 1 ; j <= NumHidden3 ; j++ ) {    
		for( i = 0 ; i <= NumHidden2 ; i++ ) {
			DeltaWeightHH2[i][j] = 0.0 ;
		//	WeightHH2[i][j] = 2.0 * ( rando() - 0.5 ) * smallwt ;
  WeightIH[i][j] =0;
		}
	}

	for( k = 1 ; k <= NumOutput ; k ++ ) {   
		for( j = 0 ; j <= NumHidden3 ; j++ ) {
			DeltaWeightHO[j][k] = 0.0 ;              
		//	WeightHO[j][k] = 2.0 * ( rando() - 0.5 ) * smallwt ;
  WeightIH[i][j] =0;
		}
	}
	for( p = 1 ; p <= NumPattern ; p++ ) {   
		ranpat[p] = p ;
	}





	int epoch1;
	for( epoch1 = 0 ; epoch1< 1; epoch1++) {

		int yt;
		for(yt=1;yt<=(NUMPAT);yt=yt+batchSize)
		{

			for( epoch = 0 ; epoch < 1000; epoch++) {   
				Error = 0.0 ;
				for( np = yt ; np <= yt+batchSize ; np++ ) {    
					p = ranpat[np];
					for( j = 1 ; j <= NumHidden1 ; j++ ) {    
						SumH[p][j] = WeightIH[0][j] ;
						for( i = 1 ; i <= NumInput ; i++ ) {
							SumH[p][j] += Input[p][i] * WeightIH[i][j] ;
						}
						Hidden1[p][j] = 1.0/(1.0 + exponential(10,-SumH[p][j])) ;
					}



					for( j = 1 ; j <= NumHidden2 ; j++ ) {    
						SumH1[p][j] = WeightHH1[0][j] ;
						for( i = 1 ; i <= NumHidden1 ; i++ ) {
							SumH1[p][j] += Hidden1[p][i] * WeightHH1[i][j] ;
						}
						Hidden2[p][j] = 1.0/(1.0 + exponential(10,-SumH1[p][j])) ;
					}
					for( j = 1 ; j <= NumHidden3 ; j++ ) {    
						SumH2[p][j] = WeightHH2[0][j] ;
						for( i = 1 ; i <= NumHidden2 ; i++ ) {
							SumH2[p][j] += Hidden2[p][i] * WeightHH2[i][j] ;
						}//                Hidden3[p][j] = 1.0/(1.0 + exp(-SumH2[p][j])) ;
						Hidden3[p][j] = 1.0/(1.0 + exponential(10,-SumH2[p][j])) ;
					}


					for( k = 1 ; k <= NumOutput ; k++ ) {    
						SumO[p][k] = WeightHO[0][k] ;
						for( j = 1 ; j <= NumHidden3 ; j++ ) {
							SumO[p][k] += Hidden3[p][j] * WeightHO[j][k] ;
						}
						Output[p][k] = SumO[p][k];      
						Error += 0.5* (Target[p][k] - Output[p][k]) * (Target[p][k] - Output[p][k]) ;   
						DeltaO[k] = (Target[p][k] - Output[p][k]) ; 
					}

					for( j = 1 ; j <= NumHidden3 ; j++ ) {    
						SumDOW[j] = 0.0 ;
						for( k = 1 ; k <= NumOutput ; k++ ) {
							SumDOW[j] += WeightHO[j][k] * DeltaO[k] ;
						}
						DeltaH3[j] = SumDOW[j] * Hidden3[p][j] * (1.0 - Hidden3[p][j]) ;
					}
					for( j = 1 ; j <= NumHidden2 ; j++ ) {    
						SumDOW[j] = 0.0 ;
						for( k = 1 ; k <= NumHidden3 ; k++ ) {
							SumDOW[j] += WeightHH2[j][k] * DeltaH3[k] ;
						}

						DeltaH2[j] = SumDOW[j] * Hidden2[p][j] * (1.0 - Hidden2[p][j]) ;
					}
					for( j = 1 ; j <= NumHidden1 ; j++ ) {    
						SumDOW[j] = 0.0 ;
						for( k = 1 ; k <= NumHidden2 ; k++ ) {
							SumDOW[j] += WeightHH1[j][k] * DeltaH2[k] ;
						}
						DeltaH1[j] = SumDOW[j] * Hidden1[p][j] * (1.0 - Hidden1[p][j]) ;

					}


					for( j = 1 ; j <= NumHidden1 ; j++ ) {     
						DeltaWeightIH[0][j] = eta * DeltaH1[j] + alpha * DeltaWeightIH[0][j] ;
						WeightIH[0][j] += DeltaWeightIH[0][j] ;
						for( i = 1 ; i <= NumInput ; i++ ) { 
							DeltaWeightIH[i][j] = eta * Input[p][i] * DeltaH1[j] + alpha * DeltaWeightIH[i][j];
							WeightIH[i][j] += DeltaWeightIH[i][j] ;
						}
					}

					for( j = 1 ; j <= NumHidden2 ; j++ ) {     
						DeltaWeightHH1[0][j] = eta * DeltaH2[j] + alpha * DeltaWeightHH1[0][j] ;
						WeightHH1[0][j] += DeltaWeightHH1[0][j] ;
						for( i = 1 ; i <= NumHidden1 ; i++ ) {
							DeltaWeightHH1[i][j] = eta * Hidden1[p][i] * DeltaH2[j] + alpha * DeltaWeightHH1[i][j];
							WeightHH1[i][j] += DeltaWeightHH1[i][j] ;
						}
					}

					for( j = 1 ; j <= NumHidden3 ; j++ ) {     
						DeltaWeightHH2[0][j] = eta * DeltaH3[j] + alpha * DeltaWeightHH2[0][j] ;
						WeightHH2[0][j] += DeltaWeightHH2[0][j] ;
						for( i = 1 ; i <= NumHidden2 ; i++ ) {
							DeltaWeightHH2[i][j] = eta * Hidden2[p][i] * DeltaH3[j] + alpha * DeltaWeightHH2[i][j];
							WeightHH2[i][j] += DeltaWeightHH2[i][j] ;
						}
					}


					for( k = 1 ; k <= NumOutput ; k ++ ) {   
						DeltaWeightHO[0][k] = eta * DeltaO[k] + alpha * DeltaWeightHO[0][k] ;
						WeightHO[0][k] += DeltaWeightHO[0][k] ;
						for( j = 1 ; j <= NumHidden3 ; j++ ) {
							DeltaWeightHO[j][k] = eta * Hidden3[p][j] * DeltaO[k] + alpha * DeltaWeightHO[j][k] ;
							WeightHO[j][k] += DeltaWeightHO[j][k] ;
						}
					}
				}
				if( epoch%100 == 0 ) printf( "\nEpoch %-5d :   Error = %f", epoch, Error) ;
			}
		}    
	}

	/***********************PRINTING TARGET AND OUTPUT ************************/




	for( k = 1 ; k <= NumOutput ; k++ ) {
		printf("Target%-4d\tOutput%-4d\t", k, k) ;
	}
	for( p = 1 ; p <= NumPattern ; p++ ) {
		for( k = 1 ; k <= NumOutput ; k++ ) {
			printf( "%f\t%f\t\n", Target[p][k], Output[p][k]) ;
		}
	}

	/***********************TESTING*****************************************/

	printf("\n\n\n\n\n\n\nTESTING\n\n\n\n\n");
index=0;

	for(i=0;i<= TEST ;i++)

	{
		for (j=0;j<=NUMIN;j++)
		{
			Input[i][j]=0;
		}
	}
	for(i = 1; i <=  TEST ; i++)
	{
		for (j=1;j<=NUMIN;j++)
			{
Input[i][j]=testInputValues[index];
index++;

}
	}

index=0;
	for(i=0;i<= TEST ;i++)

	{
		for (j=0;j<=1;j++)
		{
			Target[i][j]=0;
		}
	}
	for(i = 1; i <=  TEST ; i++)
	{
		for (j=1;j<=1;j++)
		{
Target[i][j]=testOutputValues[index];
index++;

		}
	}

	for( p = 1 ; p <= TEST ; p++ ) {
		for( k = 1 ; k <= NumOutput  ; k++ ) {
		}
	}














	for( np = 1 ; np <= TEST ; np++ ) { 

		for( j = 1 ; j <= NumHidden1 ; j++ ) {    
			SumH[p][j] = WeightIH[0][j] ;
			for( i = 1 ; i <= NumInput ; i++ ) {
				SumH[p][j] += Input[p][i] * WeightIH[i][j] ;
			}
			Hidden1[p][j] = 1.0/(1.0 + exponential(10,-SumH[p][j])) ;
		}



		for( j = 1 ; j <= NumHidden2 ; j++ ) {   
			SumH1[p][j] = WeightHH1[0][j] ;
			for( i = 1 ; i <= NumHidden1 ; i++ ) {
				SumH1[p][j] += Hidden1[p][i] * WeightHH1[i][j] ;
			}
			Hidden2[p][j] = 1.0/(1.0 + exponential(10,-SumH1[p][j])) ;
		}
		for( j = 1 ; j <= NumHidden3 ; j++ ) {    
			SumH2[p][j] = WeightHH2[0][j] ;
			for( i = 1 ; i <= NumHidden2 ; i++ ) {
				SumH2[p][j] += Hidden2[p][i] * WeightHH2[i][j] ;
			}
			Hidden3[p][j] = 1.0/(1.0 + exponential(10,-SumH2[p][j])) ;
		}


		for( k = 1 ; k <= NumOutput ; k++ ) {    
			SumO[p][k] = WeightHO[0][k] ;
			for( j = 1 ; j <= NumHidden3 ; j++ ) {
				SumO[p][k] += Hidden3[p][j] * WeightHO[j][k] ;
			}
			Output[p][k] = SumO[p][k];

		}
	}

	for( p = 1 ; p <= TEST ; p++ ) {
		for( k = 1 ; k <= NumOutput  ; k++ ) {
			printf( "%f\t%f\t\n", Target[p][k], Output[p][k]) ;
		}
	}

	/*****************FINDING MINIMUM FOR LOOP TILING*******************************/

int tile,tile1;
	if(select==1)
	{
	float  min=1,min1=1;
		for( p = 1 ; p <= TEST ; p++ ) {
			for( k = 1 ; k <= NumOutput  ; k++ ) {
				if(Output[p][k]<min)
				{
                                  min=Output[p][k];
                                  tile= 16*p;
				}
                                   if(Target[p][k]<min1)
                                {
                                  min1=Target[p][k];
                                  tile1= 16*p;
                                }

			}
		}
printf("Optimal Tile Size  = %d\n",tile1);
printf("Obtained Tile Size  = %d",tile);

	}

	//    return 0;
}

/*******************************************************************************/
