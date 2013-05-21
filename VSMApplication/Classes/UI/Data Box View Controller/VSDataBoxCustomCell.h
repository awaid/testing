//
//  VSDataBoxCustomCell.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
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


@end


@interface VSDataBoxCustomCell : UIView <VSDataPickerCustomCellDelegate,VSTimePickerCustomCellDelegate,UIPopoverControllerDelegate>
{
    UIButton *dataButton_;
    UIButton *dateButton_;
    id<VSDataBoxViewDelegate> delegateForBoxController_;
    UILabel *dataLabel_;
    UILabel *hoursLabel_;
    UILabel *minutesLabel_;
    UILabel *secondsLabel_;
}
@property (retain, nonatomic) IBOutlet UIButton *dataButton;
@property (retain, nonatomic) IBOutlet UIButton *dateButton;
@property (retain, nonatomic) id<VSDataBoxViewDelegate> delegateForBoxController;
@property (retain, nonatomic) IBOutlet UILabel *dataLabel;
@property (retain, nonatomic) IBOutlet UILabel *hoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *minutesLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondsLabel;


@end
