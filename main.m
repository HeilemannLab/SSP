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
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	SMBParser *parser = [[[SMBParser alloc] init] autorelease];
	[parser importCommandLineArguments:argc :argv];
	// check for valid parser arguments or if help is needed
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
	// set up simulation environment
	[flock printFlockParameter];
	// run simulation
	// log simulation results
	/*
        NSUInteger sites = 5;
        double q = 0.5;
        double p = 0.9;
	SMBActions *actions = [[[SMBActions alloc] init] autorelease];
	[actions runActions];
        SMBMolecule *molecule = [[[SMBMolecule alloc]initWithNumberOfBindingSites: sites] autorelease];
        [molecule setQ: &q];
        [molecule setP: &p];
        [molecule simPositiveBindingEvents];
        [molecule simMoleculeBlinking];
      	[molecule sumBlinkingEvents];
        [molecule printMolecule];
	*/
        //indexOfObject:inSortedRange:options:usingComparator
    [pool drain];
    return 0;
}
