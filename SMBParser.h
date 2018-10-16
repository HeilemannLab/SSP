/* ######################################################################
* File Name: SMBParser
* Project: ssp
* Version: 18.10
* Creation Date: 11.10.2018
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

#ifndef SMBParser_h
#define SMBParser_h

#import <Foundation/Foundation.h>

@interface SMBParser: NSObject
{
	unsigned _argc;
	NSMutableArray* _argv;
	bool _help;
}

//initializer
-(id) init;

//mutators
-(unsigned) argc;
-(NSMutableArray*) argv;
-(bool) help;

//special functions
-(void) importCommandLineArguments:(int) size :(const char**) data;
-(bool) askedForHelp:(const char**) data;
-(bool) checkParserLength: (unsigned) data;

//print functions
-(void) printInfo;
-(void) printHelp;
-(void) printFalseParserArgument:(unsigned) data;
-(void) printShortParser:(unsigned) data;
//deallocator
-(void) dealloc;

@end
#endif


