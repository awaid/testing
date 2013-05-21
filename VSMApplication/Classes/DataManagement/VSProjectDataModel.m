//
//  VSProjectDataModel.m
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import "VSProjectDataModel.h"
#import "VSLocalFileManager.h"
#import "NSObject+SBJSON.h"
#import "JSON.h"
#import "VSDataManager.h"
#import "VSPushArrowSymbol.h"
#import "VSDrawingManager.h"
#import "VSTimeLineHeadViewController.h"
#import "VSMapPopulationManager.h"
#import "VSMAPPAppDelegate.h"

@interface VSProjectDataModel()
{
    NSMutableDictionary *appStateDictionary_;
}

@property(nonatomic, retain) NSMutableDictionary *appStateDictionary;

@end


@implementation VSProjectDataModel
@synthesize appStateDictionary = appStateDictionary_;
@synthesize currentProjectName = currentProjectName_;




-(id)init
{
    self = [super init];
    if(self)
    {
        appStateDictionary_ = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) setCurrentProjectName:(NSString*)currentProject;
{
    currentProjectName_ = currentProject;
}

// convert all the sub dictionary of a parent dictionary in mutable dictionaries
-(NSMutableDictionary*) convertSubDictionariesOfJsonIntoMutableDictionaries:(NSMutableDictionary*) parentDictionaryFromJson
{
    NSMutableDictionary* parsedParentDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSMutableDictionary* parsedChildDictionary;
    
    NSString *keyName;
    
    for(keyName in parentDictionaryFromJson)
    {
        if([[parentDictionaryFromJson objectForKey:keyName] isKindOfClass:[NSString class]])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [parsedParentDictionary setObject:dict forKey:keyName];
            [dict release];
           // [parsedParentDictionary setObject:parsedChildArray forKey:keyName];
        }
        
        else
        {
            parsedChildDictionary = [NSMutableDictionary dictionaryWithDictionary:[parentDictionaryFromJson objectForKey:keyName]];
            [parsedParentDictionary setObject:parsedChildDictionary forKey:keyName];
        }
        
    }
    
    return parsedParentDictionary;
}

-(void) loadAppState
{
    NSDictionary *tempAppstateDictionary = [[VSLocalFileManager sharedFileManager] getLocalFileAppStateDictionaryWithFileName:kLocalAppStateFileName];
    
    self.appStateDictionary = [VSUtilities deepMutableCopyDictionary:tempAppstateDictionary];
    
}

-(NSMutableArray*) getProjectNamesArray
{
    NSMutableArray *projectsArray = [NSMutableArray arrayWithArray:[[self.appStateDictionary objectForKey:kAppStateKey] allKeys]];
    return projectsArray;
}

-(NSMutableDictionary*) getEmptySymbolDictionary
{
    NSArray *arraySymbolKeys = [DataManager getSymbolsKeys];
    NSString *key;
    
    NSMutableDictionary* symbolDictionary =[[NSMutableDictionary alloc] init];
    
    NSMutableDictionary* subSymbolDictionary;
    
    for(key in arraySymbolKeys)
    {
        subSymbolDictionary = [[NSMutableDictionary alloc] init];
        
        [symbolDictionary setObject:subSymbolDictionary forKey:key];
        [subSymbolDictionary release];
    }
    
    subSymbolDictionary = [[NSMutableDictionary alloc] init];
    [symbolDictionary setObject:subSymbolDictionary forKey:kCustomKey];
    [subSymbolDictionary release];
    

    return [symbolDictionary autorelease];
    
}

-(void) setVSMDictionary:(NSDictionary*) dict withName:(NSString*)name
{
    NSMutableDictionary* dictMutable = [VSUtilities deepMutableCopyDictionary:dict];
    [self setObject:dictMutable withKeys:[NSArray arrayWithObjects:kAppStateKey,name, nil]];
}

