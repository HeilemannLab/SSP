//
//  main.m
//  ssp
//
//  Created by Sebastian Malkusch on 07.10.18.
//  Copyright © 2018 Single Molecule Biophysics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBMolecule.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        unsigned sites = 5;
        double q = 0.5;
        double p = 0.9;
        SMBMolecule *molecule = [[SMBMolecule alloc]init: sites];
        [molecule setQ: &q];
        [molecule setP: &p];
        [molecule simPositiveBindingEvents];
        [molecule simMoleculeBlinking];
        [molecule sumBlinkingEvents];
        [molecule printMolecule];
        //indexOfObject:inSortedRange:options:usingComparator
    }
    return 0;
}
