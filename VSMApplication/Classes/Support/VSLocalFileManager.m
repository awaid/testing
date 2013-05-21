//
//  VSLocalFileManager.m
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import "VSLocalFileManager.h"
#import "NSObject+SBJSON.h"
#import "JSON.h"

static VSLocalFileManager *_localFileManager_;

@implementation VSLocalFileManager

+ (VSLocalFileManager *)sharedFileManager
{
    if(!_localFileManager_)
    {
        _localFileManager_ = [[VSLocalFileManager alloc] init] ;
    }
    
    return _localFileManager_;
}


-(BOOL) saveProjectStateLocallyWithJSON:(NSString *)projectState withFileName:(NSString*) fileName {
    
    @synchronized(self)
    {

        //Save json in file
        BOOL isWritten = [self saveJSONWithFileName:fileName andJson:projectState];
        
        if (isWritten) {
            
            //save md5 hash
            //NSString *hashForState = [FAUtilities MD5HashKey:gameState];
            //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",hashForState] forKey:kGameStateHashKey];
            //Save In Memory Revision Number
            //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",inMemoryRevsionNumber] forKey:kLocalUserDataRevisonNumber];
            //[[NSUserDefaults standardUserDefaults] synchronize];
        }
        return isWritten;
    }
}

-(void)flushLocalFileStateWithFileName:(NSString*) fileName
{
    //remove locall game state
    [self removeFileWithName:fileName];
}

-(BOOL)checkIfLocalAppStateStateExistsWithFileName:(NSString*) fileName {

    
    NSString *fullFilePath = [self getFullPathWithFileName:fileName];
    //Remove the file
    if ([self checkIfFileExistsAtPath:fullFilePath shouldBeRemoved:NO]) {
        //Create the file
        return YES;
    }
    return NO;
}


#pragma mark - private methods
-(NSString*)getFullPathWithFileName:(NSString*)fileName
{
    // get Path where files are stored
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get document directory
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    //get full path
    NSString *fullFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return fullFilePath;
}


-(BOOL)saveJSONWithFileName:(NSString*)fileName andJson:(NSString*)json
{
    NSString *fullFilePath = [self getFullPathWithFileName:fileName];
    //Remove the file
    BOOL isWritten = NO;
    
    isWritten = [json writeToFile:fullFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return isWritten;
}

-(BOOL)checkIfFileExistsAtPath:(NSString*)path shouldBeRemoved:(BOOL)shouldRemove {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success =[fileManager fileExistsAtPath:path];
    if (success) {
        if (shouldRemove ==YES) {
            [fileManager removeItemAtPath:path error:nil];
            return YES;
        }
    }
    return success;
	
}

-(void)removeFileWithName:(NSString*)fileName
{
    NSString *fullFilePath = [self getFullPathWithFileName:fileName];
    //remove file
    [self checkIfFileExistsAtPath:fullFilePath shouldBeRemoved:YES];
}

-(NSString*) getFileStringDataFromResourcesFolderWithFileName:(NSString*) fileName
{
    NSString* path;
    NSError *error;
    path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData*  data= [NSData dataWithContentsOfFile:path];
    
    NSDictionary *loadAppDictionary  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return [loadAppDictionary JSONRepresentation];;

}

-(NSDictionary*) getLocalMetaDataWithFileName:(NSString*) fileName
{
    NSDictionary *dict = [self getDictionaryFromString:[self getFileStringDataFromResourcesFolderWithFileName:fileName]];;
   return dict;
}

-(NSDictionary*)getLocalFileAppStateDictionaryWithFileName:(NSString*) fileName
{
    NSString *appStateString;
    
    if(![self checkIfLocalAppStateStateExistsWithFileName:fileName])
    {
        appStateString = [self getFileStringDataFromResourcesFolderWithFileName:fileName];
        [self saveJSONWithFileName:fileName andJson:appStateString];
        
    }
    
    else
    {
        appStateString = [self getAppStateInStringFormWithFileName:fileName];
    }
    
    
    
    NSDictionary* localProjectFileDictionary = nil;
    if (appStateString) {
        
        localProjectFileDictionary = [self getDictionaryFromString:appStateString];
        if (localProjectFileDictionary)
        {
//            //Validate hash
//            //BOOL bValidState = [self validateLocalGameDictionaryWithHashKey:gameDataString withHashKey:kGameStateHashKey];
//            if (!bValidState)
//            {
//                //if hash is invalid remove local game state
//                [self flushLocalState];
//                return nil;
//            }
        }
    }
    
    
    return localProjectFileDictionary;
}

-(BOOL)validateLocalProjectDictionaryWithHashKey:(NSString*)localProjectDataString withHashKey:(NSString*)strHashKeyName
{
//    //get hash for selected state
//    NSString *hashForState         = [FAUtilities MD5HashKey:localGameDataString];
//    //get save state
//    NSString *savedHashState       = [[NSUserDefaults standardUserDefaults] objectForKey:strHashKeyName];
//    //return comparison of hash
//    return [hashForState isEqualToString:savedHashState];
    
    return NO;
    
}

-(NSString*)getAppStateInStringFormWithFileName:(NSString*)fileName
{
    //get data against file name
    NSString *localFileState = [VSUtilities getContentsOfFile:fileName];
    return localFileState;
}

-(NSDictionary*) getDictionaryFromString:(NSString*) projectState {
    
    NSData *data = [projectState dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* loadProjectStateDictionary = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:kNilOptions
                                        error:&error];
    return loadProjectStateDictionary;
}


@end
