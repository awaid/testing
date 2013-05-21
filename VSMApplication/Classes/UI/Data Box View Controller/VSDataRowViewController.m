//
//  VSDataRowViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/9/13.
//
//

#import "VSDataRowViewController.h"
#import "VSDataPickerPopUpViewController.h"
#import "VSUIManager.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
@interface VSDataRowViewController ()
{
    VSDataPickerPopUpViewController *dataPickerController_;
    UIPopoverController *popOverController_;
    UIPopoverController *popOverControllerForTimePicker_;
    VSTimePickerPopUpViewController *timePickerController_;
    BOOL isDataPickerShown_;
    BOOL isTimePickerShown_;
}
@property (nonatomic,retain) VSDataPickerPopUpViewController *dataPickerController;
@property (nonatomic,retain) UIPopoverController *popOverController;
@property (nonatomic,retain) UIPopoverController *popOverControllerForTimePicker;
@property (nonatomic,retain) VSTimePickerPopUpViewController *timePickerController;
@property (nonatomic,readwrite) BOOL isDataPickerShown;
@property (nonatomic,readwrite) BOOL isTimePickerShown;
@end

@implementation VSDataRowViewController
@synthesize delegateForBoxController=delegateForBoxController_;
@synthesize dataPickerController=dataPickerController_;
@synthesize popOverController=popOverController_;
@synthesize timePickerController=timePickerController_;
@synthesize isDataPickerShown=isDataPickerShown_;
@synthesize isTimePickerShown=isTimePickerShown_;
@synthesize popOverControllerForTimePicker=popOverControllerForTimePicker_;
@synthesize minsLabel=minsLabel_;
@synthesize hoursLabel=hoursLabel_;
@synthesize secsLabel=secsLabel_;
@synthesize dataLabel=dataLabel_;
@synthesize minsHeadingLabel=minsHeadingLabel_;
@synthesize secHeadingLabel=secHeadingLabel_;
@synthesize hoursHeadingLabel=hoursHeadingLabel_;
@synthesize numberLabel=numberLabel_;
@synthesize numberTextField=numberTextField_;
@synthesize timeButton=timeButton_;
@synthesize databoxBackgroundImageView=databoxBackgroundImageView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [super viewDidLoad];

        // Do any additional setup after loading the view from its nib.
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSArray *screens=[[NSBundle mainBundle] loadNibNamed:@"VSDataRowViewController" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
        
        // Custom initialization
        // [super viewDidLoad];
        [self registerKeyboardChangeNotifications];
        
        //when the view first load the button is disabled and is only enabled if some text/data is selected from the left cell
        [self.timeButton setEnabled:NO];
        [self.numberTextField setEnabled:NO];
        
        [self.numberTextField setDelegate:self];
        
        //hiding the Labels so that the label appears empty when viewed for the first time
        [self setHiddenValueForLabelWithBool:YES];
        // Do any additional setup after loading the view from its nib.
    }
    return self;
}

- (void) awakeFromNib
{
   // [super viewDidLoad];
    [self registerKeyboardChangeNotifications];
    
    //when the view first load the button is disabled and is only enabled if some text/data is selected from the left cell
    [self.timeButton setEnabled:NO];
    [self.numberTextField setEnabled:NO];
    
    //hiding the Labels so that the label appears empty when viewed for the first time
    [self setHiddenValueForLabelWithBool:YES];
    // Do any additional setup after loading the view from its nib.
}


-(void)dealloc
{
    [dataPickerController_ release];
    [popOverController_ release];
    [timePickerController_ release];
    [dataLabel_ release];
    [hoursLabel_ release];
    [minsLabel_ release];
    [secsLabel_ release];
    [hoursHeadingLabel_ release];
    [minsHeadingLabel_ release];
    [secHeadingLabel_ release];
    [numberLabel_ release];
    [numberTextField_ release];
    [timeButton_ release];
    [databoxBackgroundImageView_ release];
    [super dealloc];
}


