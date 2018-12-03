/* ######################################################################
* File Name: SMBMolecule.m
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
#####################################################################*/

#import <Foundation/Foundation.h>
#include <stdlib.h> 
#import "SMBMolecule.h"

@implementation SMBMolecule
//initializer
-(id) init:(unsigned) molData :(double*) pData :(double*) dData
{
    self = [super init];
    if (self) {
        _numberOfBindingSites = molData;
	_p = pData;
	_d = dData;
        _bindingEventList = [[NSMutableArray alloc] init];
        _fluorescenceEventList = [[NSMutableArray alloc] init];
	_fluorescenceEvents = 0;
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

-(void) setD:(double*) data
{
	_d = data;
}

-(double*) d
{
	return _d;
}

-(NSMutableArray*) bindingEventList
{
	return _bindingEventList;
}

-(unsigned) bindingEventAtSite:(unsigned) data
{
	return (unsigned int)[[_bindingEventList objectAtIndex: data] unsignedLongValue];
}

-(NSMutableArray*) fluorescenceEventList
{
	return _fluorescenceEventList;
}

-(unsigned) fluorescenceEventsAtSite:(unsigned) data
{
	return (unsigned int)[[_fluorescenceEventList objectAtIndex: data] unsignedLongValue];
}

-(unsigned) numberOfActiveBindingSites
{
	unsigned activeSites=0;
	for (unsigned i=0; i<[_bindingEventList count]; i++){
		activeSites += [[_bindingEventList objectAtIndex:i] unsignedLongValue];
	}
	return activeSites;
}

-(unsigned) fluorescenceEvents
{
	return _fluorescenceEvents;
}

//simulation Methods
-(void) simMolecule
{
	[self simPositiveBindingEvents];
	[self simMoleculeBlinking];
	[self sumFluorescenceEvents];
}

-(void) simPositiveBindingEvents
{
    double event = 0.0;
    [_bindingEventList removeAllObjects];
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        event = (rand() % 1000)/(double)1000;
        if (event <= *_d){
    	    [_bindingEventList addObject: [NSNumber numberWithInt:1]];
        }
	else{
    	    [_bindingEventList addObject: [NSNumber numberWithInt:0]];
	}
    }
}

- (void) simMoleculeBlinking
{
    unsigned events = 0;
    [_fluorescenceEventList removeAllObjects];
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        events = [self simBindingSiteBlinking: i];
        [_fluorescenceEventList addObject: [NSNumber numberWithInt: events]];
    }
}

- (unsigned) simBindingSiteBlinking: (unsigned) site
{
    unsigned events = 0;
    if ([[_bindingEventList objectAtIndex:site] intValue]){
        events = 1;
        bool result = [self checkFluorescenceEvent];
        while (result){
            ++events;
            result = [self checkFluorescenceEvent];
        }
    }
    return events;
}

- (bool) checkFluorescenceEvent
{
    bool result=true;
    double event = (rand() % 1000)/(double)1000;
    if (event <= *_p) result=false;
    return result;
}

- (void) sumFluorescenceEvents
{
    _fluorescenceEvents = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        _fluorescenceEvents += [[_fluorescenceEventList objectAtIndex: i] intValue];
    }
}

// print functions
- (void) printBindingEventList
{
    NSLog(@"\nThe occupancy of the molecule's binding sites is\n %@", _bindingEventList);
}

- (void) printFluorescenceEventList
{
    NSLog(@"\nThe fluorescence events of the molecule are\n %@", _fluorescenceEventList);
}

- (void) printFluorescenceEvents
{
    NSLog(@"The detected fluorescence events of the molecule are %u", _fluorescenceEvents);
}

- (void) printMolecule
{
    [self printBindingEventList];
    [self printFluorescenceEventList];
    [self printFluorescenceEvents];
}

//deallocator
-(void) dealloc
{
	[_bindingEventList release];
	_bindingEventList = nil;
	[_fluorescenceEventList release];
	_fluorescenceEventList = nil;
	[super dealloc];
}

@end
