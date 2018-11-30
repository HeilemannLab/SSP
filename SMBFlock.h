/* ######################################################################
* File Name: SMBFlock.h
* Project: SSP
* Version: 18.10
* Creation Date: 10.10.2018
* Created By: Sebastian Malkusch
* Contact: <malkusch@chemie.uni-frankfurt.de>
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
#####################################################################*/

#ifndef SMBFlock_h
#define SMBFlock_h

#import <Foundation/Foundation.h>
#import"SMBActions.h"
#import"SMBHistogram.h"
#import"SMBFileNames.h"

@interface SMBFlock : NSObject
{
	unsigned _numberOfMolecules;
	double _p;
	double _d;
	NSMutableArray* _moleculePDF;
	NSMutableArray* _moleculeCDF;
	NSMutableArray* _molecules;
	SMBActions* _actions;
	SMBHistogram* _histogram;
	SMBFileNames* _fileNames;
}

//initializers
-(id) init;

//mutators
-(void) setNumberOfMolecules:(unsigned) data;
-(void) setP:(double) data;
-(void) setD:(double) data;
-(void) setMoleculePDF:(NSMutableArray*) data;

//import functions
-(void) importParser:(NSMutableArray*) data;
-(void) calculateCDF;

//search functions
-(unsigned) binarySearchCDF:(double) data;

// simulation functions
-(unsigned) simMoleculeType;
-(void) initActions;
-(void) initMolecules;
-(void) runSimulation;
-(void) determineBlinkingStatistics;

//proof functions
-(bool) checkPDF;
-(bool) checkProbability:(double) data;
-(bool) checkFlockValidity;

//write functions
-(void) logSimulation;
-(void) writeSimulationParameterToFile:(NSMutableString*) data;
-(void) writeSimulationResultToFile:(NSMutableString*) data;
-(void) writeSimulationStatisticsToFile:(NSMutableString*) data;
-(void) writeSimulationHistogramToFile:(NSMutableString*) data;

//print functions
-(void) printFlockParameter;
-(void) printMolecules;
-(void) printProbabilityError:(double) data;
-(void) printPDFError;

//deallocator
-(void) dealloc;
@end
#endif
