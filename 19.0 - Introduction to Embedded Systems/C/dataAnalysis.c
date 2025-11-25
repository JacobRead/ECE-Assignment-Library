/*
 dataAnalysis.c
 Jacob Read
 Implements the following data analysis funcitons:
	- AverageError
	- Linear
	- IsMonotonic
*/
#include <stdint.h>
#include <stdio.h>

int32_t AverageError(const int32_t Readings[], const uint32_t N);
int32_t Linear(int32_t const x);
int IsMonotonic(int32_t const Readings[], uint32_t const N);

// main function to test functions, comment out if using this as a source file
int main(){
	int32_t dataArray[] = {25000, 25000, 25001, 25007, 25013, 25013, 25015, 25015, 25015, 25015, 25020};
	int32_t expectedValue = Linear(50);

	printf("*******************************************\n");
	printf("************** DATA ANALYSIS **************\n");
	printf("*******************************************\n");
	printf("\n");
	printf("Point A is at -100, -50,000\n");
	printf("Point C is at 100, 50,000\n");
	printf("Between Points A and C, we know that point B is at x = 50\n");
	printf("We can estimate that point B is at 50, %d \n", Linear(50));
	printf("From our data array, we get an average error of %d \n", AverageError(dataArray, 11));
	if(IsMonotonic(dataArray, 11)) printf("Our incoming data is non-decreasing monotonic\n");
	else printf("Our incoming data is NOT non-decreasing monotonic\n");
	printf("\n");
	printf("*******************************************\n");
	printf("*******************************************\n");
	printf("*******************************************\n");
	return 0;
}

// Given an array of readings, and the array size:
// Calculate the average error of the values from our target value of 25000 (without rounding)
int32_t AverageError(const int32_t Readings[], const uint32_t N){
	int32_t expectedValue = 25000;
	int32_t averageError = 0;
	
	for(int i=0; i < N; i++){
		if(expectedValue - Readings[i] < 0) averageError -= expectedValue - Readings[i];
		else averageError += expectedValue - Readings[i];
	}
	return (averageError)/N;
}

// Given a x value for a point p3:
// Calculate the y value if it is on a linear graph with points P1 and P2
// P1: (-100, -50000)
// P2: (100, 50000)
int32_t Linear(int32_t const x){
	// Initial Values:
	int32_t pointOneX = -100;
	int32_t pointOneY = -50000;
	int32_t pointTwoX = 100;
	int32_t pointTwoY = 50000;
	
	// y = (m * x) + b
	int32_t slopeOfLine;
	int32_t yIntercept;
	
	// m = (y2 - y1) / (x2 - x1)
	slopeOfLine = (pointTwoY - pointOneY) / (pointTwoX	- pointOneX);
	// b = y1 - (m * x1)
	yIntercept = pointOneY - (slopeOfLine * pointOneX);
	
	// Return y3 = (m * x3) + b
  return (slopeOfLine * x) + yIntercept;
}

// Given a series of readings of size N:
// Return 1 if the series is non-decreasing monotonic, 0 if nonmonotonic
int IsMonotonic(int32_t const Readings[], uint32_t const N){
	for(int i = 1; i < N; i++){
		if(Readings[i] < Readings[i-1]) return 0;
	}
  return 1;
}
