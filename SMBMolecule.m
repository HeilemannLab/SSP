/* ######################################################################
* File Name: SMBMolecule.m
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
#####################################################################*/

#import <Foundation/Foundation.h>
#include <stdlib.h> 
#import "SMBMolecule.h"

@implementation SMBMolecule
//initializer
-(id) initWithNumberOfBindingSites:(unsigned) data
{
    self = [super init];
    if (self) {
        _numberOfBindingSites = data;
        _bindingEventList = [NSMutableArray array];
        _blinkingEventList = [NSMutableArray array];
	_blinkingEvents = 0;
    }
    return self;
}

-(id) init
{
	self = [self initWithNumberOfBindingSites: 0];
	return self;
}

//mutators
-(void) setNumberOfBindingSites:(unsigned) data
{
	_numberOfBindingSites = data;
}

-(unsigned) numberOfBindingSites
{
	return _numberOfBindingSites;
}

-(void) setP:(double*) data
{
	_p = data;
}

-(double*) p
{
	return _p;
}

-(void) setQ:(double*) data
{
	_q = data;
}

-(double*) q
{
	return _q;
}

-(NSMutableArray*) bindingEventList
{
	return _bindingEventList;
}

-(NSMutableArray*) blinkingEventList
{
	return _blinkingEventList;
}

-(unsigned) blinkingEvents
{
	return _blinkingEvents;
}

//simulation Methods
-(void) simPositiveBindingEvents
{
    double event = 0.0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        event = (rand() % 1000)/(double)1000;
        NSLog(@"event %u is %.2f.", i,event);
        if (event <= *_q){
    	    [_bindingEventList addObject: [NSNumber numberWithInt:0]];
        }
	else{
    	    [_bindingEventList addObject: [NSNumber numberWithInt:1]];
	}
    }
}

- (void) simMoleculeBlinking
{
    unsigned blinks = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        blinks = [self simBindingSiteBlinking: i];
        [_blinkingEventList addObject: [NSNumber numberWithInt: blinks]];
    }
}

- (unsigned) simBindingSiteBlinking: (unsigned) site
{
    unsigned blinks = 0;
    if ([[_bindingEventList objectAtIndex:site] intValue]){
        blinks = 1;
        bool result = [self checkBlinkingEvent];
        while (result){
            result = [self checkBlinkingEvent];
            ++blinks;
        }
    }
    return blinks;
}

- (bool) checkBlinkingEvent
{
    bool result=true;
    double event = (rand() % 1000)/(double)1000;
    if (event> *_p) result=false;
    return result;
}

- (void) sumBlinkingEvents
{
    _blinkingEvents = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        _blinkingEvents += [[_blinkingEventList objectAtIndex: i] intValue];
    }
}

// print functions
- (void) printBindingEventList
{
    NSLog(@"\nThe occupancy of the molecule's binding sites is\n %@", _bindingEventList);
}

- (void) printBlinkingEventList
{
    NSLog(@"\nThe blinking events of the molecule are\n %@", _blinkingEventList);
}

- (void) printBlinkingEvents
{
    NSLog(@"The detected blinking events of the molecul are %u", _blinkingEvents);
}

- (void) printMolecule
{
    [self printBindingEventList];
    [self printBlinkingEventList];
    [self printBlinkingEvents];
}

//deallocator
-(void) dealloc
{
	[_bindingEventList release];
	_bindingEventList = nil;
	[_blinkingEventList release];
	_blinkingEventList = nil;
	[super dealloc];
}

@end
