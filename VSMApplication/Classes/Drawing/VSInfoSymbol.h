//
//  VSInfoSymbol.h
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"
@class VSProcessSymbol;
@interface VSInfoSymbol : VSSymbols <UITextFieldDelegate>
{
    NSMutableArray *arrayOfAttachedProcessBoxes_;
    VSProcessSymbol *referenceOfSupplierSymbol_;
    VSProcessSymbol *referenceOfCustomerSymbol_;

    UITextField *textField1_;
    UITextField *textField2_;
}
-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID;

@property (nonatomic,retain) UITextField *textField1;
@property (nonatomic,retain) UITextField *textField2;

@property (nonatomic,retain) NSMutableArray *arrayOfAttachedProcessBoxes;
@property (nonatomic,retain) VSProcessSymbol *referenceOfSupplierSymbol;
@property (nonatomic,retain) VSProcessSymbol *referenceOfCustomerSymbol;
@end
