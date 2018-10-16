/* ######################################################################
* File Name: main.m
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
#######################################################################*/

#import <Foundation/Foundation.h>
#import "SMBParser.h"
#import "SMBFlock.h"
#import "SMBActions.h"
#import "SMBMolecule.h"


int main(int argc, const char * argv[]) {
    // set up manual reference counting (MRC) environment
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	//manage parser arguments
	SMBParser *parser = [[[SMBParser alloc] init] autorelease];
	[parser importCommandLineArguments:argc :argv];
 	if(([parser help]) || (![parser checkParserLength: 4])){
		[pool drain];
		return 0;
	}
	// Initialize Flock
	
	SMBFlock *flock = [[[SMBFlock alloc] init] autorelease];
	[flock importParser: [parser argv]];
	if(![flock checkFlockValidity]){
		[pool drain];
		return 0;
	}
	// run simulation
	[flock printFlockParameter];
	[flock initActions];
	[flock initMolecules];
	[flock runSimulation];
	// write simulation results
	[flock logSimulation];
    [pool drain];
    return 0;
}