-(void) createProjectWithName:(NSString*) name andAutomation:(BOOL) isAuto andTemplate:(BOOL) isTemplate
{
//    if([self.currentProjectName isEqualToString:name])
//    {
//        [self popAlertViewForProjectNameWithMessage:@"This project is already open."];
//        return;
//    }
    
    self.currentProjectName = name;
    
    NSString *isAutoString;
    if(isAuto == YES)
    {
        isAutoString = @"YES";
    }
    
    else
    {
        isAutoString = @"NO";
    }
    

    
    if(isAuto == NO && isTemplate == YES)
    {
        NSMutableDictionary* dict = [VSUtilities deepMutableCopyDictionary:[[[DataManager getNonAutomaticTemplate] objectForKey:kAppStateKey] objectForKey:@"nonTemplate"]];
        [dict setObject:self.currentProjectName forKey:@"projectName"];
        [dict setObject:isAutoString forKey:kIsAutoProject];
        [[self.appStateDictionary objectForKey:kAppStateKey] setObject:dict forKey:name];
        
        
        [[VSMapPopulationManager sharedPopulationManager] openProjectWithName:self.currentProjectName];
                                     
    }
    
    else if(isAuto == YES && isTemplate == YES)
    {
        NSMutableDictionary* dict = [VSUtilities deepMutableCopyDictionary:[[[DataManager getAutomaticTemplate] objectForKey:kAppStateKey] objectForKey:@"autoTemplate"]];
        [dict setObject:isAutoString forKey:kIsAutoProject];
        [dict setObject:self.currentProjectName forKey:@"projectName"];
        [[self.appStateDictionary objectForKey:kAppStateKey] setObject:dict forKey:name];
        
        [[VSMapPopulationManager sharedPopulationManager] openProjectWithName:self.currentProjectName];
        
    }
    
    else
    {
        NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init];
        [parentDict setObject:isAutoString forKey:kIsAutoProject];
        [parentDict setObject:[NSNumber numberWithBool:isTemplate] forKey:kIsTemplate];
        [parentDict setObject:self.currentProjectName forKey:@"projectName"];
        [parentDict setObject:[NSNumber numberWithInt:0] forKey:kLastTag];
        [parentDict setObject:[self getEmptySymbolDictionary] forKey:kSymbols];
        [[self.appStateDictionary objectForKey:kAppStateKey] setObject:parentDict forKey:name];
        [parentDict release];
    }
    
    
    
    
    
    
    
    [self saveProjectLocally];
    

}

-(BOOL) isProjectNameExists:(NSString*) projectName
{
    NSArray *names = [[self.appStateDictionary objectForKey:kAppStateKey] allKeys];
    
    NSString *tempName;
    
    for (tempName in names) {
        
        if([tempName isEqualToString:projectName])
        {
            return YES;
        }
    }
    
    return NO;
}

-(void) setBoolsForProject
{
    NSString* string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsAutoProject];
    
    if(string!=nil)
    {
        [[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] setObject:string forKey:kIsAutoProject];
    }
    string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsSupplierAdded];
    
    if(string !=nil)
    {
        [[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] setObject:string forKey:kIsSupplierAdded];   
    }
        
    string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsCustomerAdded];
    
    if(string !=nil)
    {
        [[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] setObject:string forKey:kIsCustomerAdded];
    }
    
    string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsProductionControlAdded];
    
    if(string !=nil)
    {
        [[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] setObject:string forKey:kIsProductionControlAdded];
    }
    //Setting the NSUserDefaults that need to be set to NO
    string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsTimeLineHeadAdded];
    
    if(string !=nil)
    {
        [[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] setObject:string forKey:kIsTimeLineHeadAdded];
    }
}

-(void) saveProjectLocally
{
    [self setBoolsForProject];
    NSString *appStateString = [self.appStateDictionary JSONRepresentation];
    [[VSLocalFileManager sharedFileManager] saveProjectStateLocallyWithJSON:appStateString withFileName:kLocalAppStateFileName];
}

-(NSString*) getCurrentProjectDictionary
{
    NSDictionary *projectDictionary=[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName];
    return [projectDictionary JSONRepresentation];
}
-(NSString*) getCurrentProjectTagForType
{
    NSString *tag = [self getObjectFromDictionaryWithKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kLastTag,nil]];
    
    //[[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName]objectForKey:kLastTag];
    
    return tag;
}

-(void) setCurrentProjectTagForType:(NSString*) type andTag:(NSString*)tag
{
    [self setObject:tag withKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kLastTag, nil]];
}