-(NSDictionary*) getCustomDataBoxDictionary
{
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:self.dataLabel.text forKey:kDataBoxDataLabel];
    [dictionary setObject:self.hoursLabel.text forKey:kDataBoxHrsLabel];
    [dictionary setObject:self.minsLabel.text forKey:kDataBoxMinLabel];
    [dictionary setObject:self.secsLabel.text forKey:kDataBoxSecsLabel];
    [dictionary setObject:self.numberTextField.text forKey:kDataBoxNoField];
    
    return dictionary;
    
}
#pragma mark - Custom Methods
//The following function hides or shows the labels based on the bool value
-(void)setHiddenValueForLabelWithBool:(BOOL)boolValue
{
    [self.hoursHeadingLabel setHidden:boolValue];
    [self.hoursLabel setHidden:boolValue];
    [self.minsHeadingLabel setHidden:boolValue];
    [self.minsLabel setHidden:boolValue];
    [self.secHeadingLabel setHidden:boolValue];
    [self.secsLabel setHidden:boolValue];
}
#pragma mark - PopOver Delegate Method
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:[delegateForBoxController_ getTheDataBoxView]];
    
    //enabling the User interaction
    [delegateForBoxController_ enableTableViewUserInteraction];
    
    self.isTimePickerShown=NO;
    self.isDataPickerShown=NO;
}
#pragma mark - Button Methods

- (IBAction)timeBoxButtonPressed:(id)sender {
    
    NSLog(@"time butto pressed");
    
    //disabling the User Interaction on the Table View so that no other row can be selected
    [delegateForBoxController_ disableTableViewUserInteraction];
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:[delegateForBoxController_ getTheDataBoxView]];
    
    //self.symbolViewReference=[delegateForBoxController_ getTheDataBoxView];
    
    
    
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
    }
    
    

}

