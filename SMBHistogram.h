/* ######################################################################
* File Name: SMBHistogram.h
* Project: SSP
* Version: 18.11
* Creation Date: 16.11.2018
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

#ifndef SMBHistogram_h
#define SMBHistogram_h

#import <Foundation/Foundation.h>

@interface SMBHistogram : NSObject
{
	unsigned _lowerBound;
	unsigned _upperBound;
	unsigned _eventNumber;
	NSMutableArray* _eventCoordinate;
	NSMutableArray* _rawOccurrence;
	NSMutableArray* _normOccurrence;
	NSMutableString* _histFileName;
}

//initializers
-(id) init;

//mutators
-(void) setHistFileName:(NSMutableString*) data;

//array functions
-(unsigned) sumUnsignedArray:(NSMutableArray*) data;
-(double) sumDoubleArray:(NSMutableArray*) data;
-(unsigned) binarySearchEvent:(unsigned) data;

//proof functions
-(bool) checkEventNumber;
-(bool) checkEventCoordinate;
-(bool) checkRawOccurrence;
-(bool) checkNormOccurrence;
-(bool) checkArrayCompatibility;
-(bool) checkHistogramValidity;

//Histogram caclulation functions
-(void) determineUpperBound:(NSMutableArray*) data;
-(void) calculateEventCoordinate;
-(void) calculateRawOccurrence:(NSMutableArray*) data;
-(void) normalizeOccurrence;
-(void) calculateHistogram:(NSMutableArray*) data;

//write functions
-(void) writeHistogram;

//print functions
-(void) printHistogram;
-(void) printEventNumberError;
-(void) printEventCoordinateError;
-(void) printRawOccurrenceError;
-(void) printNormOccurrenceError;
-(void) printNormalizationError;
-(void) printRawSizeError;
-(void) printNormSizeError;

//deallocator
-(void) dealloc;
@end
#endif
