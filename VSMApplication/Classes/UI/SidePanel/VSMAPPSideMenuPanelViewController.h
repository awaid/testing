//
//  RootViewController.h
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import <UIKit/UIKit.h>
#import "VSExistingProjectViewController.h"

@class DetailViewController;

@interface VSMAPPSideMenuPanelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,VSSidePanelDelegate,UIGestureRecognizerDelegate> {
    DetailViewController *detailViewController;
    UITableView *symbolsTableView_;
    UIView *projectNameNotificationView_;
    UITextField *projectNameTextField_;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

// symbols menu
@property (retain, nonatomic) IBOutlet UIView *symbolsMenu;
@property (retain, nonatomic) IBOutlet UIButton *symbolsButton;


@property (retain, nonatomic) IBOutlet UIButton *processSymbolButton;
@property (retain, nonatomic) IBOutlet UIButton *materialSymbolButton;
@property (retain, nonatomic) IBOutlet UIButton *informationSymbolButton;
@property (retain, nonatomic) IBOutlet UIButton *generalSymbolButton;
@property (retain, nonatomic) IBOutlet UIButton *extendedSymbolButton;
@property (retain, nonatomic) IBOutlet UIView *containerViewForSymbolTableview;
@property (retain, nonatomic) IBOutlet UITableView *symbolsTableView;
@property (retain, nonatomic) IBOutlet UIView *containerViewForSymbolTableView2;

@property (retain, nonatomic) IBOutlet UIView *projectNameNotificationView;
@property (retain, nonatomic) IBOutlet UITextField *projectNameTextField;



- (void)selectFirstRow;

- (void)reloadTableData;

-(void) setUpDrawingPadForProject;

@end
