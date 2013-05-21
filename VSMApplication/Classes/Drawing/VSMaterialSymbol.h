//
//  VSMaterial.h
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"

@interface VSMaterialSymbol : VSSymbols <UITextViewDelegate>
{
    UITextView *textField_;
    BOOL isInventorySymbol_;
    float oldScale_;

}
@property (nonatomic,retain) UITextView *textField;
@property (nonatomic,readwrite) BOOL isInventorySymbol;
@property (nonatomic,readwrite) float oldScale;

-(void)addTextFieldToInventorySymbol;
-(void)removeTheReferenceOfMaterialSymbolFromArrowSymbol;

@end
