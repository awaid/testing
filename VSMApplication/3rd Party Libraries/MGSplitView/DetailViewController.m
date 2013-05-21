//
//  DetailViewController.m
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import "DetailViewController.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "VSUtilities.h"
#import "VSMAPPAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#define kMaxZoomLevel 1.5
#define kMinZoomLevel 0.5
@interface DetailViewController ()
{
    UIBarButtonItem *secondButton_;
    UIButton *settingsView_;
    UIView *tempColorBackground_;
    UIBarButtonItem *thirdButton_;
    UIButton *defaultScrollinglevelButton_;
    UIBarButtonItem *fourthBarButton_;
    UIView *lineView_;
    CGPoint m_locationBegan_;
    float m_currentAngle_;
}
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *secondButton;
@property (nonatomic, retain) UIButton *settingsView;
@property (nonatomic, retain) UIButton *defaultScrollinglevelButton;
@property (nonatomic, retain) UIBarButtonItem *fourthBarButton;
@property (nonatomic, retain) UIView *tempColorBackground;
@property (nonatomic, retain) UIBarButtonItem *thirdButton;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, readwrite) CGPoint m_locationBegan;
@property (nonatomic, readwrite) float m_currentAngle;
- (void)configureView;

@end


@implementation DetailViewController


@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel,secondButton=secondButton_,settingsView=settingsView_,tempColorBackground=tempColorBackground_,scrollView=scrollView_,scrollingSlider=scrollingSlider_,zoomingScrollViewSlider=zoomingScrollViewSlider_,thirdButton=thirdButton_,zoomIndicatorLabel=zoomIndicatorLabel_,zoomIndicatorView=zoomIndicatorView_,defaultScrollinglevelButton=defaultScrollinglevelButton_,fourthBarButton=fourthBarButton_,lineView=lineView_,m_locationBegan=m_locationBegan_,m_currentAngle=m_currentAngle_;

#pragma mark - Rotating Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches moved");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches ended");
}
#pragma mark - MAIL Delegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"here");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RemoveMailModalView"
     object:self];
}

#pragma mark - Custom Methods
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 300, 400);
    
    CGContextStrokePath(context);
}

-(void)setZoomLevelToDefault
{
    if(scrollView_.zoomScale != 1.0)
    {
        [scrollView_ setZoomScale:1.0];
        [self.zoomingScrollViewSlider setValue:1.0];
        [self.detailItem setUserInteractionEnabled:YES];

    }
}
-(void)sliderAction
{
    [self.detailItem setUserInteractionEnabled:NO];
    NSLog(@"%f",self.zoomingScrollViewSlider.value/2);
   [self.scrollView setZoomScale:self.zoomingScrollViewSlider.value animated:YES];
//    self.zoomIndicatorLabel.text=[NSString stringWithFormat:@"%d0",(int)self.zoomingScrollViewSlider.value];
//  self.zoomIndicatorView.center=CGPointMake(self.scrollView.center.x, self.scrollView.center.y);
//    [self.view addSubview:self.zoomIndicatorView];
}
#pragma mark - ScrollView Delegate Methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return detailItem; //
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self.zoomingScrollViewSlider setValue:self.scrollView.zoomScale];
}
#pragma mark -
#pragma mark Managing the detail item

