//
//  VSDataPickerPopUpViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import <UIKit/UIKit.h>

@protocol VSDataPickerCustomCellDelegate
-(void)removeFromSuperView:(id)sender;
@end
@interface VSDataPickerPopUpViewController : UIViewController
{
    UIPickerView *dataPicker_;
    id<VSDataPickerCustomCellDelegate> delegate_;
    NSMutableArray *stringArray_;

}
@property (retain, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (nonatomic,retain) NSMutableArray *stringArray;
@property (retain, nonatomic) id<VSDataPickerCustomCellDelegate> delegate;

@end
