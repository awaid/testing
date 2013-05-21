//
//  VSGeneralSymbol.m
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import "VSGeneralSymbol.h"
#import "VSTimePickerPopUpViewController.h"
#import "VSUIManager.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSDataManager.h"
#define kDefaultSizeOfFontForTimeLineButton 8
#define kDefaultWidthOfTextField 40
#define kDefaultHeightOfTexField 20
#define kDefaultWidth 100
#define kDefaultHeight 100

@interface VSGeneralSymbol ()
{
    UIPopoverController *popOverController_;
    VSTimePickerPopUpViewController *timePickerController_;
    UILabel *nonValueAddedTimeHeadingLabel_;
    UILabel *valueAddedTimeHeadingLabel_;
    UITextView *otherSymbolTextView_;
}

@property (nonatomic,retain) UIPopoverController *popOverController;
@property (nonatomic,retain) VSTimePickerPopUpViewController *timePickerController;
@property (nonatomic,retain) UILabel *nonValueAddedTimeHeadingLabel;
@property (nonatomic,retain) UILabel *valueAddedTimeHeadingLabel;
@property (nonatomic,retain) UITextView *otherSymbolTextView;

@end
@implementation VSGeneralSymbol
@synthesize textField1=textField1_;
@synthesize textField2=textField2_;
@synthesize buttonForTimeLinePopUp=buttonForTimeLinePopUp_;
@synthesize popOverController=popOverController_;
@synthesize timePickerController=timePickerController_;
@synthesize isNonValueAddedTimeLine=isNonValueAddedTimeLine_;
@synthesize nonValueAddedTimeHeadingLabel=nonValueAddedTimeHeadingLabel_;
@synthesize valueAddedTimeHeadingLabel=valueAddedTimeHeadingLabel_;
@synthesize otherSymbolTextView=otherSymbolTextView_;