-(NSString*) getSymbolTagForNewObjectForType:(NSString*)type
{
    NSString *tag = [self getCurrentProjectTagForType];
    
    NSLog(@"Tag value %@",tag);
    NSString* newStringTag = [NSString stringWithFormat:@"%d",[tag integerValue]+1];
    
    [self setCurrentProjectTagForType:type andTag:newStringTag];
    
    return newStringTag;
    
}

-(NSArray*) getProjectSymbolsKeyArrayForType:(NSString*)type
{
    NSDictionary *dict = [[[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] objectForKey:kSymbols] objectForKey:type];
    
    return [dict allKeys];
    
}

-(void) setSymbolDictionary:(NSMutableDictionary*)symbolDictionary andType:(NSString*) type andTag:(NSString*) tag
{
    if(symbolDictionary == nil ||[VSDrawingManager sharedDrawingManager].isParsing == YES)
    {
        return;
    }
    
    if([type isEqualToString:kProcessKey])
    {
        NSDictionary *metaData = [DataManager getDictionaryBasedOnID:[[symbolDictionary objectForKey:@"ID"] doubleValue]];
        
        // process boxes
        if([[metaData objectForKey:kType] integerValue] == 3 ||[[metaData objectForKey:kType] integerValue] == 1 || [[metaData objectForKey:kType] integerValue] == 2)
        {
            NSMutableArray *tempOutGoingArray = [self parseProcessSymbolDictionary:symbolDictionary forOutGoingArray:YES forTag:tag];
            NSMutableArray *tempInGoingArray = [self parseProcessSymbolDictionary:symbolDictionary forOutGoingArray:NO forTag:tag];
            [symbolDictionary setObject:tempInGoingArray forKey:kIncomingArrows];
            [symbolDictionary setObject:tempOutGoingArray forKey:kOutgoingArrows];
            [self saveTimeLine];
            
        }

    }
    
//    if([type isEqualToString:kMaterialKey])
//    {
//       if([[[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] objectForKey:kSymbols] objectForKey:kMaterialKey] == nil)
//       {
//           NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//           [[[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] objectForKey:kSymbols] setObject:dict forKey:kMaterialKey];
//           [dict release];
//       }
//    }
//  
    
    [self setObject:symbolDictionary withKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kSymbols,type,tag, nil]];
    
}

-(void) saveTimeLine
{
    NSArray *timeLineArray = [self getTimeLineArray];
    
    if([timeLineArray count] != 0)
    {
        [self setObject:timeLineArray withKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kSymbols,kTimeLine, nil]];
    }
}

