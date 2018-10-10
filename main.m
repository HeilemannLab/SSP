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
#import "SMBMolecule.h"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSUInteger sites = 5;
        double q = 0.5;
        double p = 0.9;
        SMBMolecule *molecule = [[SMBMolecule alloc]initWithNumberOfBindingSites: sites];
        [molecule setQ: &q];
        [molecule setP: &p];
        [molecule simPositiveBindingEvents];
        [molecule simMoleculeBlinking];
      	[molecule sumBlinkingEvents];
        [molecule printMolecule];
        //indexOfObject:inSortedRange:options:usingComparator
    [pool drain];
    return 0;
}
