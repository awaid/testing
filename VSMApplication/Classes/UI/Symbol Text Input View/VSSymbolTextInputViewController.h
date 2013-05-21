//
//  VSSymbolTextInputViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/29/13.
//
//

#import <UIKit/UIKit.h>

@interface VSSymbolTextInputViewController : UIViewController <UITextFieldDelegate>
{
    UILabel *headingTextLabel_;
    NSString *headingText_;
    UITextField *inputTextField_;
    NSString *inputText_;
    BOOL isNumPad_;
}
@property (retain, nonatomic) IBOutlet UILabel *headingTextLabel;
@property (retain, nonatomic) NSString *headingText;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) NSString *inputText;
@property (readwrite, nonatomic) BOOL isNumPad;

@end