-(NSArray*) getTimeLineArray
{
    NSArray* timeLineArray = [VSDrawingManager sharedDrawingManager].arrayOfTimeLine;
    
    
    NSMutableArray* timeLineArrayForSaving = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *timeLineDictionary;
    VSTimeLineHeadViewController *timeLine;
    
    int count = [timeLineArray count];
    
    for(int i = 0; i < count; i++)
    {
        timeLine = [timeLineArray objectAtIndex:i];

        
        if(i == 0 && count > 0) {
            timeLineDictionary = [[NSMutableDictionary alloc] init];
            [timeLineDictionary setObject:timeLine.nonValueHeadSecsLabel.text forKey:kNVeHeadSecs];
            [timeLineDictionary setObject:timeLine.nonValueHeadMinsLabel.text forKey:kNVHeadMin];
            [timeLineDictionary setObject:timeLine.nonValueHeadHoursLabel.text forKey:kNVHeadHours];
            [timeLineDictionary setObject:timeLine.valueHeadSecsLabel.text forKey:kVHeadSecs];
            [timeLineDictionary setObject:timeLine.valueHeadMinsLabel.text forKey:kVHeadMins];
            [timeLineDictionary setObject:timeLine.valueHeadHoursLabel.text forKey:kVHeadHours];
            [timeLineDictionary setObject:NSStringFromCGRect(timeLine.view.frame) forKey:kFrame];
            
            if(timeLine.tagForSymbol != nil)
            {
                [timeLineDictionary setObject:timeLine.tagForSymbol forKey:kSymbolTag];
            }
            
            [timeLineArrayForSaving addObject:timeLineDictionary];
            [timeLineDictionary release];
            continue;
        }

        if(i == 1 && count > 1){
            timeLineDictionary = [[NSMutableDictionary alloc] init];
            [timeLineDictionary setObject:timeLine.tailSecondsLabel.text forKey:kTailSecs];
            [timeLineDictionary setObject:timeLine.tailMinutesLabel.text forKey:kTailMins];
            [timeLineDictionary setObject:timeLine.tailHoursLabel.text forKey:kTailHours];
            [timeLineDictionary setObject:NSStringFromCGRect(timeLine.view.frame) forKey:kFrame];
            [timeLineArrayForSaving addObject:timeLineDictionary];
            if(timeLine.tagForSymbol != nil)
            {
                [timeLineDictionary setObject:timeLine.tagForSymbol forKey:kSymbolTag];
            }
            [timeLineDictionary release];
            continue;
        }
        
        if(i > 1 && count > 2)
        {
            timeLineDictionary = [[NSMutableDictionary alloc] init];
            [timeLineDictionary setObject:timeLine.minsNonValueAdded.text forKey:kNVMinAdded];
            [timeLineDictionary setObject:timeLine.secsNonValueAdded.text forKey:kNVSecsAdded];
            [timeLineDictionary setObject:timeLine.hoursNonValueAdded.text forKey:kNVHoursAdded];
            [timeLineDictionary setObject:timeLine.minsValueAdded.text forKey:kVMinAdded];
            [timeLineDictionary setObject:timeLine.secsValueAdded.text forKey:kVSecsAdded];
            [timeLineDictionary setObject:timeLine.hoursValueAdded.text forKey:kVHoursAdded];
            [timeLineDictionary setObject:NSStringFromCGRect(timeLine.view.frame) forKey:kFrame];
            if(timeLine.tagForSymbol != nil)
            {
                [timeLineDictionary setObject:timeLine.tagForSymbol forKey:kSymbolTag];
            }
            
            [timeLineArrayForSaving addObject:timeLineDictionary];
            [timeLineDictionary release];
        }
    }
    
    timeLineDictionary = [[NSMutableDictionary alloc] init];

    [timeLineDictionary setObject:[NSNumber numberWithBool:[VSDrawingManager sharedDrawingManager].isTailPresent] forKey:kTailPresentBool];
    [timeLineArrayForSaving addObject:timeLineDictionary];
    [timeLineDictionary release];

    return timeLineArrayForSaving;
    
    
}
-(NSMutableArray*) parseProcessSymbolDictionary:(NSMutableDictionary*) symbolDictionary forOutGoingArray:(BOOL) isOutGoing forTag:(NSString*)tagOwnership
{
    
    NSMutableArray *array;
    
    if(isOutGoing == YES)
    {
        array = [symbolDictionary objectForKey:kOutgoingArrows];
    }
    
    else
    {
        array = [symbolDictionary objectForKey:kIncomingArrows];
    }
    
    
    VSPushArrowSymbol *symbolPushArrow;
    NSMutableDictionary *dictionarySymbol;
    
    NSMutableArray *parsedArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (symbolPushArrow in array) {
        @try {
            dictionarySymbol = [symbolPushArrow getAppStateDictionary];
            [dictionarySymbol setObject:tagOwnership forKey:@"tagOwnership"];
            [parsedArray addObject:dictionarySymbol];
        }
        @catch (NSException *exception) {
        
        }
        @finally {
            
        }
        
    }
    
    return parsedArray;
        


}
-(NSDictionary*) getProjectDictionaryForName:(NSString*) name
{
   return [[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:name];
}

-(void) removeSymbolWithTag:(NSString*) tag andType:(NSString*) type
{
    [self removeObjectForKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kSymbols,type,tag, nil]];
}

-(BOOL)removeProjectWithName:(NSString*)projectName
{
    if([self.currentProjectName isEqualToString:projectName])
    {
        [self popAlertViewForProjectNameWithMessage:@"This project is currently open. You cannot delete it."];
        return NO;
    }
    
    [[self.appStateDictionary objectForKey:kAppStateKey] removeObjectForKey:projectName];
    [self saveProjectLocally];
    return YES;
}

-(VSProcessSymbol*) getFirstProcessBox
{
    NSString *symbolTag = [self getTagForFirstProcessBox];
    
    return (VSProcessSymbol*)[self getSymbolViewWithTag:symbolTag];
    
}

