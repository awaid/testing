//
//  DetailViewController.h
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController <UIScrollViewDelegate,UIPopoverControllerDelegate, MGSplitViewControllerDelegate,MFMailComposeViewControllerDelegate> {
	IBOutlet MGSplitViewController *splitController;
	IBOutlet UIBarButtonItem *toggleItem;
	IBOutlet UIBarButtonItem *verticalItem;
	IBOutlet UIBarButtonItem *dividerStyleItem;
	IBOutlet UIBarButtonItem *masterBeforeDetailItem;
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UIScrollView *scrollView_;
    
    id detailItem;
    UILabel *detailDescriptionLabel;
    UISlider *scrollingSlider_;
    UIView *zoomIndicatorView_;
    UILabel *zoomIndicatorLabel_;
    UISlider *zoomingScrollViewSlider_;

    
}
@property (retain, nonatomic) IBOutlet UILabel *zoomIndicatorLabel;
@property (retain, nonatomic) IBOutlet UIView *zoomIndicatorView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (retain, nonatomic) IBOutlet UISlider *scrollingSlider;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UISlider *zoomingScrollViewSlider;


- (IBAction)toggleMasterView:(id)sender;
- (IBAction)toggleVertical:(id)sender;
- (IBAction)toggleDividerStyle:(id)sender;
- (IBAction)toggleMasterBeforeDetail:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *toggleScreenLeftAndRight;

@end
