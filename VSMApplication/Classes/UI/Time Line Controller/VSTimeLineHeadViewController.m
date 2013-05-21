//
//  VSTimeLineHeadViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/15/13.
//
//

#import "VSTimeLineHeadViewController.h"
#import "VSUIManager.h"
#import "VSTimePickerPopUpViewController.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSDrawingManager.h"
#import "VSProcessSymbol.h"
#import "VSMapPopulationManager.h"

@interface VSTimeLineHeadViewController ()
{
    UIPopoverController *popOverControllerForTimePicker_;
    VSTimePickerPopUpViewController *timePickerController_;
    BOOL isTimePickerShown_;
    BOOL isValueAddedTimePickerShown_;
    BOOL isNonValueAddedTimePickerShown_;
    UIAlertView *message_;
    BOOL isTailNonValueAddedTimePickerShow_;
}
@property (nonatomic,retain) UIPopoverController *popOverControllerForTimePicker;
@property (nonatomic,retain) VSTimePickerPopUpViewController *timePickerController;
@property (nonatomic,readwrite) BOOL isTimePickerShown;
@property (nonatomic,readwrite) BOOL isValueAddedTimePickerShown;
@property (nonatomic,readwrite) BOOL isNonValueAddedTimePickerShown;
@property (nonatomic,readwrite) BOOL isTailNonValueAddedTimePickerShow;
@property (nonatomic,retain) UIAlertView *message;
@end