-(VSProcessSymbol*) getLastProcessBox
{
    NSString *symbolTag = [self getTagForLastProcessBox];
    
    return (VSProcessSymbol*)[self getSymbolViewWithTag:symbolTag];
    
}


-(NSString*) getTagForFirstProcessBox
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbols = [self getObjectFromDictionaryWithKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kSymbolTag,kProcessKey, nil]];
    
    NSArray *allKeys = [dictionarySymbols allKeys];
    NSDictionary *dictionarySymbol;
    
    NSDictionary *metaData;
    
    NSNumber *type;
    
    double ID;
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        type = [metaData objectForKey:kType];
        
        if([type isEqualToNumber:[NSNumber numberWithInt:3]])
        {
            return keyName;;
        }
        
    }
    
    return nil;
}

-(NSString*) getTagForLastProcessBox
{
    NSString *keyName;
    
   // NSDictionary *dictionarySymbols = [self getObjectFromDictionaryWithKeys:[NSArray arrayWithObjects:kAppStateKey,self.currentProjectName,kSymbolTag,kProcessKey, nil]];
    
    NSDictionary *dictionarySymbols=[[[[self.appStateDictionary objectForKey:kAppStateKey] objectForKey:self.currentProjectName] objectForKey:kSymbols] objectForKey:kProcessKey];
    
    NSArray *allKeys = [dictionarySymbols allKeys];
    NSDictionary *dictionarySymbol;
    
    NSDictionary *metaData;
    
    NSNumber *type;
    
    double ID;
    
    NSString *tagSymbol;
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        type = [metaData objectForKey:kType];
        
        if([type isEqualToNumber:[NSNumber numberWithInt:3]])
        {
            tagSymbol = keyName;
        }
        
    }
    
    return tagSymbol;
}

- (VSSymbols*)getSymbolViewWithTag:(NSString*) tag{
    
    // Get the subviews of the view
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSArray *subviews = [appDelegate.detailViewController.detailItem subviews];
    
    NSString *tagSymbolFromView;
    
    //NSDictionary *metaData;
    
    // Return if there are no subviews
    if ([subviews count] == 0) return nil;
    
    for (UIView *subview in subviews) {
        
        if([subview isKindOfClass:[VSSymbols class]])
        {
            tagSymbolFromView = ((VSSymbols*)subview).tagSymbol;
            
            if([tagSymbolFromView isEqualToString:tag])
            {
                return (VSSymbols*)subview;
            }
        }
        
    }
    
    return nil;
}


#pragma mark Generic App State

-(void) setObject:(id)object withKeys:(NSArray*)keys {
    int count = [keys count];
    NSString *key;
    NSMutableDictionary *dictionary = self.appStateDictionary;
    int i;
    for (i = 0; i < count-1; i++) {
        key = [keys objectAtIndex:i];
        dictionary = [dictionary objectForKey:key];
    }
    key = [keys objectAtIndex:i];
    
    [dictionary setObject:object forKey:key];
    
    
    
    [self saveProjectLocally];
}

-(id) getObjectFromDictionaryWithKeys:(NSArray*)keys {
    
    int count = [keys count];
    NSString *key;
    NSMutableDictionary *dictionary = self.appStateDictionary;
    int i;
    for (i = 0; i < count-1; i++) {
        key = [keys objectAtIndex:i];
        dictionary = [dictionary objectForKey:key];
    }
    key = [keys objectAtIndex:i];
    
    id object = [dictionary objectForKey:key];
    return object;
}

-(void)removeObjectForKeys:(NSArray*)keys {
    
    int count = [keys count];
    NSString *key;
    NSMutableDictionary *dictionary = self.appStateDictionary;
    int i;
    for (i = 0; i < count-1; i++) {
        key = [keys objectAtIndex:i];
        dictionary = [dictionary objectForKey:key];
    }
    key = [keys objectAtIndex:i];
    
    [dictionary removeObjectForKey:key];
    
    [self saveProjectLocally];
    
}

#pragma mark - Text View Delegate Methods

-(void)popAlertViewForProjectNameWithMessage:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    [alert show];
    [alert release];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //
    if(buttonIndex == 1)
    {
        
    }
    

}



- (void)dealloc
{
    self.appStateDictionary = nil;
    self.currentProjectName = nil;
    [super dealloc];
}

@end
