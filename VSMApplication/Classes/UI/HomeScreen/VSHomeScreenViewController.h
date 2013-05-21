//
//  VSMAPPHomeScreenViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import "VSProjectTeamDescriptionCustomCell.h"
@interface VSHomeScreenViewController : UIViewController <VSProjectTeamDescriptionCustomCell>
{
    UITextView *valueStreamDescriptionTextView_;
    UITableView *projectTableView_;
    UITextField *projectTextField_;
}
@property (retain, nonatomic) IBOutlet UITextView *valueStreamDescriptionTextView;
@property (retain, nonatomic) IBOutlet UITableView *projectTableView;
@property (retain, nonatomic) IBOutlet UITextField *projectTextField;

@end
