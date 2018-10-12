/* ######################################################################
* File Name: SMBFlock.m
* Project: SMBFlock
* Version: 18.10
* Creation Date: 10.10.2018
* Created By Sebastian Malkusch
* <malkusch@chemie.uni-frankfurt.de>
* Goethe University of Frankfurt
* Physical and Theoretical Chemistry
* Single Molecule Biophysics
###################################################################### */


#import <Foundation/Foundation.h>
#import "SMBFlock.h"

@implementation SMBFlock
// initializer
-(id) init
{
	self = [super init];
	_numberOfMolecules = 0;
	_p = 0.0;
	_q = 0.0;
	_moleculePDF = [[[NSMutableArray alloc] init] retain];
	_moleculeCDF = [[[NSMutableArray alloc] init] retain];
	_molecules = [[[NSMutableArray alloc] init] retain];
	_creationTime = [[NSDate date] retain];
	_parameterFileName = [[[NSMutableString alloc] init] retain];
	_resultFileName = [[[NSMutableString alloc] init] retain];
	_statisticsFileName = [[[NSMutableString alloc] init] retain];
	//create Filenames!!!
	return self;
}

// mutators
-(void) setNumberOfMolecules:(unsigned) data
{
	_numberOfMolecules = data;
}

-(void) setP:(double) data
{
	_p = data;
}

-(void) setQ:(double) data
{
	_q = data;
}

-(void) setMoleculePDF:(NSMutableArray*) data
{
	_moleculePDF = [data copy];
}

// special sunctions
-(void) importParser:(NSMutableArray*) data
{
	[data retain];
	//check data for length
	_numberOfMolecules = [[data objectAtIndex: 0] unsignedIntValue];
	_p = [[data objectAtIndex: 1] doubleValue];
	_q = [[data objectAtIndex: 2] doubleValue];
	[_moleculePDF removeAllObjects];
	for (unsigned i=3; i< [data count]; i++){
		[_moleculePDF addObject: [[data objectAtIndex:i] copy]];
	}
	[self calculateCDF];
	[data release];
}

-(void) calculateCDF
{
	[_moleculeCDF removeAllObjects];
	double cdfEntry = 0.0;
	for (unsigned i=0; i<[_moleculePDF count]; i++){
		cdfEntry += [[_moleculePDF objectAtIndex: i] doubleValue];
		[_moleculeCDF addObject:[NSNumber numberWithDouble: cdfEntry]];
	}
}

//proof functions
-(bool) checkPDF
{
	bool result = true;
	double sum = 0.0;
	for (unsigned i=0; i<[_moleculePDF count]; i++){
		sum += [[_moleculePDF objectAtIndex:i] doubleValue];
	}
	if (sum!=1.0){
		[self printPDFError];
		result=false;
	}
	return result;
}

-(bool) checkProbability:(double) data
{
	bool result = true;
	if((data>1.0) || (data<0.0)){
		[self printProbabilityError: data];
		result = false;
	}
	return result;
}

-(bool) checkFlockValidity
{
	bool result =true;
	bool c1=[self checkPDF];
	bool c2=[self checkProbability: _p];
	bool c3=[self checkProbability: _q];
	if(((!c1)||(!c2))||(!c3)) result = false;
	return result;
}

//write functions
//print functions
-(void) printFlockParameter
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"SSP simulation parameters:"];
	[message appendFormat: @"\nmolecules:\t%i", _numberOfMolecules];
	[message appendFormat: @"\np:\t%.2f", _p];
	[message appendFormat: @"\nq:\t%.2f", _q];
	[message appendString: @"\nstate\tPDF\tCDF\n"];
	for (unsigned i=0; i<[_moleculePDF count]; i++){
		[message appendFormat: @"# %i", i+1];
		[message appendFormat: @"\t%.3f", [[_moleculePDF objectAtIndex: i] doubleValue]];
		[message appendFormat: @"\t%.3f\n", [[_moleculeCDF objectAtIndex: i] doubleValue]];
	}
	[message appendString: @"\n"];
	NSLog(message);
	[message release];
}

-(void) printProbabilityError:(double) data
{
	NSLog(@"Error: %.2f is not a valid probability: p=[0.0; 1.0]!", data);
}

-(void) printPDFError
{
	NSLog(@"Error: PDF does not sum up to 1.0!");
}

// deallocator
-(void) dealloc
{
	NSLog(@"Flock is deallocated.");
	[_moleculePDF release];
	_moleculePDF = nil;
	[_moleculeCDF release];
	_moleculeCDF = nil;
	[_molecules release];
	_molecules = nil;
	[_creationTime release];
	_creationTime = nil;
	[_parameterFileName release];
	_parameterFileName = nil;
	[_resultFileName release];
	_resultFileName = nil;
	[_statisticsFileName release];
	_statisticsFileName = nil;
	[super dealloc];
}

@end

