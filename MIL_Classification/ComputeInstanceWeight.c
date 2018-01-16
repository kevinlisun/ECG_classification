#include "mex.h"
#include <stdio.h>
#include "math.h"

double computeRBFDistance( double* inst, int i, int j, int dim )
{
    double distance = 0;
    int k;
    for( k=0; k<dim; k++)
    {
        distance += (*(inst+i*dim+k)-*(inst+j*dim+k))*(*(inst+i*dim+k)-*(inst+j*dim+k));
    }
    return pow(2.71828,-distance);
}

void ComputeWeight(double *instances, double *weights, int n, int dim)
{
	double **distanceMatrix;
	int i,j;
    double threshold, normalize;

	distanceMatrix = (double **)malloc(sizeof(double*)*n);
	for( i = 0; i < n; i++ )
		*(distanceMatrix+i) = (double *)malloc(sizeof(double)*n);

	for( i = 0; i < n; i++)
		*(*(distanceMatrix+i)+j)= 0;

	threshold = 0;
    for( i = 0; i < n; i++ )
		for( j = i+1; j < n; j++ )
		{
			*(*(distanceMatrix+i)+j) = computeRBFDistance( instances, i, j, dim );
			*(*(distanceMatrix+j)+i) = *(*(distanceMatrix+i)+j);
			threshold += (*(*(distanceMatrix+i)+j)*2);
		}

	threshold /= n*n;

	for( i = 0; i < n; i++ )
		for( j = i+1; j < n; j++ )
		{
			if( *(*(distanceMatrix+i)+j) < threshold )
				*(*(distanceMatrix+i)+j) = 0;
			else
				*(*(distanceMatrix+i)+j) = 1;
	        
			*(*(distanceMatrix+j)+i) = *(*(distanceMatrix+i)+j);
		}

	normalize = 0;
	for( i = 0; i < n; i++ )
	{
		*(weights+i) = 0;
		for( j = 0; j < n; j++ )
		{
			*(weights+i) += *(*(distanceMatrix+i)+j);
		}
		if( *(weights+i) == 0 )
			*(weights+i) = 0.5;
		*(weights+i) = 1 / *(weights+i);
		normalize += *(weights+i);
	}

	for( i = 0; i < n; i++ )
		*(weights+i) /= normalize;

}



void mexFunction(int nlhs,mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
    double *instances;
    double *weights;

    int k, M, N;
    instances = mxGetPr(prhs[0]);
	M = mxGetM(prhs[0]);
	N = mxGetN(prhs[0]);
    plhs[0] = mxCreateDoubleMatrix(1, M, mxREAL);
    weights = mxGetPr(plhs[0]);
    ComputeWeight(instances, weights, M, N);

}