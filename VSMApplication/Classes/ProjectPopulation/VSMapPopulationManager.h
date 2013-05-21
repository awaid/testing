//
//  VSMapPopulationManager.h
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import <Foundation/Foundation.h>
@class VSSymbols;
@interface VSMapPopulationManager : NSObject <UITextFieldDelegate,UIAlertViewDelegate>
{
    
}

+ (VSMapPopulationManager *)sharedPopulationManager;

-(void) openProjectWithName:(NSString*)name;
-(void)openProjectWithDictionary:(NSDictionary*)dictionary;

-(VSSymbols*)getSymbolViewForTag:(NSString*)tag;
-(NSString*) getColorForCustomerArrow:(BOOL) isCustomer andForTag:(NSString*)tag;
@end
