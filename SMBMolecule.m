//
//  smbMolecule.m
//  ssp
//
//  Created by Sebastian Malkusch on 07.10.18.
//  Copyright © 2018 Single Molecule Biophysics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBMolecule.h"

@implementation SMBMolecule
-(instancetype) init:(NSUInteger) sites
{
    self = [super init];
    if (self) {
        [self setNumberOfBindingSites: sites];
        [self setP: nil];
        [self setQ: nil];
        _bindingEventList = [NSMutableArray array];
        _blinkingEventList = [NSMutableArray array];
    }
    return self;
}

-(void) simPositiveBindingEvents
{
    double event = 0.0;
    NSUInteger binding = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        binding = 0;
        event = arc4random_uniform(1000)/(double)1000;
        NSLog(@"event %u is %.2f.", i,event);
        if (event <= *_q){
            binding = 1;
        }
        [_bindingEventList addObject:@(binding)];
    }
}

- (void) simMoleculeBlinking
{
    NSUInteger blinks = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        blinks = [self simBindingSiteBlinking: i];
        [_blinkingEventList addObject:@(blinks)];
    }
}

- (NSUInteger) simBindingSiteBlinking: (unsigned) site
{
    NSUInteger blinks = 0;
    if ([[_bindingEventList objectAtIndex:site] intValue]){
        blinks = 1;
        bool result = [self checkBlinkingEvent];
        while (result){
            result = [self checkBlinkingEvent];
            ++blinks;
        }
    }
    return blinks;
}

- (bool) checkBlinkingEvent
{
    bool result=true;
    double event = arc4random_uniform(1000)/(double)1000;
    if (event> *_p) result=false;
    return result;
}

- (void) sumBlinkingEvents
{
    _blinkingEvents = 0;
    for (unsigned i=0; i<_numberOfBindingSites; i++){
        _blinkingEvents += [[_blinkingEventList objectAtIndex: i] intValue];
    }
}

// print functions
- (void) printBindingEventList
{
    NSLog(@"\nThe occupancy of the molecule's binding sites is\n %@", _bindingEventList);
}

- (void) printBlinkingEventList
{
    NSLog(@"\nThe blinking events of the molecule are\n %@", _blinkingEventList);
}

- (void) printBlinkingEvents
{
    NSLog(@"The detected blinking events of the molecul are %lu", _blinkingEvents);
}

- (void) printMolecule
{
    [self printBindingEventList];
    [self printBlinkingEventList];
    [self printBlinkingEvents];
}
@end