-(void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover=CGSizeMake(347, 147);

    [super viewWillAppear:YES];
    

    
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self toggleMasterView:self];
    //[self.scrollingSlider setHidden:YES];
    [self toggleMasterView:self];
    CALayer *sublayer = [CALayer layer];
    //sublayer.backgroundColor = [UIColor greenColor].CGColor;
    sublayer.contents=(id)[UIImage imageNamed:@"value-stream-slices_09.png"].CGImage;
    sublayer.frame = CGRectMake(0, 0, 4, self.view.frame.size.height);
    [self.view.layer addSublayer:sublayer];

}
// When setting the detail item, update the view and dismiss the popover controller if it's showing.
- (void)setDetailItem:(UIView*)newDetailItem
{
    
    
    [newDetailItem setFrame:CGRectMake(5,20,1350, self.view.frame.size.height-10)];
    [newDetailItem setBackgroundColor:[UIColor clearColor]];
    //adding temp color background View which will have white background view and will allow the detailItem view to move up since it has transparent background.
    if(tempColorBackground_ == nil)
    {
        tempColorBackground_=[[UIView alloc] initWithFrame:CGRectMake(5, 44, self.view.frame.size.width, self.view.frame.size.height)];
        [tempColorBackground_ setBackgroundColor:[UIColor whiteColor]];
        
        //tagging the detail view controller for resizing function.Shuja
        tempColorBackground_.tag=2;
    }
    if (detailItem != newDetailItem) {
        
       // UIView *detailView=detailItem;
        [detailItem setBackgroundColor:[UIColor clearColor]];
    
        
        //[UIView animateWithDuration:0.3
        //                 animations:^{detailView.alpha = 0.0;
                         //[detailItem release];
                //        }
                   //      completion:^(BOOL finished){
                             
                             //removing the previous Detail View Controller
                             [detailItem removeFromSuperview];
                             
                             //tagging the detail view controller for resizing function.Shuja
                             newDetailItem.tag=1;
                            
                             //[tempColorBackground_ removeFromSuperview];
                             
                             
                             
                             
                             if(scrollView_ == nil)
                             scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(newDetailItem.frame.origin.x, newDetailItem.frame.origin.y+23, self.view.frame.size.width, newDetailItem.frame.size.height)];
                             
                             scrollView_.delegate=self;
                             [scrollView_ setMaximumZoomScale:kMaxZoomLevel];

                             [scrollView_ setMinimumZoomScale:kMinZoomLevel];
                             [scrollView_ setZoomScale:1.0 animated:YES];
                             
                             scrollView_.contentSize = CGSizeMake(newDetailItem.frame.size.width, newDetailItem.frame.size.height);
        [detailItem setUserInteractionEnabled:YES];
        //[scrollView_ setDelaysContentTouches:NO];
        //[scrollView_ setCanCancelContentTouches:NO];
                             //[scroll addSubview:self.view];
                    
                             /*
                             
                             detailItem = [scrollView_ retain];
                             
                        
                             [self.view  addSubview:tempColorBackground_];
                             //[scroll addSubview:detailItem];
                             
                             //scroll.pagingEnabled = YES;
                             
                             [self.view addSubview:detailItem];
                              */
                             detailItem = [newDetailItem retain];
                             
                             
                              [self.view addSubview:tempColorBackground_];
                              //[scroll addSubview:detailItem];
                             
                              //scroll.pagingEnabled = YES;
                             
                              [scrollView_ addSubview:detailItem];
                             
                             
                              
                              [self.view addSubview:scrollView_];
                             [zoomingScrollViewSlider_ setHidden:NO];
        
                             [defaultScrollinglevelButton_ setHidden:NO];

        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
        {
        //Adding the black line at the bottom for automation process
            if(lineView_ == nil)
        lineView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 570, scrollView_.bounds.size.width*2, 2)];
            
        self.lineView.backgroundColor = [UIColor blackColor];
        [detailItem addSubview:self.lineView];
            
        }
        else
        {
            //[newDetailItem removeFromSuperview];
        }

        
                             //self.view.layer.zPosition  = appDelegate.rootViewController.view.layer.zPosition + 1;
                             
                             //[self.view addSubview:tempColorBackground_];
                             //[self.view addSubview:detailItem];
                             
                             
                         
                  ///       }];
        
        // Update the view.
        [self configureView];
    }
	
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}

