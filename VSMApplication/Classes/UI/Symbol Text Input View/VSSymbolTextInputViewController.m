//
//  VSSymbolTextInputViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/29/13.
//
//

#import "VSSymbolTextInputViewController.h"
#import "VSUtilities.h"
#import "VSUIManager.h"
@interface VSSymbolTextInputViewController ()

@end

@implementation VSSymbolTextInputViewController
@synthesize headingText=headingText_;
@synthesize headingTextLabel=headingTextLabel_;
@synthesize inputTextField=inputTextField_;
@synthesize inputText=inputText_;
@synthesize isNumPad=isNumPad_;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //just to achieved the Fade in and Fade out effect
    self.view.alpha=0.0;
    self.inputTextField.text=self.inputText;
    self.headingTextLabel.text=self.headingText;
    
    if(self.isNumPad)
    {
        self.inputTextField.keyboardAppearance=UIKeyboardAppearanceAlert;
        self.inputTextField.keyboardType=UIKeyboardTypeNumberPad;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self registerKeyboardChangeNotifications];
}
- (void)dealloc {
    [headingTextLabel_ release];
    [inputTextField_ release];
    [headingText_ release];
    [super dealloc];
}


#pragma mark - Button Methods
- (IBAction)enterButtonPressed:(id)sender {
   
    NSDictionary *userInfo ;
    if(!self.isNumPad)
    {
        userInfo = [NSDictionary dictionaryWithObject:self.inputTextField.text forKey:@"textFieldText"];
    }
    
    else if(self.isNumPad)
    {
           userInfo = [NSDictionary dictionaryWithObject:self.inputTextField.text forKey:@"numFieldText"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"setTextFieldText" object:nil userInfo:userInfo];


    [VSUtilities removeGreyTransparentViewFromWindow];
    [[VSUIManager sharedUIManager] removeSymbolTextInputView];

}
- (IBAction)cancelButtonPressed:(id)sender {
    
    [VSUtilities removeGreyTransparentViewFromWindow];
    [[VSUIManager sharedUIManager] removeSymbolTextInputView];
}

#pragma mark - Keyboard Methods
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    self.view.frame=CGRectMake(self.view.frame.origin.x-140, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    self.view.frame=CGRectMake(self.view.frame.origin.x+140, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}
@end
