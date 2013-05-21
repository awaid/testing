//
//  VSExistingProjectViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/25/13.
//
//

#import <UIKit/UIKit.h>
@protocol VSSidePanelDelegate
-(void)closeExistingProjectsButton;
-(void)closeExistingProjectsAndOpenNewProject;
@end

@interface VSExistingProjectViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    id<VSSidePanelDelegate> delegate_;
    UITableView *tableView_;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<VSSidePanelDelegate> delegate;
@end
