/* ######################################################################
* File Name: SMBActions.m
* Project: ssp
* Version: 18.10
* Creation Date: 10.10.2018
* Created By Sebastian Malkusch
* <malkusch@chemie.uni-frankfurt.de>
* Goethe University of Frankfurt
* Physical and Theoretical Chemistry
* Single Molecule Biophysics
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
###################################################################### */


#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <time.h>
#import "SMBActions.h"

@implementation SMBActions

-(id) init
{
	self = [super init];
	return self;
}

-(void) runActions
{
	srand (time(NULL));
}

-(void) dealloc
{
	[super dealloc];
}

@end