@implementation VSTimeLineHeadViewController
@synthesize timeLineHeadView=timeLineHeadView_;
@synthesize timeLineTailView=timeLineTailView_;
@synthesize nonValueHeadHoursLabel=nonValueHeadLabel_;
@synthesize valueHeadHoursLabel=valueHeadLabel_;
@synthesize isTail=isTail_;
@synthesize popOverControllerForTimePicker=popOverControllerForTimePicker_;
@synthesize timePickerController=timePickerController_;
@synthesize isTimePickerShown=isTimePickerShown_;
@synthesize isNonValueAddedTimePickerShown=isNonValueAddedTimePickerShown_;
@synthesize isValueAddedTimePickerShown=isValueAddedTimePickerShown_;
@synthesize valueAddedTimeLabel=valueAddedTimeLabel_;
@synthesize nonValueAddedLabel=nonValueAddedLabel_;
@synthesize hoursValueAdded=hoursValueAdded_;
@synthesize minsValueAdded=minsValueAdded_;
@synthesize secsValueAdded=secsValueAdded_;
@synthesize hoursNonValueAdded=hoursNonValueAdded_;
@synthesize minsNonValueAdded=minsNonValueAdded_;
@synthesize secsNonValueAdded=secsNonValueAdded_;
@synthesize message=message_;
@synthesize isTailNonValueAddedTimePickerShow=isTailNonValueAddedTimePickerShow_;
@synthesize tagForSymbol=tagForSymbol_;
@synthesize previousLocation=previousLocation_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if(self.isTail)
    {
        [self.view addSubview:self.timeLineTailView];
        //[self addGestureMethods];

    }
    
    else if(self.isNonValueAddedTail)
    {
     
        [self.view addSubview:self.nonValueAddedTail];
        //self.
    }
    else if(!self.isTail)
    {
        [self.view addSubview:self.timeLineHeadView];

        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isTimeLineHeadAdded"];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [timeLineTailView_ release];
    [timeLineHeadView_ release];
    [nonValueHeadLabel_ release];
    [valueHeadLabel_ release];
    [valueAddedTimeLabel_ release];
    [nonValueAddedLabel_ release];
    [hoursValueAdded_ release];
    [minsValueAdded_ release];
    [secsValueAdded_ release];
    [hoursNonValueAdded_ release];
    [minsNonValueAdded_ release];
    [secsNonValueAdded_ release];
    [_nonValueHeadMinsLabel release];
    [_nonValueHeadSecsLabel release];
    [_valueHeadMinsLabel release];
    [_valueHeadSecsLabel release];
    [_nonValueAddedTail release];
    [_tailSecondsLabel release];
    [_tailMinutesLabel release];
    [_tailHoursLabel release];
    [super dealloc];
}
#pragma mark - Button Methods
- (IBAction)tailNonValueAddedButton:(id)sender {
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:self.view];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;


    popOverControllerForTimePicker_=nil;
    timePickerController_ = nil;
    timePickerController_=[[VSTimePickerPopUpViewController alloc] initWithNibName:@"VSTimePickerPopUpViewController" bundle:nil];
    
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;

    if(!self.isTimePickerShown)
    {
        self.isTimePickerShown=YES;
        
        self.isNonValueAddedTimePickerShown=NO;
        self.isValueAddedTimePickerShown=NO;
        self.isTailNonValueAddedTimePickerShow=YES;

        
        [self.view setUserInteractionEnabled:NO];
        self.isTimePickerShown=YES;
        //if(popOverControllerForTimePicker_ == nil)
        popOverControllerForTimePicker_=[[UIPopoverController alloc] initWithContentViewController:timePickerController_];
        
        [timePickerController_ setDelegate:self];
        
        [popOverControllerForTimePicker_ setDelegate:self];
        
        [popOverControllerForTimePicker_ setPopoverContentSize:CGSizeMake(self.timePickerController.view.frame.size.width, self.timePickerController.view.frame.size.height)];
        
        [popOverControllerForTimePicker_ presentPopoverFromRect:self.view.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


- (IBAction)valueAddedTimeButtonPressed:(id)sender {

    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:self.view];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    
    popOverControllerForTimePicker_=nil;
    timePickerController_ = nil;
    timePickerController_=[[VSTimePickerPopUpViewController alloc] initWithNibName:@"VSTimePickerPopUpViewController" bundle:nil];
    
    
    
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    if(!self.isTimePickerShown)
    {
    
    self.isValueAddedTimePickerShown=YES;
    self.isNonValueAddedTimePickerShown=NO;
    self.isTailNonValueAddedTimePickerShow=NO;
        
    [self.view setUserInteractionEnabled:NO];
    self.isTimePickerShown=YES;
    //if(popOverControllerForTimePicker_ == nil)
        popOverControllerForTimePicker_=[[UIPopoverController alloc] initWithContentViewController:timePickerController_];
    
    [timePickerController_ setDelegate:self];
    
    [popOverControllerForTimePicker_ setDelegate:self];
    
    [popOverControllerForTimePicker_ setPopoverContentSize:CGSizeMake(self.timePickerController.view.frame.size.width, self.timePickerController.view.frame.size.height)];
    
    [popOverControllerForTimePicker_ presentPopoverFromRect:self.view.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

    
}


- (IBAction)nonValueAddedTimeButtonPressed:(id)sender {
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:self.view];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    
    popOverControllerForTimePicker_=nil;
    timePickerController_ = nil;
        timePickerController_=[[VSTimePickerPopUpViewController alloc] initWithNibName:@"VSTimePickerPopUpViewController" bundle:nil];
    
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    if(!self.isTimePickerShown)
    {
        
        self.isNonValueAddedTimePickerShown=YES;
        self.isValueAddedTimePickerShown=NO;
        self.isTailNonValueAddedTimePickerShow=NO;
        
        [self.view setUserInteractionEnabled:NO];
        self.isTimePickerShown=YES;
        //if(popOverControllerForTimePicker_ == nil)
            popOverControllerForTimePicker_=[[UIPopoverController alloc] initWithContentViewController:timePickerController_];
        
        [timePickerController_ setDelegate:self];
        
        [popOverControllerForTimePicker_ setDelegate:self];
        
        [popOverControllerForTimePicker_ setPopoverContentSize:CGSizeMake(self.timePickerController.view.frame.size.width, self.timePickerController.view.frame.size.height)];
        
        [popOverControllerForTimePicker_ presentPopoverFromRect:self.view.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - PopOver Delegate Method
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.view];
    
    //enabling the User interaction
    [self.view setUserInteractionEnabled:YES];
    
    self.isTimePickerShown=NO;
    timePickerController_=nil;
    popOverControllerForTimePicker_=nil;
}
#pragma mark - Time Picker Delegate Method
-(void)removeFromSuperView:(id)sender
{
    //Handling case for Data Picker Controller
  if([sender isKindOfClass:[VSTimePickerPopUpViewController class]])
    {
        NSString *hoursStr = [NSString stringWithFormat:@"%@",[self.timePickerController.hoursArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:0]]];
        
        NSString *minsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.minsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:1]]];
        
        NSString *secsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.secsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:2]]];
        
        int hoursInt = [hoursStr intValue];
        int minsInt = [minsStr intValue];
        int secsInt = [secsStr intValue];
        
        
        if(self.isValueAddedTimePickerShown)
        {
            self.hoursValueAdded.text=[NSString stringWithFormat:@"%d",hoursInt];
            self.minsValueAdded.text=[NSString stringWithFormat:@"%d",minsInt];
            self.secsValueAdded.text=[NSString stringWithFormat:@"%d",secsInt];
        }
        
        else if(self.isNonValueAddedTimePickerShown)
        {
            self.hoursNonValueAdded.text=[NSString stringWithFormat:@"%d",hoursInt];
            self.minsNonValueAdded.text=[NSString stringWithFormat:@"%d",minsInt];
            self.secsNonValueAdded.text=[NSString stringWithFormat:@"%d",secsInt];
        }
        
        else if(self.isTailNonValueAddedTimePickerShow)
        {
            self.tailHoursLabel.text=[NSString stringWithFormat:@"%d",hoursInt];
            self.tailMinutesLabel.text=[NSString stringWithFormat:@"%d",minsInt];
            self.tailSecondsLabel.text=[NSString stringWithFormat:@"%d",secsInt];
        }

        
        self.isTimePickerShown=NO;
    }
    
    
    
    [self.popOverControllerForTimePicker dismissPopoverAnimated:YES];
    
    //Enabling the User Interaction on the Table View of Data box
    [self.view setUserInteractionEnabled:YES];
    
    //Updating Time on the Head of Time Line
    [self updateTimeOnHeadTimeLine];
    //Moving the Data Box back to its Orignal Position
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.view];
    
    timePickerController_=nil;
    popOverControllerForTimePicker_=nil;
    
    //Saving the Value of the Time Line Controller
    [[[VSMapPopulationManager sharedPopulationManager] getSymbolViewForTag:self.tagForSymbol] saveSymbolState];

}
#pragma mark - Custom Methods
-(void)updateTimeOnHeadTimeLine
{
    int numberOfTailTimeLines=[[VSDrawingManager sharedDrawingManager].arrayOfTimeLine count];
    
    int valueAddedTotalTimeHours=0;
    int valueAddedTotalTimeMins=0;
    int valueAddedTotalTimeSecs=0;
    
    int nonValueAddedTotalTimeHours=0;
    int nonValueAddedTotalTimeMins=0;
    int nonValueAddedTotalTimeSecs=0;
    
//    
//    int tailTotalTimeHours=0;
//    int tailTotalTimeSecs=0;
//    int tailTotalTimeMins=0;
    
    for(int i=0; i < numberOfTailTimeLines ;i++)
    {
        VSTimeLineHeadViewController *timeLineController=[[VSDrawingManager sharedDrawingManager].arrayOfTimeLine objectAtIndex:i];
       
        //For Value added Part
        valueAddedTotalTimeHours=valueAddedTotalTimeHours+timeLineController.hoursValueAdded.text.integerValue;
        valueAddedTotalTimeMins=valueAddedTotalTimeMins+timeLineController.minsValueAdded.text.integerValue;
        valueAddedTotalTimeSecs=valueAddedTotalTimeSecs+timeLineController.secsValueAdded.text.integerValue;
        
        float remainderMins=valueAddedTotalTimeMins / 60;
        
        if(remainderMins >= 0 && valueAddedTotalTimeMins > 0)
        {
            while(remainderMins >= 0)
            {
                if(remainderMins == 0)
                    break;
                
                valueAddedTotalTimeHours=valueAddedTotalTimeHours+1;
                valueAddedTotalTimeMins=valueAddedTotalTimeMins-60;
                remainderMins=valueAddedTotalTimeMins / 60;
            }
        }
        
        float remainderSecs=valueAddedTotalTimeSecs / 60;

        if(remainderSecs >= 0 && valueAddedTotalTimeSecs > 0)
        {
            while (remainderSecs >= 0)
            {
                if(remainderSecs == 0)
                    break;
                
                valueAddedTotalTimeMins=valueAddedTotalTimeMins+1;
                valueAddedTotalTimeSecs=valueAddedTotalTimeSecs-60;
                remainderSecs=valueAddedTotalTimeSecs / 60;
            }
        }
        
        
        //For Non-Value Added Part
        nonValueAddedTotalTimeHours=nonValueAddedTotalTimeHours+timeLineController.hoursNonValueAdded.text.integerValue+timeLineController.tailHoursLabel.text.integerValue;
        nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins+timeLineController.minsNonValueAdded.text.integerValue+timeLineController.tailMinutesLabel.text.integerValue;
        nonValueAddedTotalTimeSecs=nonValueAddedTotalTimeSecs+timeLineController.secsNonValueAdded.text.integerValue+timeLineController.tailSecondsLabel.text.integerValue;
        
        remainderMins=nonValueAddedTotalTimeMins / 60;
        
        if(remainderMins >= 0 && nonValueAddedTotalTimeMins >0)
        {
            while (remainderMins >= 0) {
                
                if(remainderMins == 0)
                    break;
                
                nonValueAddedTotalTimeHours=nonValueAddedTotalTimeHours+1;
                nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins-60;
                remainderMins=nonValueAddedTotalTimeMins / 60;
                
            }
       
        }
        
        remainderSecs=nonValueAddedTotalTimeSecs / 60;

        if(remainderSecs >= 0 && nonValueAddedTotalTimeSecs > 0)
        {
            while (remainderSecs >= 0)
            {
                if(remainderSecs == 0)
                    break;
                
                nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins+1;
                nonValueAddedTotalTimeSecs=nonValueAddedTotalTimeSecs-60;
                remainderSecs=nonValueAddedTotalTimeSecs / 60;

                
            }
            
        }
        
  
        //For Tail part
    /*
    tailTotalTimeHours=tailTotalTimeHours+timeLineController.tailHoursLabel.text.integerValue;
    tailTotalTimeMins=tailTotalTimeMins+timeLineController.tailMinutesLabel.text.integerValue;
    tailTotalTimeSecs=tailTotalTimeSecs+timeLineController.tailSecondsLabel.text.integerValue;
    
    remainderMins=tailTotalTimeMins / 60;
    
    if(remainderMins >= 0 && tailTotalTimeMins >0)
    {
        while (remainderMins >= 0) {
            
            if(remainderMins == 0)
                break;
            
            tailTotalTimeHours=tailTotalTimeHours+1;
            tailTotalTimeMins=tailTotalTimeMins-60;
            remainderMins=tailTotalTimeMins / 60;
            
        }
        
    }
    
    remainderSecs=tailTotalTimeSecs / 60;
    
    if(remainderSecs >= 0 && tailTotalTimeSecs > 0)
    {
        while (remainderSecs >= 0)
        {
            if(remainderSecs == 0)
                break;
            
            tailTotalTimeMins=tailTotalTimeMins+1;
            tailTotalTimeSecs=tailTotalTimeSecs-60;
            remainderSecs=tailTotalTimeSecs / 60;
            
            
        }
        
    }
    */
    }

    if(self.isNonValueAddedTimePickerShown || self.isTailNonValueAddedTimePickerShow)
    {
        [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadHoursLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeHours];
        
        [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadMinsLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeMins];
        
        [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadSecsLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeSecs];
        
    }
    
    else if (self.isValueAddedTimePickerShown)
    {
        [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadHoursLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeHours];
        
        [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadMinsLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeMins];
        
          [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadSecsLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeSecs];
    }


}

