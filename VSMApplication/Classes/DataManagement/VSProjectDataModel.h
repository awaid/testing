//
//  VSProjectDataModel.h
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import <Foundation/Foundation.h>
@class VSProcessSymbol;

@interface VSProjectDataModel : NSObject
{
    NSString *currentProjectName_;

}

@property(nonatomic, retain) NSString *currentProjectName;

-(void) loadAppState;

-(NSMutableArray*) getProjectNamesArray;

-(void) createProjectWithName:(NSString*) name andAutomation:(BOOL) isAuto andTemplate:(BOOL) isTemplate;

-(void) setSymbolDictionary:(NSMutableDictionary*)symbolDictionary andType:(NSString*) type andTag:(NSString*) tag;

-(void) setCurrentProjectName:(NSString*)currentProject;

-(NSString*) getSymbolTagForNewObjectForType:(NSString*)type;

-(NSDictionary*) getProjectDictionaryForName:(NSString*) name;

-(void) removeSymbolWithTag:(NSString*) tag andType:(NSString*) type;
-(NSString*) getCurrentProjectDictionary;
-(BOOL)removeProjectWithName:(NSString*)projectName;

-(BOOL) isProjectNameExists:(NSString*) projectName;

-(VSProcessSymbol*) getFirstProcessBox;

-(VSProcessSymbol*) getLastProcessBox;

-(void) setVSMDictionary:(NSDictionary*) dict  withName:(NSString*)name;

@end
