/* ######################################################################
* File Name: SMBFlock.h
* Project: SMBFlock
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
#####################################################################*/

#ifndef SMBFlock_h
#define SMBFlock_h

#import <Foundation/Foundation.h>
#import"SMBActions.h"

@interface SMBFlock : NSObject
{
	unsigned _numberOfMolecules;
	double _p;
	double _q;
	NSMutableArray* _moleculePDF;
	NSMutableArray* _moleculeCDF;
	NSMutableArray* _molecules;
	SMBActions* _actions;
	NSDate* _creationTime;
	NSMutableString* _parameterFileName;
	NSMutableString* _resultFileName;
	NSMutableString* _statisticsFileName;
}

//initializers
-(id) init;

//mutators
-(void) setNumberOfMolecules:(unsigned) data;
-(void) setP:(double) data;
-(void) setQ:(double) data;
-(void) setMoleculePDF:(NSMutableArray*) data;

//import functions
-(void) importParser:(NSMutableArray*) data;
-(void) calculateCDF;

//search functions
-(unsigned) binarySearchCDF:(double) data;

// simulation functions
-(unsigned) simMoleculeType;
-(void) initActions;
-(void) initMolecules;
-(void) runSimulation;

//proof functions
-(bool) checkPDF;
-(bool) checkProbability:(double) data;
-(bool) checkFlockValidity;

//write functions
-(void) createFileNames;
-(void) createParameterFileName;
-(void) createResultsFileName;
-(void) createStatisticsFileName;
-(void) logSimulation;
-(void) writeSimulationParameters;
-(void) writeSimulationResults;
-(void) writeSimulationStatistics;

//print functions
-(void) printFlockParameter;
-(void) printMolecules;
-(void) printProbabilityError:(double) data;
-(void) printPDFError;

//deallocator
-(void) dealloc;
@end
#endif
