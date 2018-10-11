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
	[data release];
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

