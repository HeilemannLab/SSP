/* ######################################################################
* File Name: SMBParser
* Project: ssp
* Version: 18.10
* Creation Date: 11.10.2018
* Created By Sebastian Malkusch
* <malkusch@chemie.uni-frankfurt.de>
* Goethe University of Frankfurt
* Physical and Theoretical Chemistry
* Single Molecule Biophysics
###################################################################### */

#import <Foundation/Foundation.h>
#import "string.h"
#import "ctype.h"
#import "SMBParser.h"

@implementation SMBParser
//initializers
-(id) init
{
	self = [super init];
	[self printInfo];
	_argc = 0;
	_argv = [[NSMutableArray array] retain];
	_help = false;
	return self;
}

//mutators
-(unsigned) argc
{
	return _argc;
}

-(NSMutableArray*) argv;
{
	return _argv;
}

-(bool) help
{
	if (_help) [self printHelp];
	return _help;
}

//special functions
-(void) importCommandLineArguments:(int) size :(const char**) data
{
	_argc = size;
	[_argv removeAllObjects];
	const char* helpShort = "-h";
	const char* helpLong = "--help";
	for(unsigned i=1; i<_argc; i++){
		if ((strcmp(data[i], helpShort)==0) || (strcmp(data[i], helpLong)==0)){
				_help = true;
		}
		else if (isdigit(*data[i]) == 0){
			[self printFalseParserArgument: i];
		}
		else{
			[_argv addObject:[NSNumber numberWithDouble: atof(data[i])]];
		}
	}
}

-(bool) askedForHelp: (const char**) data
{
	bool result = false;
	const char* helpShort = "-h";
	const char* helpLong = "--help";
	for(unsigned i=0; i<_argc; i++)
	{
		if ((strcmp(data[i], helpShort)==0) || (strcmp(data[i], helpLong)==0)){
			result = true;
			[self printHelp];
		}
	}
	return result;
}

-(bool) checkParserLength:(unsigned) data
{
	bool result = true;
	if (data > [_argv count]){
		[self printShortParser: data];
		result = false;
	}
	return result;
}

//print functions
-(void) printInfo
{
	NSMutableString* info = [[NSMutableString alloc] init];
	[info appendString:@"SSP Info:"];
	[info appendString:@"\nStochastic Simulation of Photophysics"];
	[info appendString:@"\nSingle Molecule Biophysics"];
	[info appendString:@"\nCopyright © 2018 by Sebastian Malkusch"];
	[info appendString:@"\nmalkusch@chemie.uni-frankfurt.de"];
	[info appendString:@"\nhttps://github.com/SMLMS/SSP.git\n\n"];
	NSLog(info);
	[info release];
}

-(void) printHelp
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString:@"SSP Help Message:"];
	[message appendString:@"\nSSP needs at least 4 parameters"];
	[message appendString:@"\n#1\t(int)\t number of molecules to simulate"];
	[message appendString:@"\n#2\t(float)\t p value"];
	[message appendString:@"\n#3\t(float)\t q value"];
	[message appendString:@"\n#4-end\t(float)\t pdf of available molecule types"];
	[message appendString:@"\nparameters 4-end need to sum to 1.\n\n"];
	NSLog(message);
	[message release];
}

-(void) printFalseParserArgument:(unsigned) data
{
	NSLog(@"Warning: Input Argument %u is not a number!", data);
}

-(void) printShortParser:(unsigned) data
{
	NSLog(@"Error: Too few parser arguments passed. At least %i are needed!", data);
}

//deallocator
-(void) dealloc
{
	NSLog(@"Parser is deallocated.");
	[_argv release];
	_argv = nil;
	[super dealloc];
}

@end
