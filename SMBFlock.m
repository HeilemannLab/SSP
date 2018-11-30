/* ######################################################################
* File Name: SMBFlock.m
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Contact: <malkusch@chemie.uni-frankfurt.de>
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
*
* License
* Copyright (C) 2018  Sebastian Malkusch
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
###################################################################### */


#import <Foundation/Foundation.h>
#import "SMBFlock.h"
#import "SMBMolecule.h"

@implementation SMBFlock
// initializer
-(id) init
{
	self = [super init];
	if (self){
		_numberOfMolecules = 0;
		_p = 0.0;
		_d = 0.0;
		_moleculePDF = [[NSMutableArray alloc] init];
		_moleculeCDF = [[NSMutableArray alloc] init];
		_molecules = [[NSMutableArray alloc] init];
		_actions = [[SMBActions alloc] init];
		_histogram = [[SMBHistogram alloc] init];
		_fileNames = [[SMBFileNames alloc] init];
		//create Filenames!!!
		[_fileNames createFileNames];
	}
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

-(void) setD:(double) data
{
	_d = data;
}

-(void) setMoleculePDF:(NSMutableArray*) data
{
	_moleculePDF = [data copy];
}

// import functions
-(void) importParser:(NSMutableArray*) data
{
	[data retain];
	//check data for length
	_numberOfMolecules = [[data objectAtIndex: 0] unsignedIntValue];
	_p = [[data objectAtIndex: 1] doubleValue];
	_d = [[data objectAtIndex: 2] doubleValue];
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

// search functions
-(unsigned) binarySearchCDF:(double) data
{
	unsigned l = 0;
	unsigned r = (unsigned int)[_moleculeCDF count]-1;
	unsigned m = 0;
	while (l<r){
		m = floor((l+r)/2); 
		if ([[_moleculeCDF objectAtIndex: m] doubleValue] < data){
			l = m + 1;
		}
		else{
			r = m;
		}
	}	
	return l;
}

// simulation Fuctions
-(unsigned) simMoleculeType
{
	unsigned type = 0;
	double event = (rand() % 1000)/(double) 1000.0;
	type = [self binarySearchCDF: event]+1;
	return type;
}

-(void) initActions
{
	[_actions runActions];
}

-(void) initMolecules
{
	[_molecules removeAllObjects];
	for(unsigned i=0; i<_numberOfMolecules; i++){
		[_molecules addObject: [[SMBMolecule alloc]init:[self simMoleculeType] :&_p :&_d]];
		[[_molecules objectAtIndex:i] release];
	}
}

-(void) runSimulation
{
	for(unsigned i=0; i<_numberOfMolecules; i++){
		[[_molecules objectAtIndex:i] simMolecule];
	}
}

-(void) determineBlinkingStatistics
{
	double blinks;
	NSMutableArray* blinkArray = [[NSMutableArray alloc] init];
	for (unsigned i=0; i<[_molecules count]; i++){
		blinks = [[_molecules objectAtIndex: i] blinkingEvents]; 
		[blinkArray addObject:[NSNumber numberWithDouble: blinks]];
	}
	[_histogram calculateHistogram: blinkArray];
	[blinkArray release]; 
}

// proof functions
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
	bool c3=[self checkProbability: _d];
	if(((!c1)||(!c2))||(!c3)) result = false;
	return result;
}

//write functions
-(void) logSimulation
{
	[self writeSimulationParameterToFile: [_fileNames simParameterFileName]];
	[self writeSimulationResultToFile: [_fileNames simResultFileName]];
	[self writeSimulationStatisticsToFile: [_fileNames simStatisticsFileName]];
	[self writeSimulationHistogramToFile: [_fileNames simHistFileName]];
}
-(void) writeSimulationParameterToFile: (NSMutableString*) data
{
	[data retain];
	FILE* stream;
	if ((stream = fopen([data UTF8String], "w")) != NULL){
		fprintf(stream, "#SSP parameter file\n");
		fprintf(stream, "#p:\n%.3f\n", _p);
		fprintf(stream, "#d:\n%.3f\n", _d);
		fprintf(stream, "#n:\n%i\n", _numberOfMolecules);
		fprintf(stream, "# probability density function of molecule types:\n");
		for (unsigned i=0; i<[_moleculePDF count]; i++){
			fprintf(stream, "%.3f\t", [[_moleculePDF objectAtIndex:i] doubleValue]);
		}
		fprintf(stream, "\n# cummulative density function of molecule types:\n");
		for (unsigned i=0; i<[_moleculeCDF count]; i++){
			fprintf(stream, "%.3f\t", [[_moleculeCDF objectAtIndex:i] doubleValue]);
		}
		
	fclose(stream);
	}
	else{
		NSLog(@"Error: Could not write simulation parameters to file %@. Make sure you have the rights to access it.", data);
	}
	[data release];
}

-(void) writeSimulationResultToFile: (NSMutableString*) data
{
	[data retain];
	unsigned a, b;
	FILE* stream;
	if ((stream = fopen([data UTF8String], "w")) != NULL){
		fprintf(stream, "#SSP result file\n");
		fprintf(stream, "#molecule\tactivity\tblinks\n");
		for (unsigned i=0; i<_numberOfMolecules; i++){
			for (unsigned j=0; j<[[_molecules objectAtIndex:i] numberOfBindingSites]; j++){
				a = [[_molecules objectAtIndex: i] bindingEventAtSite: j];
				b = [[_molecules objectAtIndex: i] blinkingEventsAtSite: j];
				fprintf(stream, "%u\t%u\t%u\n", i,a,b);
			}
		}
		
	fclose(stream);
	}
	else{
		NSLog(@"Error: Could not write simulation results to file %@. Make sure you have the rights to access it.", data);
	}
	[data release];
}

-(void) writeSimulationStatisticsToFile: (NSMutableString*) data
{
	[data retain];
	unsigned s, a, b;
	FILE* stream;
	if ((stream = fopen([data UTF8String], "w")) != NULL){
		fprintf(stream, "#SSP statistics file\n");
		fprintf(stream, "#molecule\tsites\tactivity\tblinks\n");
		for (unsigned i=0; i<_numberOfMolecules; i++){
			s = [[_molecules objectAtIndex: i] numberOfBindingSites];
			a = [[_molecules objectAtIndex: i] numberOfActiveBindingSites];
			b = [[_molecules objectAtIndex: i] blinkingEvents]; 
			fprintf(stream, "%u\t%u\t%u\t%u\n", i,s,a,b);
		}
		fclose(stream);
	}
	else{
		NSLog(@"Error: Could not write simulation statistics to file %@. Make sure you have the rights to access it.", data);
	}
	[data release];
}

-(void) writeSimulationHistogramToFile: (NSMutableString*) data
{
	[data retain];
	[_histogram setHistFileName: data];
	[_histogram writeHistogram];
	[data release];
}

//print functions
-(void) printFlockParameter
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"SSP simulation parameters:"];
	[message appendFormat: @"\nmolecules:\t%i", _numberOfMolecules];
	[message appendFormat: @"\np:\t%.2f", _p];
	[message appendFormat: @"\nd:\t%.2f", _d];
	[message appendString: @"\nstate\tPDF\tCDF\n"];
	for (unsigned i=0; i<[_moleculePDF count]; i++){
		[message appendFormat: @"# %i", i+1];
		[message appendFormat: @"\t%.3f", [[_moleculePDF objectAtIndex: i] doubleValue]];
		[message appendFormat: @"\t%.3f\n", [[_moleculeCDF objectAtIndex: i] doubleValue]];
	}
	[message appendString: @"\n"];
	NSLog(@"%@", message);
	[message release];
}

-(void) printMolecules
{
	for(unsigned i=0; i<_numberOfMolecules; i++){
		[[_molecules objectAtIndex:i] printMolecule];
	}
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
	[_moleculePDF release];
	_moleculePDF = nil;
	[_moleculeCDF release];
	_moleculeCDF = nil;
	[_molecules release];
	_molecules = nil;
	[_actions release];
	_actions = nil;
	[_histogram release];
	_histogram = nil;
	[_fileNames release];
	_fileNames = nil;
	[super dealloc];
}

@end