- (IBAction)dataBoxButtonPressed:(id)sender {
    
    //disabling the User Interaction on the Table View so that no other row can be selected
    [delegateForBoxController_ disableTableViewUserInteraction];
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:[delegateForBoxController_ getTheDataBoxView]];
    
    
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
        self.isDataPickerShown=NO;
        
        //following checks for Non-Time Fields and hides the already show time fields on the cell
        if( [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Scrap Rate"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Defect Rate"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Operators"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Shifts"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Batch Size"])
        {
            //Showing the Labels for time
            [self setHiddenValueForLabelWithBool:YES];

            self.numberTextField.keyboardType=UIKeyboardTypeNumberPad;
            [self bringSubviewToFront:self.numberTextField];
            
            
            [self.numberTextField setEnabled:YES];
            [self.timeButton setEnabled:NO];
            [self settingTimeLabelToNull];

        }
        
        else if([[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Others"])
        {
            //Showing the Labels for time
            [self setHiddenValueForLabelWithBool:YES];
            
            self.numberTextField.keyboardType=UIKeyboardTypeDefault;
            [self bringSubviewToFront:self.numberTextField];
            
            
            [self.numberTextField setEnabled:YES];
            [self.timeButton setEnabled:NO];
            [self settingTimeLabelToNull];
            
            
            
     

        }
        
        //this ensure that when ever the relevant data is selected from the left cell,we have to enable the right TimeButton for Pop Up
        else if ([[dataPickerController_.stringArray objectAtIndex:row] isEqualToString:@"LT: Lead Time"] ||[[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"CT: Cycle Time"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"C/O: Change Over Time"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Effective Machine Cycle Time"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Uptime"] || [[dataPickerController_.stringArray objectAtIndex:row ] isEqualToString:@"Time Available"]  )
        {
            //Showing the Labels for time
            [self setHiddenValueForLabelWithBool:NO];
            
            //enabling the right time button since data has been selected for the left cell
            [self.timeButton setEnabled:YES];
            
            
            //NSLog(@"self.view.frame.size.width - > %f",self.view.frame.size.width);
            //self.timeButton.frame=CGRectMake(self.timeButton.frame.origin.x, self.timeButton.frame.origin.y, self.view.frame.size.width/2, self.view.frame.size.height);
            [self.numberTextField setEnabled:NO];
            self.numberTextField.text=@"";
            [self.numberTextField setEnabled:NO];
        }

        
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
        self.minsLabel.text=[NSString stringWithFormat:@"%d",minsInt];
        self.secsLabel.text=[NSString stringWithFormat:@"%d",secsInt];
        
        self.isTimePickerShown=NO;
    }
    
    
    
    [self.popOverController dismissPopoverAnimated:YES];
    [self.popOverControllerForTimePicker dismissPopoverAnimated:YES];
    
    //Enabling the User Interaction on the Table View of Data box
    [delegateForBoxController_ enableTableViewUserInteraction];
    
    //Moving the Data Box back to its Orignal Position
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:[delegateForBoxController_ getTheDataBoxView]];
    
    [delegateForBoxController_ saveDataBox];
}

-(void)settingTimeLabelToNull
{

    self.hoursLabel.text=@"0";
    self.minsLabel.text=@"0";
    self.secsLabel.text=@"0";
    
}

-(void) populateRowController
{
    int row = [self.dataPickerController.dataPicker selectedRowInComponent:0];
    //self.dataLabel.text=[NSString stringWithFormat:@"%@",[dataPickerController_.stringArray objectAtIndex:row ]];
    self.isDataPickerShown=NO;
    
    //following checks for Non-Time Fields and hides the already show time fields on the cell
    if( [self.dataLabel.text isEqualToString:@"Scrap Rate"] || [self.dataLabel.text isEqualToString:@"Defect Rate"] || [self.dataLabel.text isEqualToString:@"Operators"] || [self.dataLabel.text isEqualToString:@"Shifts"] || [self.dataLabel.text isEqualToString:@"Batch Size"])
    {
        //Showing the Labels for time
        [self setHiddenValueForLabelWithBool:YES];
        
        self.numberTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self bringSubviewToFront:self.numberTextField];
        
        
        [self.numberTextField setEnabled:YES];
        
    }
    
    else if([self.dataLabel.text isEqualToString:@"Others"])
    {
        //Showing the Labels for time
        [self setHiddenValueForLabelWithBool:YES];
        
        self.numberTextField.keyboardType=UIKeyboardTypeDefault;
        [self bringSubviewToFront:self.numberTextField];
        
        
        [self.numberTextField setEnabled:YES];
        
        
    }
    
    //this ensure that when ever the relevant data is selected from the left cell,we have to enable the right TimeButton for Pop Up
    else if ([self.dataLabel.text isEqualToString:@"CT: Cycle Time"] || [self.dataLabel.text isEqualToString:@"C/O: Change Over Time"] || [self.dataLabel.text isEqualToString:@"Effective Machine Cycle Time"] || [self.dataLabel.text isEqualToString:@"Uptime"] || [self.dataLabel.text isEqualToString:@"Time Available"]  )
    { 
        //Showing the Labels for time
        [self setHiddenValueForLabelWithBool:NO];
        
        self.numberTextField.hidden = YES;
        
        //enabling the right time button since data has been selected for the left cell
        [self.timeButton setEnabled:YES];
        [self.numberTextField setEnabled:NO];
    }
    
    //[delegateForBoxController_ saveDataBox];
    

}
#pragma mark - Text Field Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
       [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.superview.superview withSymbolView:self.superview.superview];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //if(self.numberTextField.isFirstResponder)
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.superview.superview];
    [delegateForBoxController_ saveDataBox];
}
#pragma mark - Keboard Delegate Method
-(void)registerKeyboardChangeNotifications
{
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
     */
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //self.view.superview -> denotes ScrollView && self.view.superview.superview denotes the view containing the ScrollView
    //if(self.numberTextField.isFirstResponder)
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.superview.superview withSymbolView:self.superview.superview];
    
    //the following function moves the detail View upward when the keyboard appears
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(self.numberTextField.isFirstResponder)
     [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.superview.superview];
    
}
@end
