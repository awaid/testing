//
//  VSMetaData.m
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import "VSMetaData.h"
#import "VSLocalFileManager.h"

@interface VSMetaData()
{
    NSDictionary *dictionaryMetaData_;
}
@property(nonatomic, retain) NSDictionary *dictionaryMetaData;

@end

@implementation VSMetaData
@synthesize dictionaryMetaData = dictionaryMetaData_;

-(id)init
{
    self = [super init];
    if(self)
    {
        dictionaryMetaData_ = [[NSDictionary alloc] init];
    }
    
    return self;
}

-(void) loadAppMetaData
{
    self.dictionaryMetaData = [[VSLocalFileManager sharedFileManager] getLocalMetaDataWithFileName:kLocalMetaDataFileName];
}

-(NSDictionary*) getNonAutomaticTemplate
{
    return [[VSLocalFileManager sharedFileManager] getLocalMetaDataWithFileName:kLocalNonAutoTemplate];
}

-(NSDictionary*) getAutomaticTemplate
{
    return [[VSLocalFileManager sharedFileManager] getLocalMetaDataWithFileName:kLocalAutoTemplate];
}

-(NSDictionary*) getMetaDataDictionary
{
    return [self.dictionaryMetaData objectForKey:@"Symbols"];
}

-(NSArray*) getSymbolsKeys
{
    return [[self.dictionaryMetaData objectForKey:@"Symbols"] allKeys];;
}
-(NSDictionary*) getSymbolsDictionary
{
    NSDictionary* symbolDictionary = [self.dictionaryMetaData objectForKey:@"Symbols"];
    
    NSArray *array;
    
    NSMutableDictionary *symbolsNewDictionary  = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSMutableArray *symbolsArray;
    
    NSMutableArray *subSymbolsArray;
    
    NSString *keyName;
    
   
    for(keyName in symbolDictionary)
    {
        
        symbolsArray = [[NSMutableArray alloc] init];
        
        array = [symbolDictionary objectForKey:keyName];

        for(int i=0;i < [array count]; i=i+2)
        {
            subSymbolsArray = [[NSMutableArray alloc] init];
            [subSymbolsArray addObject:[array objectAtIndex:i]];
           
            @try {
                 
                 [subSymbolsArray addObject:[array objectAtIndex:i+1]];
            }
            @catch (NSException *exception) {
                
            }
   
            [symbolsArray addObject:subSymbolsArray];
            
            [subSymbolsArray release];
        
        }
        
        [symbolsNewDictionary setObject:symbolsArray forKey:keyName];
        [symbolsArray release];
        
    
    
        
    }
    
    return symbolsNewDictionary;
}

-(NSString*) getTypeBasedOnID:(double) ID
{
    NSLog(@"ID: %f",ID);
    
    NSDictionary* symbolDictionary = [self.dictionaryMetaData objectForKey:@"Symbols"];
    
    NSArray *array;
    
    NSDictionary *subSymbolDictionary;
    
    NSString *keyName;
    
    for(keyName in symbolDictionary)
    {
        array = [symbolDictionary objectForKey:keyName];
        
        for(subSymbolDictionary in array)
        {
            if([[subSymbolDictionary objectForKey:@"id"] doubleValue] == ID )
            {
                return keyName;
            }
        }
    }
    
    return nil;
}

-(NSDictionary*) getDictionaryBasedOnID:(double) ID
{
    NSDictionary* symbolDictionary = [self.dictionaryMetaData objectForKey:@"Symbols"];
    
    NSArray *array;
    
    NSDictionary *subSymbolDictionary;
    
    NSString *keyName;
    
    for(keyName in symbolDictionary)
    {
        array = [symbolDictionary objectForKey:keyName];
        
        for(subSymbolDictionary in array)
        {
            if([[subSymbolDictionary objectForKey:@"id"] doubleValue] == ID )
            {
                return subSymbolDictionary;
            }
        }
    }
    
    return nil;
}

-(NSNumber*) getIDBasedOnImageName:(NSString*) name
{
    NSDictionary* symbolDictionary = [self.dictionaryMetaData objectForKey:@"Symbols"];
    
    NSArray *array;
    
    NSDictionary *subSymbolDictionary;
    
    NSString *keyName;
    
    for(keyName in symbolDictionary)
    {
        array = [symbolDictionary objectForKey:keyName];
        
        for(subSymbolDictionary in array)
        {
            if([[subSymbolDictionary objectForKey:@"path"] isEqualToString:name])
            {
                return [subSymbolDictionary objectForKey:@"id"];
            }
        }
    }
    
    return nil;
}



- (void)dealloc
{
    self.dictionaryMetaData = nil;
    [super dealloc];
}




@end
