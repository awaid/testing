//
//  VSTimeLineHeadViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/15/13.
//
//

#import <UIKit/UIKit.h>
#import "VSTimePickerPopUpViewController.h"

@interface VSTimeLineHeadViewController : UIViewController <VSTimePickerCustomCellDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UIView *timeLineHeadView_;
    UIView *timeLineTailView_;
    UILabel *valueHeadLabel_;
    UILabel *nonValueHeadLabel_;
    BOOL isTail_;
    BOOL isNonValueAddedTail_;
    UILabel *valueAddedTimeLabel_;
    UILabel *nonValueAddedLabel_;
    
    UILabel *hoursValueAdded_;
    UILabel *minsValueAdded_;
    UILabel *secsValueAdded_;
    
    UILabel *hoursNonValueAdded_;
    UILabel *minsNonValueAdded_;
    UILabel *secsNonValueAdded_;
    
    UILabel *tailSecondsLabel_;
    UILabel *tailMinutesLabel_;
    UILabel *tailHoursLabel_;
    
    NSString *tagForSymbol_;
    CGPoint previousLocation_;
}
@property (retain, nonatomic) IBOutlet UILabel *tailSecondsLabel;
@property (retain, nonatomic) IBOutlet UILabel *tailMinutesLabel;
@property (retain, nonatomic) IBOutlet UILabel *tailHoursLabel;
@property (retain, nonatomic) IBOutlet UIView *nonValueAddedTail;
@property (retain, nonatomic) IBOutlet UILabel *valueHeadSecsLabel;
@property (retain, nonatomic) IBOutlet UILabel *valueHeadMinsLabel;
@property (retain, nonatomic) IBOutlet UILabel *nonValueHeadSecsLabel;
@property (retain, nonatomic) IBOutlet UILabel *nonValueHeadMinsLabel;
@property (retain, nonatomic) IBOutlet UIView *timeLineHeadView;
@property (retain, nonatomic) IBOutlet UIView *timeLineTailView;
@property (retain, nonatomic) IBOutlet UILabel *valueHeadHoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *nonValueHeadHoursLabel;
@property (readwrite, nonatomic) BOOL isTail;
@property (readwrite, nonatomic) BOOL isNonValueAddedTail;
@property (retain, nonatomic) IBOutlet UILabel *valueAddedTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *nonValueAddedLabel;
@property (retain, nonatomic) IBOutlet UILabel *hoursValueAdded;
@property (retain, nonatomic) IBOutlet UILabel *minsValueAdded;
@property (retain, nonatomic) IBOutlet UILabel *secsValueAdded;
@property (retain, nonatomic) IBOutlet UILabel *hoursNonValueAdded;
@property (retain, nonatomic) IBOutlet UILabel *minsNonValueAdded;
@property (retain, nonatomic) IBOutlet UILabel *secsNonValueAdded;
@property (retain, nonatomic) NSString *tagForSymbol;
@property (nonatomic, readwrite) CGPoint previousLocation;


@end
