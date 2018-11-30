/* ######################################################################
* File Name:
* Project: 
* Version:
* Creation Date:
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
#######################################################################*/

#ifndef SMBFileNames_h
#define SMBFileNames_h

#import <Foundation/Foundation.h>

@interface SMBFileNames : NSObject
{
	NSDate* _creationTime;
	NSMutableString* _simParameterFileName;
	NSMutableString* _simResultFileName;
	NSMutableString* _simStatisticsFileName;
	NSMutableString* _simHistFileName;
}

//initializer
-(id) init;

//mutators
-(NSMutableString*) simParameterFileName;
-(NSMutableString*) simResultFileName;
-(NSMutableString*) simStatisticsFileName;
-(NSMutableString*) simHistFileName;

//creation Fuctions
-(void) createFileNames;
-(void) createSimParameterFileName;
-(void) createSimResultFileName;
-(void) createSimStatisticsFileName;
-(void) createSimHistFileName;

//print Functions
-(void) printFileNames;
-(void) printSimParameterFileName;
-(void) printSimResultFileName;
-(void) printSimStatisticsFileName;
-(void) printSimHistFileName;
//deallocator
-(void) deallocate;
@end;
#endif
