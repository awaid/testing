//
//  VSImprovementsViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/13/13.
//
//

#import <UIKit/UIKit.h>

@interface VSImprovementsViewController : UIViewController <UIAlertViewDelegate>
{
    UITableView *improvmentsTableView_;
}
@property (retain, nonatomic) IBOutlet UITableView *improvmentsTableView;

@end
