/* ######################################################################
* File Name: SMBParser
* Project: ssp
* Version: 18.10
* Creation Date: 11.10.2018
* Created By: Sebastian Malkusch
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
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


