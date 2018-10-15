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