#pragma mark - Gesture Methods
-(void)addGestureMethods
{
    UILongPressGestureRecognizer *longGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCheck:)] autorelease];
    [longGesture setDelegate:self];
    longGesture.minimumPressDuration=1.0;
    [self.timeLineTailView addGestureRecognizer:longGesture];

}
-(void) longPressCheck:(id) sender
{
    if(message_ == nil)
    {
        message_ = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                          message:@"Are you sure you want to delete the symbol?"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    
    
        [self.message show];
        [self.message release];
    }
    
}
#pragma mark - Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Yes"])
        {
            
            VSProcessSymbol *processSymbol=[self findingReferenceOfSymbolToWhichTimeLineIsAttached];

            //Incase if the current timeline was added independently through drag and drop
            if(processSymbol == nil)
               [self.view removeFromSuperview];

        }

}

#pragma mark - Custom Methods
-(VSProcessSymbol*)findingReferenceOfSymbolToWhichTimeLineIsAttached
{
    VSProcessSymbol *processSymbol;
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            processSymbol=(VSProcessSymbol*)tmpView;
            
            //If the Process Symbol is attached with the Current Timeline
            if(processSymbol.timeLineRefernce == self)
            {
                [[VSDrawingManager sharedDrawingManager] removeTimeLineFromViewAttachedToProcessSymbol:processSymbol];
                break;
            }
        }
    }
    
    return processSymbol;
}
- (void)viewDidUnload {
    [self setNonValueHeadMinsLabel:nil];
    [self setNonValueHeadSecsLabel:nil];
    [self setValueHeadMinsLabel:nil];
    [self setValueHeadSecsLabel:nil];
    [super viewDidUnload];
}
@end
