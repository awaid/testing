//
//  VSDataRowViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/9/13.
//
//

#import <UIKit/UIKit.h>
#import "VSDataPickerPopUpViewController.h"
#import "VSTimePickerPopUpViewController.h"

@protocol VSDataBoxViewDelegate
-(CGPoint)getCurrentDataBoxCordinates;
-(UIView*)getTheDataBoxView;
-(void)disableTableViewUserInteraction;
-(void)enableTableViewUserInteraction;
- (void)saveDataBox;

@end

@interface VSDataRowViewController : UIView <VSDataPickerCustomCellDelegate,UIPopoverControllerDelegate,VSTimePickerCustomCellDelegate,UITextFieldDelegate>
{
    id<VSDataBoxViewDelegate> delegateForBoxController_;
    UILabel *dataLabel_;
    UILabel *hoursLabel_;
    UILabel *minsLabel_;
    UILabel *secsLabel_;
    UILabel *secHeadingLabel_;
    UILabel *hoursHeadingLabel_;
    UILabel *minsHeadingLabel_;
    UILabel *numberLabel_;
    UITextField *numberTextField_;
    UIButton *timeButton_;
    UIImageView *databoxBackgroundImageView_;

}
@property (retain, nonatomic) IBOutlet UIImageView *databoxBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIButton *timeButton;
@property (retain, nonatomic) IBOutlet UITextField *numberTextField;
@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UILabel *secHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *hoursHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *minsHeadingLabel;
@property (retain, nonatomic) id<VSDataBoxViewDelegate> delegateForBoxController;
@property (retain, nonatomic) IBOutlet UILabel *dataLabel;
@property (retain, nonatomic) IBOutlet UILabel *hoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *minsLabel;
@property (retain, nonatomic) IBOutlet UILabel *secsLabel;

-(NSDictionary*) getCustomDataBoxDictionary;

-(void) populateRowController;

- (id)initWithFrame:(CGRect)frame;

-(void)registerKeyboardChangeNotifications;

-(void)setHiddenValueForLabelWithBool:(BOOL)boolValue;

@end
