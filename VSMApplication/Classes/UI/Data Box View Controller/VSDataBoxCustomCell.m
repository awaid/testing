//
//  VSDataBoxCustomCell.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import "VSDataBoxCustomCell.h"
#import "VSDataPickerPopUpViewController.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSTimePickerPopUpViewController.h"
#import "VSUIManager.h"
#define kBeforeOffsetOriginPositionX 700
#define kAfterOffsetOriginPositionY  415
#define kDataPickerTag 100
@interface VSDataBoxCustomCell()
{
    UIPopoverController *popOverController_;
    VSDataPickerPopUpViewController *dataPickerController_;
    BOOL isDataPickerShown_;
    UIView *symbolViewReference_;
    VSTimePickerPopUpViewController *timePickerController_;
    BOOL isTimePickerShown_;
    UIPopoverController *popOverControllerForTimePicker_;
}
@property (nonatomic,retain) UIPopoverController *popOverController;
@property (nonatomic,retain) UIPopoverController *popOverControllerForTimePicker;
@property (nonatomic,retain) VSDataPickerPopUpViewController *dataPickerController;
@property (nonatomic,retain) VSTimePickerPopUpViewController *timePickerController;
@property (nonatomic,readwrite) BOOL isDataPickerShown;
@property (nonatomic,readwrite) BOOL isTimePickerShown;
@property (nonatomic,retain) UIView *symbolViewReference;
@end

@implementation VSDataBoxCustomCell
@synthesize popOverController=popOverController_;
@synthesize dataPickerController=dataPickerController_;
@synthesize dataButton=dataButton_;
@synthesize dateButton=dateButton_;
@synthesize isDataPickerShown=isDataPickerShown_;
@synthesize delegateForBoxController=delegateForBoxController_;
@synthesize dataLabel=dataLabel_;
@synthesize symbolViewReference=symbolViewReference_;
@synthesize timePickerController=timePickerController_;
@synthesize isTimePickerShown=isTimePickerShown_;
@synthesize popOverControllerForTimePicker=popOverControllerForTimePicker_;
@synthesize secondsLabel=secondsLabel_;
@synthesize hoursLabel=hoursLabel_;
@synthesize minutesLabel=minutesLabel_;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       // self.delegateForBoxController = delegate;
        
    }
    return self;
    
}


- (void)dealloc {
    [dataButton_ release];
    [dateButton_ release];
    [dataLabel_ release];
    [popOverController_ release];
    [popOverControllerForTimePicker_ release];
    [dataPickerController_ release];
    [timePickerController_ release];
    [hoursLabel_ release];
    [minutesLabel_ release];
    [secondsLabel_ release];
    
    [super dealloc];
}

#pragma mark - PopOver Delegate Method
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:[delegateForBoxController_ getTheDataBoxView]];
    
    //enabling the User interaction
    [delegateForBoxController_ enableTableViewUserInteraction];
    
//    [self.dataPickerController.view removeFromSuperview];
//    [self.timePickerController.view removeFromSuperview];
    self.isTimePickerShown=NO;
    self.isDataPickerShown=NO;
    
}
#pragma mark - Button Methods
- (IBAction)dataButtonPressed:(id)sender {
    
    //disabling the User Interaction on the Table View so that no other row can be selected
    [delegateForBoxController_ disableTableViewUserInteraction];

    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:[delegateForBoxController_ getTheDataBoxView]];

    self.symbolViewReference=[delegateForBoxController_ getTheDataBoxView];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;


    if(dataPickerController_ == nil)
        dataPickerController_=[[VSDataPickerPopUpViewController alloc] initWithNibName:@"VSDataPickerPopUpViewController" bundle:nil];
    
    if(!self.isDataPickerShown)
    {
        
        self.isDataPickerShown=YES;
        [dataPickerController_ setDelegate:self];
        

        // To get the Detail Item view on which the symbols are added upon
        UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
        

        popOverController_=nil;
         popOverController_=[[UIPopoverController alloc] initWithContentViewController:dataPickerController_];
        
        [popOverController_ setDelegate:self];
        
        [popOverController_ setPopoverContentSize:CGSizeMake(dataPickerController_.view.frame.size.width, dataPickerController_.view.frame.size.height)];
        
        [popOverController_ presentPopoverFromRect:[delegateForBoxController_ getTheDataBoxView].frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [delegateForBoxController_ saveDataBox];

    }
}





- (IBAction)timeButtonPressed:(id)sender {
    NSLog(@"time butto pressed");
    
    //disabling the User Interaction on the Table View so that no other row can be selected
    [delegateForBoxController_ disableTableViewUserInteraction];
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:[delegateForBoxController_ getTheDataBoxView]];
    
    self.symbolViewReference=[delegateForBoxController_ getTheDataBoxView];

    
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    
    if(timePickerController_ == nil)
        timePickerController_=[[VSTimePickerPopUpViewController alloc] initWithNibName:@"VSTimePickerPopUpViewController" bundle:nil];
    
    if(!self.isTimePickerShown)
    {
        
        self.isTimePickerShown=YES;
        [timePickerController_ setDelegate:self];
        
        
        // To get the Detail Item view on which the symbols are added upon
        UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;

        
        if(popOverControllerForTimePicker_ == nil)
        popOverControllerForTimePicker_=[[UIPopoverController alloc] initWithContentViewController:timePickerController_];
        
        [popOverControllerForTimePicker_ setDelegate:self];
        
        [popOverControllerForTimePicker_ setPopoverContentSize:CGSizeMake(self.timePickerController.view.frame.size.width, self.timePickerController.view.frame.size.height)];
        
        [popOverControllerForTimePicker_ presentPopoverFromRect:[delegateForBoxController_ getTheDataBoxView].frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        NSLog(@"Time PopOver presented");
        
         [delegateForBoxController_ saveDataBox];
    }

    


}

//Following method removes the current View from the Detail View controller
-(void)removeFromSuperView:(id)sender
{
    int row;
    //Handling case for Data Picker Controller
    if([sender isKindOfClass:[VSDataPickerPopUpViewController class]])
    {
        row = [self.dataPickerController.dataPicker selectedRowInComponent:0];
        self.dataLabel.text=[NSString stringWithFormat:@"%@",[dataPickerController_.stringArray objectAtIndex:row ]];
        //[dataPickerController_.view removeFromSuperview];
         self.isDataPickerShown=NO;

    }
    
    
    else if([sender isKindOfClass:[VSTimePickerPopUpViewController class]])
    {
        NSString *hoursStr = [NSString stringWithFormat:@"%@",[self.timePickerController.hoursArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:0]]];
        
        NSString *minsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.minsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:1]]];
        
        NSString *secsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.secsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:2]]];
        
        int hoursInt = [hoursStr intValue];
        int minsInt = [minsStr intValue];
        int secsInt = [secsStr intValue];
                
        self.hoursLabel.text=[NSString stringWithFormat:@"%d",hoursInt];
        self.minutesLabel.text=[NSString stringWithFormat:@"%d",minsInt];
        self.secondsLabel.text=[NSString stringWithFormat:@"%d",secsInt];

        self.isTimePickerShown=NO;
    }
    

    
    [self.popOverController dismissPopoverAnimated:YES];
    [self.popOverControllerForTimePicker dismissPopoverAnimated:YES];

    //Enabling the User Interaction on the Table View of Data box
    [delegateForBoxController_ enableTableViewUserInteraction];
    
    //Moving the Data Box back to its Orignal Position
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.symbolViewReference];
    
     //[delegateForBoxController_ saveDataBox];
}

@end
