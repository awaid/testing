//
//  VSUIManager.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/29/13.
//
//

#import <Foundation/Foundation.h>
@class VSDataBoxViewController;
@interface VSUIManager : NSObject
+(VSUIManager*) sharedUIManager;


-(void)showSymbolTextInputViewWithText:(NSString*)string;
-(void)showSymbolNumberInputViewWithText:(NSString*)string;
-(void)removeSymbolTextInputView;
-(void)showColorPickerViewFromView:(UIView*)view;
-(void)closeColorPickerPopOverWithIndex:(int)index;
-(void)moveDetailViewUpOnEnteringTextInView:(UIView*)textView withSymbolView:(UIView*)symbolView;
-(void)moveDetailViewDownEnteringTextInView:(UIView*)symbolView;
-(void)showColorPickerFromDataBox:(VSDataBoxViewController*)dataBoxViewController;
@end