-(void) addLine
{
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    //detailDescriptionLabel.text = [detailItem description];
	toggleItem.title = ([splitController isShowingMaster]) ? @"Hide Master" : @"Show Master"; // "I... AM... THE MASTER!" Derek Jacobi. Gave me chills.
	verticalItem.title = (splitController.vertical) ? @"Horizontal Split" : @"Vertical Split";
	dividerStyleItem.title = (splitController.dividerStyle == MGSplitViewDividerStyleThin) ? @"Enable Dragging" : @"Disable Dragging";
	masterBeforeDetailItem.title = (splitController.masterBeforeDetail) ? @"Detail First" : @"Master First";
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(MGSplitViewController*)svc 
	 willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if (barButtonItem) {
		barButtonItem.title = @"Popover2";
        
		NSMutableArray *items = [[toolbar items] mutableCopy];
		
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        settingsView_ = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 40, 44)];
        [settingsView_ addTarget:self action:@selector(toggleMasterView:) forControlEvents:UIControlEventTouchUpInside];
        [settingsView_ setBackgroundImage:[UIImage imageNamed:@"value-stream-slices_03.png"] forState:UIControlStateNormal];
        [settingsView_ setBackgroundImage:[UIImage imageNamed:@"value-stream-slices_05.png"] forState:UIControlStateSelected];
        
        if(secondButton_ == nil)
        secondButton_ = [[UIBarButtonItem alloc] initWithCustomView:settingsView_ ];
        
        defaultScrollinglevelButton_=[[UIButton alloc] initWithFrame:CGRectMake(-100, 0, 30, 32)];
        [defaultScrollinglevelButton_ addTarget:self action:@selector(setZoomLevelToDefault) forControlEvents:UIControlEventTouchUpInside];
        [defaultScrollinglevelButton_ setBackgroundImage:[UIImage imageNamed:@"value-stream-slices_46.png"] forState:UIControlStateNormal];
        [defaultScrollinglevelButton_ setBackgroundImage:[UIImage imageNamed:@"value-stream-slices_46.png"] forState:UIControlStateSelected];
        
        [defaultScrollinglevelButton_ setHidden:YES];
        
  
        if(zoomingScrollViewSlider_ == nil)
            zoomingScrollViewSlider_=[[UISlider alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
        [zoomingScrollViewSlider_ addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
        [zoomingScrollViewSlider_ setBackgroundColor:[UIColor clearColor]];
        
        
        [zoomingScrollViewSlider_ setMaximumValue:1.5];
        [zoomingScrollViewSlider_ setMinimumValue:0.5];
        zoomingScrollViewSlider_.continuous = YES;
        zoomingScrollViewSlider_.value = 1.0;
        
        [self.scrollView setZoomScale:self.zoomingScrollViewSlider.value animated:YES];

        
        if(thirdButton_ == nil)
            thirdButton_=[[UIBarButtonItem alloc] initWithCustomView:zoomingScrollViewSlider_];
        
  
        if(fourthBarButton_ == nil)
            fourthBarButton_=[[UIBarButtonItem alloc] initWithCustomView:defaultScrollinglevelButton_];

        [secondButton_ setEnabled:YES];
        [fourthBarButton_ setEnabled:YES];
        
        [zoomingScrollViewSlider_ setHidden:YES];

        [items insertObject:secondButton_ atIndex:0];
        [items insertObject:flexibleSpace atIndex:1];
        [items insertObject:fourthBarButton_ atIndex:2];
        [items insertObject:thirdButton_ atIndex:3];
        [items insertObject:barButtonItem atIndex:4];
		[toolbar setItems:items animated:YES];
		[items release];
        
        
	}
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc 
	 willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
//	//NSLog(@"%@", NSStringFromSelector(_cmd));
//	
//	if (barButtonItem) {
//		NSMutableArray *items = [[toolbar items] mutableCopy];
//		//[items removeObject:barButtonItem];
//		[toolbar setItems:items animated:YES];
//		[items release];
//	}
//   // self.popoverController = nil;
}


- (void)splitViewController:(MGSplitViewController*)svc 
		  popoverController:(UIPopoverController*)pc 
  willPresentViewController:(UIViewController *)aViewController
{
	//NSLog(@"%@", NSStringFromSelector(_cmd)); 
}


- (void)splitViewController:(MGSplitViewController*)svc willChangeSplitOrientationToVertical:(BOOL)isVertical
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willMoveSplitToPosition:(float)position
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (float)splitViewController:(MGSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	return proposedPosition;
}


#pragma mark -
#pragma mark Actions


- (void)toggleMasterView:(id)sender
{
    

    

    if(settingsView_.isSelected)
       [settingsView_ setSelected:NO];
    else
        [settingsView_ setSelected:YES];
    
	[splitController toggleMasterView:sender];
	[self configureView];
    
    //resizing the ScrollView to fit the size of the Super View
    scrollView_.frame=CGRectMake(scrollView_.frame.origin.x, scrollView_.frame.origin.y,super.view.frame.size.width, super.view.frame.size.height);
   
    //Resizing subviews
    [VSUtilities resizeSubViewsInSuperView:self.view];
   
    
}


- (IBAction)toggleVertical:(id)sender
{
	[splitController toggleSplitOrientation:self];
	[self configureView];
}


- (IBAction)toggleDividerStyle:(id)sender
{
	MGSplitViewDividerStyle newStyle = ((splitController.dividerStyle == MGSplitViewDividerStyleThin) ? MGSplitViewDividerStylePaneSplitter : MGSplitViewDividerStyleThin);
	[splitController setDividerStyle:newStyle animated:YES];
	[self configureView];
}


- (IBAction)toggleMasterBeforeDetail:(id)sender
{
	[splitController toggleMasterBeforeDetail:sender];
	[self configureView];
}

- (IBAction)toggleScreenLeftAndRight:(UIBarButtonItem *)sender {
    [splitController toggleMasterView:sender];
	[self configureView];
}

- (IBAction)buttonPopover:(UIBarButtonItem *)sender {
    
    //[[VSMAPPAppDelegate sharedAppDelegate].splitViewController showPopover:sender];
}



#pragma mark -
#pragma mark Rotation support


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationPortraitUpsideDown;
//}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self configureView];
}


- (void)dealloc
{
    [scrollingSlider_ release];
    [scrollView_ release];
    [tempColorBackground_ release];
    [popoverController release];
    [toolbar release];
    [secondButton_ release];
    [detailItem release];
    [detailDescriptionLabel release];
    [_toggleScreenLeftAndRight release];
    [scrollingSlider_ release];
    [zoomIndicatorView_ release];
    [zoomIndicatorLabel_ release];
    [super dealloc];
}


@end
