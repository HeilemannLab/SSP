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
#import "SMBMolecule.h"

@implementation SMBFlock
// initializer
-(id) init
{
	self = [super init];
	if (self){
		_numberOfMolecules = 0;
		_p = 0.0;
		_q = 0.0;
		_moleculePDF = [[NSMutableArray alloc] init];
		_moleculeCDF = [[NSMutableArray alloc] init];
		_molecules = [[NSMutableArray alloc] init];
		_actions = [[SMBActions alloc] init];
		// SMBActions!!
		_creationTime = [[NSDate alloc] init];
		_parameterFileName = [[NSMutableString alloc] init];
		_resultFileName = [[NSMutableString alloc] init];
		_statisticsFileName = [[NSMutableString alloc] init];
		//create Filenames!!!
		[self createFileNames];
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

-(void) setQ:(double) data
{
	_q = data;
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

// search functions
-(unsigned) binarySearchCDF:(double) data
{
	unsigned l = 0;
	unsigned r = [_moleculeCDF count];
	unsigned m = 0;
	while (l<r){
		m = floor((l+r)/2); 
		if ([[_moleculePDF objectAtIndex: m] doubleValue] < data){
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
	type = [self binarySearchCDF: event] + 1;
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
		[_molecules addObject: [[SMBMolecule alloc]init:[self simMoleculeType] :&_p :&_q]];
		[[_molecules objectAtIndex:i] release];
	}
}

-(void) runSimulation
{
	for(unsigned i=0; i<_numberOfMolecules; i++){
		[[_molecules objectAtIndex:i] simMolecule];
	}
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
	bool c3=[self checkProbability: _q];
	if(((!c1)||(!c2))||(!c3)) result = false;
	return result;
}

//write functions
-(void) createFileNames
{
	[self createParameterFileName];
	[self createResultsFileName];
	[self createStatisticsFileName];
}
-(void) createParameterFileName
{
	[_parameterFileName deleteCharactersInRange: NSMakeRange(0, [_parameterFileName length])];
	[_parameterFileName appendString: @"ssp_at_"];
	[_parameterFileName appendString: [_creationTime description]];
	[_parameterFileName appendString: @"_parameter.txt"];
	[_parameterFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_parameterFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_parameterFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_parameterFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

-(void) createResultsFileName
{
	[_resultFileName deleteCharactersInRange: NSMakeRange(0, [_resultFileName length])];
	[_resultFileName appendString: @"ssp_at_"];
	[_resultFileName appendString: [_creationTime description]];
	[_resultFileName appendString: @"_results.txt"];
	[_resultFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_resultFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_resultFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_resultFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

-(void) createStatisticsFileName
{
	[_statisticsFileName deleteCharactersInRange: NSMakeRange(0, [_statisticsFileName length])];
	[_statisticsFileName appendString: @"ssp_at_"];
	[_statisticsFileName appendString: [_creationTime description]];
	[_statisticsFileName appendString: @"_statistics.txt"];
	[_statisticsFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_statisticsFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_statisticsFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_statisticsFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

-(void) logSimulation
{
	[self writeSimulationParameters];
	[self writeSimulationResults];
	[self writeSimulationStatistics];
}
-(void) writeSimulationParameters
{
	FILE* stream;
	if ((stream = fopen([_parameterFileName UTF8String], "w")) != NULL){
		fprintf(stream, "#SSP parameter file\n");
		fprintf(stream, "#p:\n%.3f\n", _p);
		fprintf(stream, "#q:\n%.3f\n", _q);
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
		NSLog(@"Error: Could not write simulation parameters to file %@. Make sure you have the rights to access it.", _parameterFileName);
	}
}

-(void) writeSimulationResults
{
	unsigned a, b;
	FILE* stream;
	if ((stream = fopen([_resultFileName UTF8String], "w")) != NULL){
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
		NSLog(@"Error: Could not write simulation results to file %@. Make sure you have the rights to access it.", _resultFileName);
	}
}

-(void) writeSimulationStatistics
{
	unsigned s, a, b;
	FILE* stream;
	if ((stream = fopen([_statisticsFileName UTF8String], "w")) != NULL){
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
		NSLog(@"Error: Could not write simulation statistics to file %@. Make sure you have the rights to access it.", _statisticsFileName);
	}
}

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

