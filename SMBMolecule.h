//
//  smbMolecule.h
//  ssp
//
//  Created by Sebastian Malkusch on 07.10.18.
//  Copyright © 2018 Single Molecule Biophysics. All rights reserved.
//

#ifndef SMBMolecule_h
#define SMBMolecule_h
#import <Foundation/Foundation.h>

@interface SMBMolecule : NSObject

@property (nonatomic) NSUInteger numberOfBindingSites;
@property (nonatomic) double* p;
@property (nonatomic) double* q;
@property (nonatomic) NSMutableArray *bindingEventList;
@property (nonatomic) NSMutableArray *blinkingEventList;
@property (nonatomic) NSUInteger blinkingEvents;

//initializer
-(instancetype) init: (NSUInteger) sites;

// simulation methods
- (void) simPositiveBindingEvents;

- (void) simMoleculeBlinking;
- (NSUInteger) simBindingSiteBlinking: (unsigned) site;
- (bool) checkBlinkingEvent;
- (void) sumBlinkingEvents;

//print functions
- (void) printBindingEventList;
- (void) printBlinkingEventList;
- (void) printBlinkingEvents;
- (void) printMolecule;

@end

#endif /* SMBMolecule_h */