-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID
{
    if (self = [super init]) {
        
        self.ID = metaID;
   
        [self settingInitialParameters:name andWithTag:tag];
        
        self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
        
        //Adding text field for Operators Symbol
        if(metaID.integerValue == 27)
           {
               textField1_=nil;
               textField1_=[[UITextField alloc] init];
               [self addSubview:self.textField1];
               self.textField1.delegate=self;
               [self.textField1 setKeyboardType:UIKeyboardTypeNumberPad];
               [self.textField1 setAutocorrectionType:UITextAutocorrectionTypeNo];
               self.textField1.frame=CGRectMake(85,73,kDefaultWidthOfTextField,kDefaultHeightOfTexField);
           }
        
        //Adding Text View for the Other Stuff Symbol
        else if(metaID.integerValue == 28)
        {
            otherSymbolTextView_=nil;
            otherSymbolTextView_=[[UITextView alloc] init];
            [self addSubview:self.otherSymbolTextView];
            [self.otherSymbolTextView setBackgroundColor:[UIColor clearColor]];
            [self.otherSymbolTextView setEditable:YES];
            self.otherSymbolTextView.delegate=self;
            [self.otherSymbolTextView setKeyboardType:UIKeyboardTypeNumberPad];
            [self.otherSymbolTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
            self.otherSymbolTextView.frame=CGRectMake(0, 1, kDefaultWidth, kDefaultHeight-50);
        }
    
    //Adding TimeLine Button for the Time Line Symbol 1
        else if(metaID.integerValue == 29)
        {
            buttonForTimeLinePopUp_=nil;
            buttonForTimeLinePopUp_=[[UIButton alloc] init];
            [self.buttonForTimeLinePopUp addTarget:self action:@selector(timeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.buttonForTimeLinePopUp];
            self.buttonForTimeLinePopUp.frame=CGRectMake(26, 0, 50, kDefaultHeightOfTexField);
            [self.buttonForTimeLinePopUp setTitle:@"H:0  M:0  S:0" forState:UIControlStateNormal];
            [self.buttonForTimeLinePopUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            self.buttonForTimeLinePopUp.titleLabel.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            self.isNonValueAddedTimeLine=YES;

        }
        
        //Adding TimeLine Button for the Time Line Symbol 2
        else if (metaID.integerValue == 40)
        {
            buttonForTimeLinePopUp_=nil;
            buttonForTimeLinePopUp_=[[UIButton alloc] init];
            [self.buttonForTimeLinePopUp addTarget:self action:@selector(timeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.buttonForTimeLinePopUp];
            self.buttonForTimeLinePopUp.frame=CGRectMake(26, 60, 50, kDefaultHeightOfTexField);
            [self.buttonForTimeLinePopUp setTitle:@"H:0  M:0  S:0" forState:UIControlStateNormal];
            [self.buttonForTimeLinePopUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            self.buttonForTimeLinePopUp.titleLabel.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            self.isNonValueAddedTimeLine=NO;
        }
        
        //Adding 2 Timeline text fields for the Time Line Symbol 3
        else if(metaID.integerValue == 41)
        {
            //For Non-Value Added Label
            nonValueAddedTimeHeadingLabel_=nil;
            nonValueAddedTimeHeadingLabel_=[[UILabel alloc] init];
            self.nonValueAddedTimeHeadingLabel.text=@"NonValue\rAdded Time";
            self.nonValueAddedTimeHeadingLabel.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            [self addSubview:self.nonValueAddedTimeHeadingLabel];
            self.nonValueAddedTimeHeadingLabel.frame=CGRectMake(45,4, 80, kDefaultHeightOfTexField);
            //self.nonValueAddedTimeHeadingLabel.lineBreakMode=NSLineBreakByWordWrapping;
            self.nonValueAddedTimeHeadingLabel.numberOfLines=2;
            [self.nonValueAddedTimeHeadingLabel setBackgroundColor:[UIColor clearColor]];
            textField1_=nil;
            textField1_=[[UITextField alloc] init];
            [self addSubview:self.textField1];
            self.textField1.delegate=self;
            self.textField1.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            [self.textField1 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.textField1 setAutocorrectionType:UITextAutocorrectionTypeNo];
            self.textField1.frame=CGRectMake(45, 26, kDefaultHeightOfTexField+20, kDefaultHeightOfTexField);

            //For Value Added Label
            valueAddedTimeHeadingLabel_=nil;
            valueAddedTimeHeadingLabel_=[[UILabel alloc] init];
            self.valueAddedTimeHeadingLabel.text=@"Value\rAdded Time";
            self.valueAddedTimeHeadingLabel.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            [self addSubview:self.valueAddedTimeHeadingLabel];
            self.valueAddedTimeHeadingLabel.frame=CGRectMake(45, 52, 80, kDefaultHeightOfTexField);
            self.valueAddedTimeHeadingLabel.lineBreakMode=NSLineBreakByWordWrapping;
            self.valueAddedTimeHeadingLabel.numberOfLines=2;
            [self.valueAddedTimeHeadingLabel setBackgroundColor:[UIColor clearColor]];
            
            textField2_=nil;
            textField2_=[[UITextField alloc] init];
            [self addSubview:self.textField2];
            self.textField2.delegate=self;
            self.textField2.font=[UIFont systemFontOfSize:kDefaultSizeOfFontForTimeLineButton];
            [self.textField2 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.textField2 setAutocorrectionType:UITextAutocorrectionTypeNo];
            self.textField2.frame=CGRectMake(45, 74, kDefaultHeightOfTexField+20, kDefaultHeightOfTexField);
            
        }
        
        [self.textField1 setBackgroundColor:[UIColor clearColor]];
        [self.textField2 setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

#pragma mark - Button Methods
-(void)timeButtonPressed
{
    NSLog(@"");
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:nil withSymbolView:self];
    
    if(timePickerController_ == nil)
        timePickerController_=[[VSTimePickerPopUpViewController alloc] initWithNibName:@"VSTimePickerPopUpViewController" bundle:nil];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    if(popOverController_ == nil)
        popOverController_=[[UIPopoverController alloc] initWithContentViewController:timePickerController_];
    
    [timePickerController_ setDelegate:self];
    
    [popOverController_ setDelegate:self];
    
    [popOverController_ setPopoverContentSize:CGSizeMake(self.timePickerController.view.frame.size.width, self.timePickerController.view.frame.size.height)];
    
    [popOverController_ presentPopoverFromRect:self.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    //Disabling User Interaction with the button
    [self.buttonForTimeLinePopUp setUserInteractionEnabled:NO];

}
#pragma mark - PopOver Delegate Method
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
    
    //Enabling User Interaction with the button
    [self.buttonForTimeLinePopUp setUserInteractionEnabled:YES];

    
}
#pragma mark - The Picker Delegate Method
-(void)removeFromSuperView:(id)sender
{
    NSString *hoursStr = [NSString stringWithFormat:@"%@",[self.timePickerController.hoursArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:0]]];
    
    NSString *minsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.minsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:1]]];
    
    NSString *secsStr = [NSString stringWithFormat:@"%@",[self.timePickerController.secsArray objectAtIndex:[self.timePickerController.pickerView selectedRowInComponent:2]]];
    
    [self.buttonForTimeLinePopUp setTitle:[NSString stringWithFormat:@"H:%@  M:%@  S:%@",hoursStr,minsStr,secsStr] forState:UIControlStateNormal];

    if(self.isNonValueAddedTimeLine)
    //Updating The Frame
    self.buttonForTimeLinePopUp.frame=CGRectMake(17, 0, 70, kDefaultHeightOfTexField);

    else if(!self.isNonValueAddedTimeLine)
    self.buttonForTimeLinePopUp.frame=CGRectMake(17, 60, 70, kDefaultHeightOfTexField);

    [self.popOverController dismissPopoverAnimated:YES];

    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];

    //Enabling User Interaction with the button
    [self.buttonForTimeLinePopUp setUserInteractionEnabled:YES];
    
    [self saveSymbolState];

}
#pragma mark - UItextField Delegate Method
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.textField1.isFirstResponder)
        [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.textField1 withSymbolView:self];
    
    else if(self.textField2.isFirstResponder)
        [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.textField2 withSymbolView:self];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
        [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
        [self saveSymbolState];

    
}

#pragma mark - Text View Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.otherSymbolTextView.isFirstResponder)
        [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.otherSymbolTextView withSymbolView:self];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
}

