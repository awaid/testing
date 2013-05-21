//
//  VSDataManager.h
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import <Foundation/Foundation.h>
@class VSDataManager;
@class VSProcessSymbol;
@interface VSDataManager : NSObject
{
    
}

+ (VSDataManager *)sharedDataManager;

-(void) loadAppState;

-(void) loadMetaData;

-(NSDictionary*) getSymbolsDictionary;

-(NSString*) getTypeBasedOnID:(double) ID;

-(NSDictionary*) getDictionaryBasedOnID:(double) ID;

-(NSNumber*) getIDBasedOnImageName:(NSString*) name;

-(NSMutableArray*) getProjectNamesArray;

-(void) createProjectWithName:(NSString*) name andAutomation:(BOOL) isAuto andTemplate:(BOOL) isTemplate;

-(void) setCurrentProjectName:(NSString*)currentProject;
-(NSString*) getCurrentProjectName;


-(void) setSymbolDictionary:(NSMutableDictionary*)symbolDictionary andType:(NSString*) type andTag:(NSString*) tag;

-(NSArray*) getSymbolsKeys;

-(NSString*) getSymbolTagForNewObjectForType:(NSString*)type;

-(NSDictionary*) getProjectDictionaryForName:(NSString*) name;

-(void) removeSymbolWithTag:(NSString*) tag andType:(NSString*) type;

-(NSString*)getCurrentProjectDictionary;
-(BOOL)deleteProjectWithName:(NSString*)projectName;

-(BOOL) isProjectNameExists:(NSString*) projectName;

-(NSDictionary*) getNonAutomaticTemplate;

-(VSProcessSymbol*) getFirstProcessBox;

-(VSProcessSymbol*) getLastProcessBox;

-(void) setVSMDictionary:(NSDictionary*) dict  withName:(NSString*)name;

-(NSDictionary*) getAutomaticTemplate;

@end
