//
//  VSMetaData.h
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import <Foundation/Foundation.h>

@interface VSMetaData : NSObject
{
    
}

-(void) loadAppMetaData;

-(NSDictionary*) getMetaDataDictionary;

-(NSDictionary*) getSymbolsDictionary;

-(NSString*) getTypeBasedOnID:(double) ID;

-(NSDictionary*) getDictionaryBasedOnID:(double) ID;

-(NSArray*) getSymbolsKeys;

-(NSNumber*) getIDBasedOnImageName:(NSString*) name;

-(NSDictionary*) getNonAutomaticTemplate;

-(NSDictionary*) getAutomaticTemplate;


@end
