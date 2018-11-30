/* ######################################################################
* File Name: SMBFileNames.m
* Project: SSP
* Version: 18.11
* Creation Date: 27.11.2018
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
#import "SMBFileNames.h"

@implementation SMBFileNames
// initializer
-(id) init
{
	self = [super init];
	if(self){
		_creationTime = [[NSDate alloc] init];
		_simParameterFileName = [[NSMutableString alloc] init];
		_simResultFileName = [[NSMutableString alloc] init];
		_simStatisticsFileName = [[NSMutableString alloc] init];
		_simHistFileName = [[NSMutableString alloc] init];
	}
	return self;
}

//mutators
-(NSMutableString*) simParameterFileName
{
	return _simParameterFileName;
}

-(NSMutableString*) simResultFileName
{
	return _simResultFileName;
}

-(NSMutableString*) simStatisticsFileName
{
	return _simStatisticsFileName;
}

-(NSMutableString*) simHistFileName
{
	return _simHistFileName;
}

//creation Frunctions
-(void) createFileNames
{
	[self createSimParameterFileName];
	[self createSimResultFileName];
	[self createSimStatisticsFileName];
	[self createSimHistFileName];
}

-(void) createSimParameterFileName
{
	[_simParameterFileName deleteCharactersInRange: NSMakeRange(0, [_simParameterFileName length])];
	[_simParameterFileName appendString: @"ssp_at_"];
	[_simParameterFileName appendString: [_creationTime description]];
	[_simParameterFileName appendString: @"_parameter.txt"];
	[_simParameterFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_simParameterFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_simParameterFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_simParameterFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];	
}

-(void) createSimResultFileName
{
	[_simResultFileName deleteCharactersInRange: NSMakeRange(0, [_simResultFileName length])];
	[_simResultFileName appendString: @"ssp_at_"];
	[_simResultFileName appendString: [_creationTime description]];
	[_simResultFileName appendString: @"_results.txt"];
	[_simResultFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_simResultFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_simResultFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_simResultFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

-(void) createSimStatisticsFileName
{
	[_simStatisticsFileName deleteCharactersInRange: NSMakeRange(0, [_simStatisticsFileName length])];
	[_simStatisticsFileName appendString: @"ssp_at_"];
	[_simStatisticsFileName appendString: [_creationTime description]];
	[_simStatisticsFileName appendString: @"_statistics.txt"];
	[_simStatisticsFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_simStatisticsFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_simStatisticsFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_simStatisticsFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

-(void) createSimHistFileName
{
	[_simHistFileName deleteCharactersInRange: NSMakeRange(0, [_simHistFileName length])];
	[_simHistFileName appendString: @"ssp_at_"];
	[_simHistFileName appendString: [_creationTime description]];
	[_simHistFileName appendString: @"_histogram.txt"];
	[_simHistFileName replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[_simHistFileName replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[_simHistFileName replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[_simHistFileName replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
}

//print Functions
-(void) printFileNames
{
	NSLog(@"ssp file names:\n");
	[self printSimParameterFileName];
	[self printSimResultFileName];
	[self printSimStatisticsFileName];
	[self printSimHistFileName];
}

-(void) printSimParameterFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"ssp parameter file name:\n"];
	[message appendFormat: @"%@\n", _simParameterFileName];
	NSLog(@"%@", message);
	[message release];
}

-(void) printSimResultFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"ssp result file name:\n"];
	[message appendFormat: @"%@\n", _simResultFileName];
	NSLog(@"%@", message);
	[message release];
}

-(void) printSimStatisticsFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"ssp statistics file name:\n"];
	[message appendFormat: @"%@\n", _simStatisticsFileName];
	NSLog(@"%@", message);
	[message release];
}

-(void) printSimHistFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"ssp histogram file name:\n"];
	[message appendFormat: @"%@\n", _simHistFileName];
	NSLog(@"%@", message);
	[message release];
}
//deallocator
-(void) deallocate
{
	[_creationTime release];
	_creationTime = nil;
	[_simParameterFileName release];
	_simParameterFileName = nil;
	[_simResultFileName release];
	_simResultFileName = nil;
	[_simStatisticsFileName release];
	_simStatisticsFileName = nil;
	[_simHistFileName release];
	_simHistFileName = nil;
	[super dealloc];
}
@end;
