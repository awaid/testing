//
//  VSExtendedSymbol.h
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"

@interface VSExtendedSymbol : VSSymbols
{
    
    UITextField *textField1_;
    UITextField *textField2_;
}
-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID;

@property (nonatomic,retain) UITextField *textField1;
@property (nonatomic,retain) UITextField *textField2;
@end
