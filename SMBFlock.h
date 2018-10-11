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

@interface SMBFlock : NSObject
{
	unsigned _numberOfMolecules;
	double _p;
	double _q;
	NSMutableArray* _moleculePDF;
	NSMutableArray* _moleculeCDF;
	NSMutableArray* _molecules;
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

//special functions
-(void) importParser:(NSMutableArray*) data;

//write functions

//print functions
-(void) printFlockParameter;

//deallocator
-(void) dealloc;
@end

#endif
