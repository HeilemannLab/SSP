/* ######################################################################
* File Name: SMBMolecule.h
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

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
#####################################################################*/



#ifndef SMBMolecule_h
#define SMBMolecule_h
#import <Foundation/Foundation.h>

@interface SMBMolecule : NSObject
{
	unsigned _numberOfBindingSites;
	double* _p;
	double* _d;
	NSMutableArray* _bindingEventList;
	NSMutableArray* _fluorescenceEventList;
	unsigned _fluorescenceEvents;
}

//initializer
-(id) init: (unsigned) molData :(double*) pData :(double*) dData;

//mutators
-(void) setNumberOfBindingSites:(unsigned) data;
-(unsigned) numberOfBindingSites;
-(void) setP:(double*) data;
-(double*) p;
-(void) setD:(double*) data;
-(double*) d;
-(NSMutableArray*) bindingEventList;
-(unsigned) bindingEventAtSite:(unsigned) data;
-(NSMutableArray*) fluorescenceEventList;
-(unsigned) fluorescenceEventsAtSite:(unsigned) data;
-(unsigned) numberOfActiveBindingSites;
-(unsigned) fluorescenceEvents;

// simulation methods
-(void) simMolecule;
-(void) simPositiveBindingEvents;
-(void) simMoleculeBlinking;
-(unsigned) simBindingSiteBlinking: (unsigned) site;
-(bool) checkFluorescenceEvent;
-(void) sumFluorescenceEvents;

//print functions
-(void) printBindingEventList;
-(void) printFluorescenceEventList;
-(void) printFluorescenceEvents;
-(void) printMolecule;

//deallocator
-(void) dealloc;
@end

#endif /* SMBMolecule_h */
