//
//  VSExtendedSymbol.m
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import "VSExtendedSymbol.h"
#import "VSDataManager.h"

@implementation VSExtendedSymbol

-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID
{
    if (self = [super init]) {
        self.ID = metaID;
        [self settingInitialParameters:name andWithTag:tag];
        
        self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
    }
    
    return self;
}

-(void)longPress:(id)sender
{
    
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kExtendedKey];
    [self removeFromSuperview];
    
}

-(NSMutableDictionary*) getAppStateDictionary
{
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    symbolDictionary = [super getAppStateDictionary:symbolDictionary];
    
    return [symbolDictionary autorelease];
    
    
}

-(void) saveSymbolState
{
    NSMutableDictionary *state = [self getAppStateDictionary];
    if(self.textField1.text != nil)
    {
        [state setObject:self.textField1.text forKey:kTextField1];
    }
    
    if(self.textField2.text != nil)
    {
        [state setObject:self.textField2.text forKey:kTextField2];
    }
    
    [DataManager setSymbolDictionary:state andType:kExtendedKey andTag:self.tagSymbol];
}

@end
