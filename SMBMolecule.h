/* ######################################################################
* File Name: SMBMolecule.h
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
#####################################################################*/



#ifndef SMBMolecule_h
#define SMBMolecule_h
#import <Foundation/Foundation.h>

@interface SMBMolecule : NSObject
{
	unsigned _numberOfBindingSites;
	double* _p;
	double* _q;
	NSMutableArray* _bindingEventList;
	NSMutableArray* _blinkingEventList;
	unsigned _blinkingEvents;
}

//initializer
-(id) initWithNumberOfBindingSites: (unsigned) data;
-(id) init;

//mutators
-(void) setNumberOfBindingSites:(unsigned) data;
-(unsigned) numberOfBindingSites;
-(void) setP:(double*) data;
-(double*) p;
-(void) setQ:(double*) data;
-(double*) q;
-(NSMutableArray*) bindingEventList;
-(NSMutableArray*) blinkingEventList;
-(unsigned) blinkingEvents;

// simulation methods
- (void) simPositiveBindingEvents;

- (void) simMoleculeBlinking;
- (unsigned) simBindingSiteBlinking: (unsigned) site;
- (bool) checkBlinkingEvent;
- (void) sumBlinkingEvents;

//print functions
- (void) printBindingEventList;
- (void) printBlinkingEventList;
- (void) printBlinkingEvents;
- (void) printMolecule;

//deallocator
-(void) dealloc;
@end

#endif /* SMBMolecule_h */
