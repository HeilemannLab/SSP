/* ######################################################################
* File Name: main.m
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
#####################################################################*/

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
