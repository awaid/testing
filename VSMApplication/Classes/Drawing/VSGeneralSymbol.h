//
//  VSGeneralSymbol.h
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"
#import "VSTimePickerPopUpViewController.h"

@interface VSGeneralSymbol : VSSymbols <UITextFieldDelegate,VSTimePickerCustomCellDelegate, UIPopoverControllerDelegate, UITextViewDelegate>
{
    
    UITextField *textField1_;
    UITextField *textField2_;
    UIButton*buttonForTimeLinePopUp_;
    BOOL isNonValueAddedTimeLine_;

    
}
-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID;

@property (nonatomic,retain) UITextField *textField1;
@property (nonatomic,retain) UITextField *textField2;
@property (nonatomic,retain) UIButton *buttonForTimeLinePopUp;
@property (nonatomic,readwrite) BOOL isNonValueAddedTimeLine;


@end
