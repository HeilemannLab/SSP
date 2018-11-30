/* ######################################################################
* File Name: SMBHistogram.m
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

#import <Foundation/Foundation.h>
#import "SMBHistogram.h"

@implementation SMBHistogram
// initializer
-(id) init
{
	self = [super init];
	if (self){
		_lowerBound = 0;
		_upperBound = 0;
		_eventNumber = 0;
		_eventCoordinate = [[NSMutableArray alloc] init];
		_rawOccurrence = [[NSMutableArray alloc] init];
		_normOccurrence = [[NSMutableArray alloc] init];
		_histFileName = [[NSMutableString alloc] init];
	}
	return self;
}

//mutators
-(void) setHistFileName:(NSMutableString*) data
{
	[data retain];
	_histFileName = [data copy];
	[data release];
}

//array functions
-(unsigned) sumUnsignedArray:(NSMutableArray*) data
{
	[data retain];
	unsigned sum = 0;
	for (unsigned i=0; i<[data count]; i++) sum += [[data objectAtIndex: i] unsignedIntValue];
	[data release];
	return sum;
}

-(double) sumDoubleArray:(NSMutableArray*) data
{
	[data retain];
	double sum = 0;
	for (unsigned i=0; i<[data count]; i++) sum += [[data objectAtIndex: i] doubleValue];
	[data release];
	return sum;
}

-(unsigned) binarySearchEvent:(unsigned) data
{
	unsigned l = 0;
	unsigned r = (unsigned int)[_eventCoordinate count]-1;
	unsigned m = 0;
	while (l<r){
		m = floor((l+r)/2); 
		if ([[_eventCoordinate objectAtIndex: m] unsignedIntValue] < data){
			l = m + 1;
		}
		else{
			r = m;
		}
	}	
	return l;
}

//proof functions
-(bool) checkEventNumber
{
	bool result = true;
	if (_eventNumber < 1){
		result = false;
		[self printEventNumberError];
	}
	return result;
}

-(bool) checkEventCoordinate
{
	bool result = true;
	unsigned entries = [_eventCoordinate count];
	if (entries < 1){
		result = false;
		[self printEventCoordinateError];
	}
	return result;
}

-(bool) checkRawOccurrence
{
	bool result = true;
	unsigned entries = [_rawOccurrence count];
	if (entries < 1){
		result = false;
		[self printRawOccurrenceError];
	}
	return result;
}

-(bool) checkNormOccurrence
{
	bool result = true;
	unsigned entries = [_normOccurrence count];
	if (entries < 1){
		result = false;
		[self printNormOccurrenceError];
	}
	else{
		double sum = [self sumDoubleArray: _normOccurrence];
		if ((sum > 1.000000001) || (sum<0.99999999)){
			result = false;
			[self printNormalizationError]; 
		}
	}
	return result;
}

-(bool) checkArrayCompatibility
{
	bool result = true;
	if ([_eventCoordinate count] != [_rawOccurrence count]){
		result = false;
		[self printRawSizeError];
	}
	if ([_eventCoordinate count] != [_normOccurrence count]){
		result = false;
		[self printNormSizeError];
	}
	return result;
}

-(bool) checkHistogramValidity
{
	bool result = true;
	bool c1=[self checkEventNumber];
	bool c2=[self checkEventCoordinate];
	bool c3=[self checkRawOccurrence];
	bool c4=[self checkNormOccurrence];
	bool c5=[self checkArrayCompatibility];
	if(((((!c1)||(!c2))||(!c3))||(!c4))||(!c5)) result = false;
	return result;
}

-(void) determineUpperBound:(NSMutableArray*) data
{
	[data retain];
	unsigned bound = 0;
	unsigned temp;
	for (unsigned i = 0; i<[data count]; i++){
		temp = [[data objectAtIndex:i] unsignedIntValue];
		if (bound < temp) bound = temp;
	}
	_upperBound = bound;
	[data release];
}

-(void) calculateEventCoordinate
{
	[_eventCoordinate removeAllObjects];
	for(unsigned i=0; i<_upperBound; i++){
		[_eventCoordinate addObject:[NSNumber numberWithUnsignedInt: i]];
	}
}

-(void) calculateRawOccurrence:(NSMutableArray*) data
{
	[data retain];
	[_rawOccurrence removeAllObjects];
	for(unsigned i=0; i<[_eventCoordinate count]; i++){
		[_rawOccurrence addObject:[NSNumber numberWithUnsignedInt: 0]];
	}
	unsigned tempEvent;
	unsigned eventIndex;
	unsigned eventSum;
	for (unsigned i=0; i<[data count]; i++){
		tempEvent = [[data objectAtIndex:i] unsignedIntValue];
		if (tempEvent > 0){
			eventIndex = [self binarySearchEvent: tempEvent-1];
			eventSum = [[_rawOccurrence objectAtIndex: eventIndex] unsignedIntValue];
			eventSum += 1;
			[_rawOccurrence replaceObjectAtIndex:eventIndex withObject:[NSNumber numberWithUnsignedInt: eventSum]];
			
		}
	}
	[data release];
}

-(void) normalizeOccurrence
{
	double tempProb;
	[_normOccurrence removeAllObjects];
	_eventNumber = [self sumUnsignedArray: _rawOccurrence];
	for(unsigned i=0; i<[_rawOccurrence count]; i++){
		tempProb = [[_rawOccurrence objectAtIndex:i] doubleValue]/(double)_eventNumber;
		[_normOccurrence addObject:[NSNumber numberWithDouble: tempProb]];
	}

}

-(void) calculateHistogram:(NSMutableArray*) data
{
	[data retain];
	[self determineUpperBound: data];
	[self calculateEventCoordinate];
	[self calculateRawOccurrence: data];
	[self normalizeOccurrence];
	[self checkHistogramValidity];
	[data release];
}

//write functions
-(void) writeHistogram
{
	FILE* stream;
	if ((stream = fopen([_histFileName UTF8String], "w")) != NULL){
		fprintf(stream, "#SSP blinking occurrence histogram file\n");
		fprintf(stream, "#blinks\traw\tnormalized\n");
		for (unsigned i=0; i<[_eventCoordinate count]; i++){
			fprintf(stream, "%i\t%i\t%.5f\n",
			[[_eventCoordinate objectAtIndex: i] unsignedIntValue],
			[[_rawOccurrence objectAtIndex: i] unsignedIntValue],
			[[_normOccurrence objectAtIndex: i] doubleValue]);
		}
		fclose(stream);
	}
	else{
		NSLog(@"Error: Could not write simulation histogram to file %@. Make sure you have the rights to access it.", _histFileName);
	}
}

//print functions
-(void) printHistogram
{
	NSLog(@"ssp histogram:");
	for (unsigned i=0; i < [_eventCoordinate count]; i++){
		printf("%i\t%i\t%.3f\n",
		[[_eventCoordinate objectAtIndex: i] unsignedIntValue],
		[[_rawOccurrence objectAtIndex: i] unsignedIntValue],
		[[_normOccurrence objectAtIndex: i] doubleValue]);
	}
}

-(void) printEventNumberError
{
	NSLog(@"Event Number Error: The event number needs to be of type unsigned integer!");
}

-(void) printEventCoordinateError
{
	NSLog(@"Event Coordinate Error: The eventCoordinate array needs to be of positive size.");
}

-(void) printRawOccurrenceError
{
	NSLog(@"Raw Occurrence Error: The rawOccurrence array needs to be of positive size.");
}

-(void) printNormOccurrenceError
{
	NSLog(@"Norm Occurrence Error: The normOccurrence array needs to be of positive size.");
}

-(void) printNormalizationError
{
	NSLog(@"Normalization Error: Integration of normOccurrence array needs to be exactly 1.");
}

-(void) printRawSizeError
{
	NSLog(@"Raw Size Error: eventCoordinate and rawOccurrence arrays need to be of identical size.");
}

-(void) printNormSizeError
{
	NSLog(@"Norm Size Error: eventCoordinate and normOccurrence arrays need to be of identical size.");
}

//deallocator
-(void)dealloc
{
	[_eventCoordinate release];
	_eventCoordinate = nil;
	[_rawOccurrence release];
	_rawOccurrence = nil;
	[_normOccurrence release];
	_normOccurrence = nil;
	[_histFileName release];
	_histFileName = nil;
	[super dealloc];
}
@end