-(void)longPress:(id)sender
{
    
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kGeneralKey];
    [self removeFromSuperview];
    
}

-(NSMutableDictionary*) getAppStateDictionary
{
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    symbolDictionary = [super getAppStateDictionary:symbolDictionary];
    
    return [symbolDictionary autorelease];
}

-(void) saveSymbolState
{
    NSMutableDictionary *state = [self getAppStateDictionary];
    if(self.textField1.text != nil)
    {
        [state setObject:self.textField1.text forKey:kTextField1];
    }
    
    if(self.textField2.text != nil)
    {
        [state setObject:self.textField2.text forKey:kTextField2];
    }
    
    if(self.buttonForTimeLinePopUp.titleLabel.text != nil)
    {
        [state setObject:self.buttonForTimeLinePopUp.titleLabel.text forKey:kTimeLineLabelHours];
    }
    
    if(self.isNonValueAddedTimeLine)
    {
        [state setObject:[NSNumber numberWithBool:YES] forKey:kisNonValueBool];

    }
    
    if(!self.isNonValueAddedTimeLine)
    {
        [state setObject:[NSNumber numberWithBool:NO] forKey:kisNonValueBool];
        
    }
    
    
    [DataManager setSymbolDictionary:state andType:kGeneralKey andTag:self.tagSymbol];
}

-(void)dealloc
{
    [textField1_ release];
    [textField2_ release];
    [buttonForTimeLinePopUp_ release];
    [popOverController_ release];
    [timePickerController_ release];
    [otherSymbolTextView_ release];
    [super dealloc];
}
@end
