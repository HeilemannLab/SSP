/* ######################################################################
* File Name: SMBMolecule.m
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
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

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
#####################################################################*/

#import <Foundation/Foundation.h>
#include <stdlib.h> 
#import "SMBMolecule.h"

@implementation SMBMolecule
//initializer
-(id) init:(unsigned) molData :(double*) pData :(double*) qData
{
    self = [super init];
    if (self) {
        _numberOfBindingSites = molData;
	_p = pData;
	_q = qData;
        _bindingEventList = [[NSMutableArray alloc] init];
        _blinkingEventList = [[NSMutableArray alloc] init];
	_blinkingEvents = 0;
    }
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

-(unsigned) bindingEventAtSite:(unsigned) data
{
	return [[_bindingEventList objectAtIndex: data] unsignedLongValue];
}

-(NSMutableArray*) blinkingEventList
{
	return _blinkingEventList;
}

-(unsigned) blinkingEventsAtSite:(unsigned) data
{
	return [[_blinkingEventList objectAtIndex: data] unsignedLongValue];
}

-(unsigned) numberOfActiveBindingSites
{
	unsigned activeSites=0;
	for (unsigned i=0; i<[_bindingEventList count]; i++){
		activeSites += [[_bindingEventList objectAtIndex:i] unsignedLongValue];
	}
	return activeSites;
}

-(unsigned) blinkingEvents
{
	return _blinkingEvents;
}

//simulation Methods
-(void) simMolecule
{
	[self simPositiveBindingEvents];
	[self simMoleculeBlinking];
	[self sumBlinkingEvents];
}

-(void) simPositiveBindingEvents
{
    double event = 0.0;
    [_bindingEventList removeAllObjects];
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        event = (rand() % 1000)/(double)1000;
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
    [_blinkingEventList removeAllObjects];
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
            ++blinks;
            result = [self checkBlinkingEvent];
        }
    }
    return blinks;
}

- (bool) checkBlinkingEvent
{
    bool result=true;
    double event = (rand() % 1000)/(double)1000;
    if (event <= *_p) result=false;
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
    NSLog(@"The detected blinking events of the molecule are %u", _blinkingEvents);
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
