//
//  VSDataManager.m
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import "VSDataManager.h"
#import "VSProjectDataModel.h"
#import "VSMetaData.h"
#import "VSProcessSymbol.h"
@interface VSDataManager()
{
    VSProjectDataModel *projectData_;
    VSMetaData *metaData_;
}

@property(nonatomic, retain) VSProjectDataModel *projectData;
@property(nonatomic, retain) VSMetaData *metaData;

@end


static VSDataManager *_dataManager_;

@implementation VSDataManager
@synthesize projectData = projectData_;
@synthesize metaData = metaData_;

+ (VSDataManager *)sharedDataManager
{
    if(!_dataManager_)
    {
        _dataManager_ = [[VSDataManager alloc] init] ;
    }
    
    return _dataManager_;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        projectData_ = [[VSProjectDataModel alloc] init];
        metaData_ = [[VSMetaData alloc] init];
    }
   
    return self;
}

#pragma mark App State

-(void) loadAppState
{
    [self.projectData loadAppState];
}

-(NSMutableArray*) getProjectNamesArray
{
    return [self.projectData getProjectNamesArray];
}

-(void) createProjectWithName:(NSString*) name andAutomation:(BOOL) isAuto andTemplate:(BOOL) isTemplate
{
    [self.projectData createProjectWithName:name andAutomation:isAuto andTemplate:isTemplate];
}

-(void) setCurrentProjectName:(NSString*)currentProject
{
    [self.projectData setCurrentProjectName:currentProject];
}

-(NSString*) getCurrentProjectName;
{
    return  self.projectData.currentProjectName;
}


-(void) setSymbolDictionary:(NSMutableDictionary*)symbolDictionary andType:(NSString*) type andTag:(NSString*) tag
{
    [self.projectData setSymbolDictionary:symbolDictionary andType:type andTag:tag];
}

-(BOOL)deleteProjectWithName:(NSString*)projectName
{
    return [self.projectData removeProjectWithName:projectName];
}


-(NSString*)getCurrentProjectDictionary
{
    return [self.projectData getCurrentProjectDictionary];
}

-(NSString*) getSymbolTagForNewObjectForType:(NSString*)type
{
    return [self.projectData getSymbolTagForNewObjectForType:type];
}


-(NSDictionary*) getProjectDictionaryForName:(NSString*) name
{
    return [self.projectData getProjectDictionaryForName:name];
}

-(BOOL) isProjectNameExists:(NSString*) projectName
{
    return [self.projectData isProjectNameExists:projectName];
}

-(VSProcessSymbol*) getFirstProcessBox
{
    return [self.projectData getFirstProcessBox];
}

-(VSProcessSymbol*) getLastProcessBox
{
    return [self.projectData getLastProcessBox];
}

-(void) setVSMDictionary:(NSDictionary*) dict  withName:(NSString*)name
{
    [self.projectData setVSMDictionary:dict withName:name];
}


#pragma mark Meta Data
-(NSDictionary*) getNonAutomaticTemplate
{
    return [self.metaData getNonAutomaticTemplate];
}

-(NSDictionary*) getAutomaticTemplate
{
    return [self.metaData getAutomaticTemplate];
}
-(void) loadMetaData
{
    [self.metaData loadAppMetaData];
}

-(NSDictionary*) getSymbolsDictionary
{
    return [self.metaData getSymbolsDictionary];
}

-(NSString*) getTypeBasedOnID:(double) ID
{
    return  [self.metaData getTypeBasedOnID:ID];
}

-(NSDictionary*) getDictionaryBasedOnID:(double) ID
{
    return [self.metaData getDictionaryBasedOnID:ID];
}

-(NSArray*) getSymbolsKeys
{
    return [self.metaData getSymbolsKeys];
}

-(void) removeSymbolWithTag:(NSString*) tag andType:(NSString*) type
{
    [self.projectData removeSymbolWithTag:tag andType:type];
}

-(NSNumber*) getIDBasedOnImageName:(NSString*) name
{
    return [self.metaData getIDBasedOnImageName:name];
}


- (void)dealloc
{
    self.projectData = nil;
    self.metaData = nil;
    [super dealloc];
}

@end
