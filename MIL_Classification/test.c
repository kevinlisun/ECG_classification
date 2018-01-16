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

double computeRBF( double* inst, double* centers, double * sigma, int i, int j, int dim )
{
    double distance = 0;
    int k;
    for( k=0; k<dim; k++)
    {
        distance += (*(inst+i*dim+k)-*(centers+j*dim+k))*(*(inst+i*dim+k)-*(centers+j*dim+k));
    }

    return pow(2.71828,-(distance)/(2*pow(*(sigma+j),2)));
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

void Convert(double *instances, double *newInstance, int n, int dim, int k, double *centers, double *sigmas, double *weights)
{
	int i, j;
	double **tempInstances;
    
    tempInstances = (double **)malloc(sizeof(double *)*n);
    for( i = 0; i < n; i++ )
        *(tempInstances+i) = (double *)malloc(sizeof(double)*k);

	for( i = 0; i < n; i++ )
	{
		for( j = 0; j < k; j++ )
		{
			tempInstances[i][j] = computeRBF( instances, centers, sigmas, i, j, dim );
		}
	}
	for( i = 0; i < k; i++ )
	{
		*(newInstance+i) = 0;
		for( j = 0; j < n; j++ )
		{
			*(newInstance+i) += *(weights+j) * tempInstances[j][i];
		}
	}
	free(tempInstances);

}




void mexFunction(int nlhs,mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
    double *instances;
    double *weights;
	double *newInstance;
    double *centers;
    double *sigmas;

    int k, M, N;
    instances = mxGetPr(prhs[0]);
	M = mxGetM(prhs[0]);
	N = mxGetN(prhs[0]);
	k = (int)*(mxGetPr(prhs[1]));
	centers = mxGetPr(prhs[2]);
	sigmas = mxGetPr(prhs[3]);
    //plhs[0] = mxCreateDoubleMatrix(1, M, mxREAL);
    //weights = mxGetPr(plhs[0]);
	weights = (double *)malloc(sizeof(double)*M);
    plhs[0] = mxCreateDoubleMatrix(1, k, mxREAL);
    newInstance = mxGetPr(plhs[0]);

    ComputeWeight(instances, weights, M, N);
    Convert(instances, newInstance, M, N, k, centers, sigmas, weights);
	free(weights);
}