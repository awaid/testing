//
//  VSLocalFileManager.h
//  VSMAPP
//
//  Created by Apple  on 10/04/2013.
//
//

#import <Foundation/Foundation.h>

@interface VSLocalFileManager : NSObject

-(NSDictionary*)getLocalFileAppStateDictionaryWithFileName:(NSString*) fileName;

-(BOOL) saveProjectStateLocallyWithJSON:(NSString *)projectState withFileName:(NSString*) fileName;

+ (VSLocalFileManager *)sharedFileManager;

-(NSDictionary*)getLocalFileAppStateDictionaryWithFileName:(NSString*) fileName;

-(NSDictionary*) getLocalMetaDataWithFileName:(NSString*) fileName;

@end
