//
//  VSMapPopulation.h
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import <Foundation/Foundation.h>
@class VSSymbols;

@interface VSMapPopulation : NSObject
{
    
}


-(void) openProjectWithName:(NSString*)name;
-(void)openDictionaryWithJSON:(NSDictionary*)dictionary;
- (VSSymbols*)getSymbolViewWithTag:(NSString*) tag;
-(NSString*) getColorForCustomerArrow:(BOOL) isCustomer andForTag:(NSString*)tag;

@end
