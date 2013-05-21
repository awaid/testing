//
//  VSTimePickerPopUpViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/5/13.
//
//

#import <UIKit/UIKit.h>
@protocol VSTimePickerCustomCellDelegate
-(void)removeFromSuperView:(id)sender;
@end

@interface VSTimePickerPopUpViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerView_;
    NSMutableArray *hoursArray_;
    NSMutableArray *minsArray_;
    NSMutableArray *secsArray_;
    id<VSTimePickerCustomCellDelegate> delegate_;

}
@property(retain, nonatomic) IBOutlet UIPickerView *pickerView;
@property(retain, nonatomic) NSMutableArray *hoursArray;
@property(retain, nonatomic) NSMutableArray *minsArray;
@property(retain, nonatomic) NSMutableArray *secsArray;
@property(retain, nonatomic) id<VSTimePickerCustomCellDelegate> delegate;


@end
