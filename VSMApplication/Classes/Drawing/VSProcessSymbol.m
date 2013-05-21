//
//  VSProcess.m
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSProcessSymbol.h"
#import "LNNumberpad.h"
#import "VSMAPPAppDelegate.h"
#import "VSUIManager.h"
#import "VSDrawingManager.h"
#import "VSDataBoxViewController.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "VSPushArrowSymbol.h"
#import <QuartzCore/QuartzCore.h>
#import "VSTimeLineHeadViewController.h"
#import "VSDataManager.h"
#import "VSMaterialSymbol.h"
#import "VSInfoSymbol.h"

#define kOffsetBottomEdgeSymbol 10
#define kMaxScale 1.2
#define kMinScale 0.1
#define kProcessTextFieldWidth 80
#define kProcessTextFieldHeight 20
#define kProcessTextFieldOriginY 10
#define kProcessTextFieldOriginX 10
#define kProcessNumberTextFieldOriginX 25
#define kProcessNumberTextFieldOriginY 70
#define kProcessNumberTextFieldWidth 80
#define kProcessSymbolUpperLimitPositionY 0
#define kDefaultHeightOfDataBox 150
#define kDefaultWidhtOfDataBox 100
#define kOffsetForDataboxMovement 25
#define kUpperEdgeOffsetY 20


@interface VSProcessSymbol ()
{
    float lastRotationDataBox_;
    BOOL isLongPressGestureFinished_;
    BOOL isFirstSupplier_;
    
}

@property (nonatomic,readwrite) float lastRotationDataBox;
@property (nonatomic,readwrite) BOOL isLongPressGestureFinished;
@property (nonatomic,readwrite) BOOL isFirstSupplier;

@end

@implementation VSProcessSymbol
@synthesize processNameTextField=processNameTextField_;
@synthesize processNumberTextField=processNumberTextField_;
@synthesize lastRotationDataBox=lastRotationDataBox_;
@synthesize isLongPressGestureFinished=isLongPressGestureFinished_;
@synthesize timeLineRefernce=timeLineRefernce_;
@synthesize isFirstSupplier=isFirstSupplier_;
@synthesize supplierSymbolReference=supplierSymbolReference_;
@synthesize customerSymbolReference=customerSymbolReference_;
@synthesize processBoxReferenceForSupplier=processBoxReferenceForSupplier_;
@synthesize processBoxReferenceForCustomer=processBoxReferenceForCustomer_;
@synthesize timeLineTailReference=timeLineRefernceTailReference_;



-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber *)metaID
{
    if (self = [super init]) {
        
        self.ID=metaID;
        [self settingInitialParameters:name andWithTag:tag];
         self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
        self.dataBoxImageColorFileName=[NSString stringWithFormat:@"data-box-single-outline.png"];
        self.connectedToProcessSymbolID=0;
        self.connectedFromProcessSymbolID=0;
        
        //This means its a Supplier Method
        if(metaID.integerValue == 1 || metaID.integerValue == 43)
        {
            processNameTextField_=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kProcessTextFieldOriginX, self.frame.origin.y+kProcessTextFieldOriginY+10, kProcessTextFieldWidth, kProcessTextFieldHeight+20)];
            processNameTextField_.keyboardType=UIKeyboardTypeDefault;
            processNameTextField_.keyboardAppearance=UIKeyboardAppearanceAlert;
            
            
            if(metaID.integerValue == 1)
                processNameTextField_.text=@"Supplier";
            
            else if(metaID.integerValue == 43)
                processNameTextField_.text=@"Customer";
            
            [processNameTextField_ setDelegate:self];
            
            [processNameTextField_ setBackgroundColor:[UIColor clearColor]];
            
            [processNameTextField_ setAutocorrectionType:UITextAutocorrectionTypeNo];
            
            [self addSubview:processNameTextField_];
            
        }
        
        if(metaID.integerValue == 42 || metaID.integerValue == 5)
        {
            processNameTextField_=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kProcessTextFieldOriginX, self.frame.origin.y+kProcessTextFieldOriginY, kProcessTextFieldWidth, kProcessTextFieldHeight)];
            processNameTextField_.keyboardType=UIKeyboardTypeDefault;
            processNameTextField_.keyboardAppearance=UIKeyboardAppearanceAlert;

            [processNameTextField_ setDelegate:self];

            [processNameTextField_ setBackgroundColor:[UIColor clearColor]];

            [processNameTextField_ setAutocorrectionType:UITextAutocorrectionTypeNo];

            [self addSubview:processNameTextField_];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
            [self addDataBox];


        }
        //Adding text Fields to Shared Process  & Simple Process
        if(metaID.integerValue == 2 || metaID.integerValue == 3 || metaID.integerValue == 44)
        {
        processNameTextField_=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kProcessTextFieldOriginX, self.frame.origin.y+kProcessTextFieldOriginY, kProcessTextFieldWidth, kProcessTextFieldHeight)];
        processNameTextField_.keyboardType=UIKeyboardTypeDefault;
        
        processNumberTextField_=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+kProcessNumberTextFieldOriginY-45, kProcessNumberTextFieldWidth+20, kProcessTextFieldHeight+30)];
        processNumberTextField_.keyboardAppearance=UIKeyboardAppearanceAlert;
        processNumberTextField_.keyboardType=UIKeyboardTypeNumberPad;

//adjusting the position of the number field for process box number 2
            if(metaID.integerValue == 44)
            {
                processNumberTextField_.frame=CGRectMake(processNumberTextField_.frame.origin.x, processNumberTextField_.frame.origin.y+10, processNumberTextField_.frame.size.width, processNumberTextField_.frame.size.height);
            }
        [processNameTextField_ setDelegate:self];
        [processNumberTextField_ setDelegate:self];
        
        
    
        [processNameTextField_ setBackgroundColor:[UIColor clearColor]];
        [processNumberTextField_ setBackgroundColor:[UIColor clearColor]];
        
        [processNameTextField_ setAutocorrectionType:UITextAutocorrectionTypeNo];
        [processNumberTextField_ setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        //self.clipsToBounds = YES;
        
        [self addSubview:processNameTextField_];
        [self addSubview:processNumberTextField_];
            
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
        [self addDataBox];
        
        }
        
        if(self.ID.integerValue == 4)
        {
            [self addDataBoxOnObjectCreation];
        }
        
        if(self.ID.integerValue == 44)
        {
            processNameTextField_=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kProcessTextFieldOriginX, self.frame.origin.y+kProcessTextFieldOriginY, kProcessTextFieldWidth, kProcessTextFieldHeight)];
            processNameTextField_.keyboardType=UIKeyboardTypeDefault;
            processNameTextField_.keyboardAppearance=UIKeyboardAppearanceAlert;
            
            [processNameTextField_ setDelegate:self];
            
            [processNameTextField_ setBackgroundColor:[UIColor clearColor]];
            
            [processNameTextField_ setAutocorrectionType:UITextAutocorrectionTypeNo];
            
            [self addSubview:processNameTextField_];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
                [self addDataBox];
        
        }
        
        //Following line was added for entering text through Alert View
        //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingTextFieldText:) name:@"setTextFieldText" object:nil];
        
    }
    return self;
}

-(void) addDataBoxOnObjectCreation
{
    [self addDataBox];
    self.dataBoxController.view.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.dataBoxController.view.frame.size.width, self.dataBoxController.view.frame.size.height);
    self.image=nil;
    self.isDataBoxIndependant=YES;
    [self.dataBoxController.view setUserInteractionEnabled:YES];
    [self.dataBoxController addMoveAndScaleGestures];
    self.frame=CGRectMake(self.frame.origin.x+250, self.frame.origin.y+20, self.frame.size.width, kDefaultHeightOfDataBox);
    [self setUserInteractionEnabled:NO];
    
    self.dataBoxController.view.alpha = 1.0f;
    self.dataBoxController.ID = self.ID;
}

-(void) addDataBox
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
//    self.dataBoxController=[[VSDrawingManager sharedDrawingManager] createDataBoxSymbol:@""];
//    self.dataBoxController.view.alpha = 1.0f;
//
//    [self.dataBoxController.view setFrame:CGRectMake(self.frame.origin.x-150,self.frame.origin.y+kDefaultWidhtOfDataBox, kDefaultWidhtOfDataBox, kDefaultHeightOfDataBox)];
//    [self.dataBoxController.view setUserInteractionEnabled:YES];
//    
//    [appDelegate.detailViewController.view addSubview:(UIView*)self.dataBoxController.view];
//    
//    //Adding Long press gesture to Data Box View Controller here,because its added in the subView of the Process box.Othertwise its gesture method should be in its own class
//    UILongPressGestureRecognizer *longGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCheckOnDataBox:)] autorelease];
//    [longGesture setDelegate:self];
//    longGesture.minimumPressDuration=1.0;
//    [self.dataBoxController.view addGestureRecognizer:longGesture];
    
    self.dataBoxController=[[VSDrawingManager sharedDrawingManager] createDataBoxSymbol:@""];
    self.dataBoxController.view.alpha = 0.0f;
    
    [self.dataBoxController.view setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+kDefaultWidhtOfDataBox, kDefaultWidhtOfDataBox+50, kDefaultHeightOfDataBox)];
  // self.dataBoxController.view.bounds = CGRectMake(self.frame.origin.x,self.frame.origin.y+kDefaultWidhtOfDataBox, kDefaultWidhtOfDataBox+50, kDefaultHeightOfDataBox);
    [self.dataBoxController.view setUserInteractionEnabled:YES];
    

    [appDelegate.detailViewController.detailItem addSubview:(UIView*)self.dataBoxController.view];

    
    //Adding Long press gesture to Data Box View Controller here,because its added in the subView of the Process box.Othertwise its gesture method should be in its own class
    UILongPressGestureRecognizer *longGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCheckOnDataBox:)] autorelease];
    [longGesture setDelegate:self];
    longGesture.minimumPressDuration=1.0;
    [self.dataBoxController.view addGestureRecognizer:longGesture];
    
    self.dataBoxController.ID = self.ID;
     
    //Re-adjusting The size of the Data Box Controller
    //self.dataBoxController.view.frame=CGRectMake(self.dataBoxController.view.frame.origin.x, self.frame.origin.y,150, self.dataBoxController.view.frame.size.height);


}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
#pragma mark - Keboard Delegate Method
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.processNameTextField withSymbolView:self];
    
    //the following function moves the detail View upward when the keyboard appears
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
    
}
#pragma mark - UITextView delegate Methods
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"end editing");
    [self saveSymbolState];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //[textField resignFirstResponder];
    
    [self registerKeyboardChangeNotifications];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    int limit = 50;
    
    return !([textView.text length]>limit && [text length] > range.length);
    
}
#pragma mark - Alert View Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //handling case when the DataBox View Controller exists in the View
    if(self.dataBoxController!=nil && self.isLongPressGestureFinished == YES)
    {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        [self.dataBoxController.view removeFromSuperview];
        self.dataBoxController=nil;
        self.isLongPressGestureFinished=NO;
        [self saveSymbolState];
    }
    else
    {
        self.sender = nil;
        self.isLongPressGestureFinished=NO;
    }
    }
    
    //In the case where there is not data box,this means its returning for Process Symbol So we pass the information to its Super i.e. VSSymbols
    else
    {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

#pragma mark - Custom Methods
-(void)adjustProcessSymbolDragAndDrop
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    CGPoint newPoint =   [appDelegate.detailViewController.view convertPoint:self.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [super adjustViewsOnSymbolFirstDragAndDrop];
    
    [self adjustDataBoxWithPoint:newPoint];


}

-(void) adjustDataBoxWithPoint:(CGPoint) newPoint
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    self.frame=CGRectMake(newPoint.x,newPoint.y ,self.frame.size.width,self.frame.size.height);
    
    newPoint =   [appDelegate.detailViewController.view convertPoint:self.dataBoxController.view.frame.origin toView:appDelegate.detailViewController.detailItem];
    [self.dataBoxController.view removeFromSuperview];
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)self.dataBoxController.view];
    self.dataBoxController.view.frame=CGRectMake(newPoint.x,newPoint.y ,self.dataBoxController.view.frame.size.width,self.dataBoxController.view.frame.size.height);
}
-(void)longPressCheckOnDataBox:(id)sender
{
    if(self.dataBoxController && !self.isLongPressGestureFinished)
    {
        self.isLongPressGestureFinished=YES;

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                          message:@"Are you sure you want to delete the symbol?"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        [message show];
        [message release];

    }
}
-(void)settingTextFieldText:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSString *text = [userInfo objectForKey:@"textFieldText"];
    
    //to check for Number pad entry
    if(text == nil)
    {
        text=[userInfo objectForKey:@"numFieldText"];
        processNumberTextField_.text=text;
    }
    //for Text Field entry
    else
    {
        
        processNameTextField_.text=text;
    }
}
-(void)displayKeboyardInPopOver
{
    [processNameTextField_ resignFirstResponder];
    [processNumberTextField_ resignFirstResponder];
    
}


-(void) adjustViewsOnSymbolFirstDragAndDrop
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController reloadTableData];
    
    CGPoint newPoint =   [appDelegate.detailViewController.view convertPoint:self.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [self removeFromSuperview];
    
    [appDelegate.detailViewController.detailItem addSubview:self];
    
    self.frame=CGRectMake(newPoint.x,newPoint.y ,self.frame.size.width,self.frame.size.height);
    
    //[appDelegate.detailViewController.detailItem bringSubviewToFront:self];
    
    newPoint =   [appDelegate.detailViewController.view convertPoint:self.dataBoxController.view.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [self.dataBoxController.view removeFromSuperview];
    
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)self.dataBoxController.view];
    
    
    self.dataBoxController.view.frame=CGRectMake(newPoint.x,newPoint.y ,self.dataBoxController.view.frame.size.width,self.dataBoxController.view.frame.size.height);
    
}




#pragma mark - Gesture Methods
-(void) moveSymbol:(id)sender
{
    
    self.dataBoxController.view.alpha = 1.0f;
    
    UIPanGestureRecognizer *recognizer;
    
    if(![sender isKindOfClass:[NSString class]])
    {
        recognizer=(UIPanGestureRecognizer*)sender;
    }
    
    else
    {
        recognizer = nil;
        //sender = nil;
    }
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    CGFloat leftEdgeOfSymbolX;
    // helps find the Left Edge position of the current symbol
    if(self.dataBoxController)
    leftEdgeOfSymbolX=CGRectGetMinX(self.frame)-kOffsetForDataboxMovement;
    
    else
    leftEdgeOfSymbolX=CGRectGetMinX(self.frame);

    // helps find the Right Edge position of the current symbol
    CGFloat rightEdgeSymbolX=CGRectGetMaxX(self.frame);
    
    CGFloat maxY = tmpView.frame.size.height;
    // helps find the top Edge position of the current symbol
    CGFloat topEdgePositionY=CGRectGetMinY(self.frame)+kUpperEdgeOffsetY;
    // gets the bottom edge of the Current symbol
    CGFloat bottomEdgePostionY;
    
    
    
    //If DataBox Controller exists then its bottom edge will be used for moving
    if(self.dataBoxController)
        bottomEdgePostionY=CGRectGetMaxY(self.dataBoxController.view.frame)+190;
    
    //Else Current Symbol's will be used as the Bottom Edge
    else
        bottomEdgePostionY=CGRectGetMaxY(self.frame)+40;
    
    
    CGFloat maxX = tmpView.frame.size.width-15;
    
    //Following checks for the State when the gesture has ended
    
    
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded || self.isFirstTouchOnSymbol == YES)
    {
        NSDictionary* metaData=[DataManager getDictionaryBasedOnID:self.ID.integerValue];
     
        if(self.isFirstTouchOnSymbol == YES)
        {
            self.isFirstTouchOnSymbol = NO;
            //temporary
            
            if(self.ID.intValue == 4)
            {
                self.image = nil;
                self.dataBoxController.view.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.dataBoxController.view.frame.size.width, self.dataBoxController.view.frame.size.height);
                [self.dataBoxController saveDataBox ];
                return;
                
            }
            
            
            
            //Following adds the symbol to detail View controller
            //[self adjustProcessSymbolDragAndDrop];
            
            [self saveSymbolState];
            

            // helps find the Left Edge position of the current symbol

            CGFloat leftEdgeOfSymbolX=CGRectGetMinX(self.frame);
            // helps find the Right Edge position of the current symbol
            CGFloat rightEdgeSymbolX=CGRectGetMaxX(self.frame);
            
            CGFloat maxY = tmpView.frame.size.height;
            // helps find the top Edge position of the current symbol
            CGFloat topEdgePositionY=CGRectGetMinY(self.frame);
            // gets the bottom edge of the Current symbol

            CGFloat bottomEdgePostionY=CGRectGetMinY(self.frame);

            
            //If DataBox Controller exists then its bottom edge will be used for moving
            if(self.dataBoxController)
                bottomEdgePostionY=CGRectGetMaxY(self.dataBoxController.view.frame)+kOffsetBottomEdgeSymbol;
            
            //Else Current Symbol's will be used as the Bottom Edge
            else
                bottomEdgePostionY=CGRectGetMaxY(self.frame)+125;
            
            
            CGFloat maxX = tmpView.frame.size.width-15;
            
            //following lines gets the bottom edge of the Current symbol
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
            {
                
                if(self.ID.integerValue == 3 || self.ID.integerValue == 2 || self.ID.integerValue == 5)
                {
                    bottomEdgePostionY=CGRectGetMaxY(self.frame)+300;
                    
                }
                
                //For Supplier & Customer Symbol
                if(self.ID.integerValue == 1 || self.ID.integerValue == 43)
                {
                    bottomEdgePostionY=CGRectGetMaxY(self.frame)+210;

                }
                
                //Adding for Data Box
                if(self.ID.integerValue == 4)
                {
                    bottomEdgePostionY=CGRectGetMaxY(self.frame)+180;

                }
                
            }
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
            {
                bottomEdgePostionY=CGRectGetMaxY(self.frame);//+kOffsetBottomEdgeSymbol-50;
                
                if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
                {
                    bottomEdgePostionY=CGRectGetMaxY(self.frame)-50;
                    
                }
                
            }

            //IF the Porcess Symbol has been placed ill-legally within the bounds of the iPad
            if (leftEdgeOfSymbolX < 0 || rightEdgeSymbolX  >= maxX
                ||topEdgePositionY < 0  || bottomEdgePostionY >= maxY )
            {
                [self removeCompleteSymbol];
                self.isRemoved=YES;
         
            }
                
            
            //IF the process symbol has been legally placed within the bounds of the iPad
             if(self.ID.integerValue != 4 && !self.isRemoved )
            {
                //If it has been legally placed then add time Line
                //To check if Head Time is not already added onto the Detail View Controller
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isTimeLineHeadAdded"] isEqualToString:@"NO"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"] && self.ID.integerValue != 1 && self.ID.integerValue != 43  && self.ID.integerValue != 4)
                {
                    self.timeLineRefernce=[[VSDrawingManager sharedDrawingManager] addingHeadAndTimeLineControllerOnSymbol:self];
                }
                
                else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"] && self.ID.integerValue != 1  && self.ID.integerValue != 43 && self.ID.integerValue != 4)
                {
                    self.timeLineRefernce=[[VSDrawingManager sharedDrawingManager] addingTailTimeLineControllerToProcessSymbol:self];
                }
                
                
                //To handle the case where the Current Supplier symbol is thrown for the first time
                if([VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference==nil && self.ID.integerValue ==1)
                {
                    [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=self;
                }
                
                if([VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference == nil
                   && self.ID.integerValue == 43)
                {
                    [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=self;

                }
                
                //IF its placed for the first Time, when the process box is already in place
                if([self.outgoingArrows count] == 0 && [self.incomingArrows count] == 0)
                {
                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
                    {
                        //Adding Push Arrow Symbol
                        VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                        
                        NSArray *reversedViewsArray = [[[appDelegate.detailViewController.detailItem subviews] reverseObjectEnumerator] allObjects]  ;
                        for(UIView *tmpView in reversedViewsArray )
                        {
                            if([tmpView isKindOfClass:[VSProcessSymbol class]] && tmpView != self)
                            {
                                VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
                                
                                //The following check is for scenario where Supplier is added before the process box
                                if(self.ID.integerValue != 1 && self.ID.integerValue != 43 && processSymbol.ID.integerValue == 1 && processSymbol.ID.integerValue != 4 &&  ![VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox && [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference)
                                {
                                    
                                    //Adding arrow between Supplier & process boxe
                                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self  andSymbolView:[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                                    
                                    [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=YES;
                                    
                                    self.supplierSymbolReference=[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference;
                                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isSupplierAdded"];
                                }
                                
                                //The following check is for scenario where Customer is added before the process box
                                if(self.ID.integerValue != 1 && self.ID.integerValue != 43 && processSymbol.ID.integerValue == 43 && processSymbol.ID.integerValue != 4 && ![VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox && [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)
                                {
                                    //Adding arrow between Supplier & process boxe
                                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference andSymbolView:self withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                                    
                                    [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=YES;
                                    
                                    self.customerSymbolReference=[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference;
                                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isCustomerAdded"];
                                }
                                
                                
                                //This is to make sure that Process Box doesnt get attach to Supplier/Customer Box when they are dropped
                                if(self.ID.integerValue != 1 && processSymbol.ID.integerValue != 1 && self.ID.integerValue != 43 && processSymbol.ID.integerValue != 43 && self.ID.integerValue != 4 && processSymbol.ID.integerValue != 4 && self != [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference && self != [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference )
                                {
                                    if(self.ID.integerValue != 1 && self.ID.integerValue != 43 && self.ID.integerValue != 4)
                                    {
                                        [VSDrawingManager sharedDrawingManager].lastProcessBox=processSymbol;
                                    }
                                    
                                    //Adding arrow between 2 process boxes
                                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self andSymbolView:[VSDrawingManager sharedDrawingManager].lastProcessBox withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                                    
                                    
                                    VSProcessSymbol *lastProcessBox=[VSDrawingManager sharedDrawingManager].lastProcessBox;
                                    lastProcessBox.outgoingArrows=[[NSMutableArray alloc] initWithArray: [VSDrawingManager sharedDrawingManager].lastProcessBox.outgoingArrows];
                                    
                                self.customerSymbolReference=[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference;
                                   [VSDrawingManager sharedDrawingManager].lastProcessBox=self;

                                    //Pointing the customer symbol(if it exists) to the latest process symbol

                                    if(([VSDrawingManager sharedDrawingManager].lastProcessBox.customerSymbolReference != nil &&
                                    [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox && [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference && [VSDrawingManager sharedDrawingManager].lastProcessBox.ID.integerValue != 4 && [VSDrawingManager sharedDrawingManager].lastProcessBox.customerSymbolReference == [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)|| [VSDrawingManager sharedDrawingManager].isPlacingProcessAfterParsing == YES)

                                    {

                                        VSPushArrowSymbol *pushArrowSymbol;
                                        if([lastProcessBox.outgoingArrows count] == 3)
                                        {
                                            
                                            pushArrowSymbol =[lastProcessBox.outgoingArrows objectAtIndex:[lastProcessBox.outgoingArrows count]-3];
                                        }
                                        
                                        else
                                        {
                                            
                                            pushArrowSymbol =[lastProcessBox.outgoingArrows objectAtIndex:[lastProcessBox.outgoingArrows count]-2];
                                        }
                                    

                                            [pushArrowSymbol.inventoryObjectReference removeTheReferenceOfMaterialSymbolFromArrowSymbol ];
                                            [pushArrowSymbol removeFromSuperview];
                                        
                                        
                                        if([VSDrawingManager sharedDrawingManager].isPlacingProcessAfterParsing == NO)
                                        {
                                            if([lastProcessBox.outgoingArrows count] == 3)
                                            {
                                                
                                                [lastProcessBox.outgoingArrows removeObjectAtIndex:[lastProcessBox.outgoingArrows count]-2];

                                            }
                                            
                                            else
                                            {
                                                
                                                [lastProcessBox.outgoingArrows removeObjectAtIndex:[lastProcessBox.outgoingArrows count]-2];

                                            }
                                            
                                        //Removing outgoing arrow from last Process Symbol to Customer Box
                                        }
                                        
                                        
                                        //Removing the Reference of Incoming arrow from the customer
                                        pushArrowSymbol=[[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference.incomingArrows objectAtIndex:0];
                                        [pushArrowSymbol.inventoryObjectReference removeTheReferenceOfMaterialSymbolFromArrowSymbol ];
                                        [pushArrowSymbol removeFromSuperview];


                                        //Drawing Push Arrow Symbol between Current Process Symbol and the Customer symbol
                                        [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference  andSymbolView:self withType:@"push-symbols" andCustomerSupplierSymbol:YES];
                                        
                                        self.customerSymbolReference=[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference;

                                        //
     
                                        //[VSDrawingManager sharedDrawingManager].lastProcessBox.customerSymbolReference=nil;
                                        [VSDrawingManager sharedDrawingManager].lastProcessBox=nil;
                                        [VSDrawingManager sharedDrawingManager].lastProcessBox=self;

                                        
                                        [VSDrawingManager sharedDrawingManager].isPlacingProcessAfterParsing = NO;
                                  

                               
                                        
                                    }
                                    
                                    
                                    break;
                                }//inner IF ends here
                                
                                
                                NSString *isSupplierAdded=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSupplierAdded"];
                                NSString *isCustomerAdded=[[NSUserDefaults standardUserDefaults] objectForKey:@"isCustomerAdded"];
                                
                                //This check only adds Arrow to the Supplier box only ONCE
                                if(self.ID.integerValue == 1  && processSymbol.ID.integerValue != 1 && processSymbol.ID.integerValue != 43 &&  [isSupplierAdded isEqualToString:@"NO"])
                                    
                                {
                                    //Iteraing to Find the First process box added to DetailView and connecting that process box with the current Customer/Supplier symbol
                                    //@synchronized([appDelegate.detailViewController.detailItem subviews]) {
                                 
                                    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
                                    {
                                        //DataManager getFirstProcessBox
                                        VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
                                        if([tmpView isKindOfClass:[VSProcessSymbol class]] && tmpView != self && tmpView != [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference
                                           && processSymbol.ID.integerValue != 43 && processSymbol.ID.integerValue != 4 
                                           )
                                        {
                                            
                                            
                                            
                                            [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)tmpView andSymbolView:self withType:@"push-symbols" andCustomerSupplierSymbol:YES];
                                            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isSupplierAdded"];
                                            [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=self;
                                            [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=YES;
                                            
                                            processSymbol.supplierSymbolReference=[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference;
                                            self.processBoxReferenceForSupplier=(VSProcessSymbol*)tmpView;
                                            
                           
                                            NSLog(@"In third loop");
                                            break;
                                        }
                                        
                                        
                                    }//Inner FOR Ends here
                                   // }//Sync Ends here
                                    
                                    
                                }
                                
                                //This check only adds Arrow to the Customer Supplier box only once
                                if(self.ID.integerValue == 43  && processSymbol.ID.integerValue != 43 && processSymbol.ID.integerValue != 1  && processSymbol.ID.integerValue != 4 &&  [isCustomerAdded isEqualToString:@"NO"])
                                {
                                    
                                  //  @synchronized([appDelegate.detailViewController.detailItem subviews]) {
                         

                                    //Iteraing to Find the First process box added to DetailView and connecting that process box with the current Customer/Supplier symbol
                                    for(UIView *tmpView in reversedViewsArray)
                                    {
                                        VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
                                        if([tmpView isKindOfClass:[VSProcessSymbol class]] && tmpView != self && tmpView != [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference && processSymbol.ID.integerValue != 1 && processSymbol.ID.integerValue != 4 )
                                        {
                                            
                                            
                                            [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self andSymbolView:(VSProcessSymbol*)tmpView withType:@"push-symbols" andCustomerSupplierSymbol:YES];
                                            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isCustomerAdded"];
                                            [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=self;
                                            
                                            [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=YES;
                                            
                                            processSymbol.customerSymbolReference=[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference;
                                            self.processBoxReferenceForCustomer=(VSProcessSymbol*)tmpView;
                                            
                                            NSLog(@"In third(2nd) loop");
                                            break;
                                        }
                                    
                                    }//Inner FOR Ends here
                                 //   }//Sync ends here

                                    
                                }
                          
                            }
                        }
                        
                      
                        
                    }
                 
                    
                    
                    //[self addingArrowToPreviousProcessBox];
                }
            
                
                //Connecting The Supplier symbol to production control, if production is already present
                if(self.ID.integerValue == 1 && self == [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference && [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"YES"] && ![VSDrawingManager sharedDrawingManager].isProductionControlConnectedToSupplier)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference   andSymbolView:[VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
                    
                    [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToSupplier=YES;
                }
                
                
                
                //Connecting The Customer symbol to production control, if production is already present
                if(self.ID.integerValue == 43 && self == [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference && [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"YES"] && ![VSDrawingManager sharedDrawingManager].isProductionControlConnectedToCustomer)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:                     [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference  andSymbolView:
                     (VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference
             withType:@"information-flow-2" andCustomerSupplierSymbol:YES];

                    
                    [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToCustomer=YES;
                }
                 
                //Connecting the Current Process box to the production Control if it Exists
                if([VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference != nil && self.ID.integerValue != 1 && self.ID.integerValue != 43)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self andSymbolView:(VSSymbols*)[VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference withType:@"information-flow" andCustomerSupplierSymbol:NO];
                }
                
               
         
        
            }
            
            if(self.isRemoved == NO)
            {
                [self saveSymbolState];
            }
        
           
        }
        
        else
        {
            [self saveSymbolState];
            
        }
        
        if([self.outgoingArrows count] != 0 && !self.isDataBoxIndependant)
        {
            [[VSDrawingManager sharedDrawingManager] adjustOutGoingArrowsConnectedToSymbolView:self];// [self adjustOutGoingArrowsConnectedToSymbol];
            [self saveSymbolState];
          
        }
        
        if([self.incomingArrows count] != 0 && !self.isDataBoxIndependant)
        {
            [[VSDrawingManager sharedDrawingManager] adjustIncomingArrowsConnectedToSymbolView:self]; //[self adjustIncomingArrowsConnectedToSymbol];
            [self saveSymbolState];
        }
        
        if([[VSDrawingManager sharedDrawingManager].arrayOfTimeLine count] < 3 && self.ID.integerValue != 1 && self.ID.integerValue != 43)
        {
            [[VSDrawingManager sharedDrawingManager] adjustHeadAndTailTimeLinePositionWithProcessSymbol:self];
        }
        
        if([VSDrawingManager sharedDrawingManager].isTailPresent)
        {
            [[VSDrawingManager sharedDrawingManager] adjustHeadAndTailTimeLinePositionWithProcessSymbol:self];

        }
        
        if([[metaData objectForKey:kType] integerValue] == 3)
        {
            [[VSDrawingManager sharedDrawingManager] forceCallSymbolMoveOnProcessSymbol];
        }
    }//OUTER IF ends here
    
    //for moving the current Symbol
    else
    {
        
        [tmpView bringSubviewToFront:self];
        
        CGPoint translation = [recognizer translationInView:recognizer.view.superview];
        CGPoint currentCenter =self.center;
        
        
        
        if(self.isFirstTouchOnSymbol == NO)
        {
            //Only for Supplier/Customer Symbol, since they dont have a databox attached to them(For Non Automatic)
            if((self.ID.integerValue == 1 || self.ID.integerValue == 43) && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
            {
                bottomEdgePostionY=bottomEdgePostionY;
            }
            
            //Only for Supplier/Customer Symbol, since they dont have a databox attached to them(for Automatic)
            if((self.ID.integerValue == 1 || self.ID.integerValue == 43) && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
            {
                bottomEdgePostionY=bottomEdgePostionY+150;
            }
            
            
            if (leftEdgeOfSymbolX + translation.x < 0  )
            {
                translation.x =  (0 - leftEdgeOfSymbolX);

                NSLog(@"in first");
            }
            
            if (rightEdgeSymbolX + translation.x >= maxX ) // A CHANGE HERE
            {
                translation.x = (maxX - rightEdgeSymbolX - 1);

                NSLog(@"in second");// A CHANGE HERE
            }
            
            
            if (topEdgePositionY  + translation.y < -kProcessSymbolUpperLimitPositionY)
            {
                translation.y = (-kProcessSymbolUpperLimitPositionY - topEdgePositionY);

            }
            
            if (bottomEdgePostionY + translation.y >= maxY ) // A CHANGE HERE
            {
                translation.y = (maxY - bottomEdgePostionY - 1); // A CHANGE HERE

            }
            
            //self.frame=CGRectMake(self.frame.origin.x+translation.x, self.frame.origin.y+translation.y, self.frame.size.width, self.frame.size.height);
            
        }
        
        currentCenter.x += translation.x;
        currentCenter.y += translation.y;
        
        self.center = currentCenter;
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];

        //Handling the case where Data box is added Independantly
        if(self.isDataBoxIndependant == YES)
        {
            self.dataBoxController.view.center=currentCenter;
        }
        
        //Handling case where the Data Box is added along with the Symbol
        else{
        //handling the exception when the Size of DataBox becomes larger than the size of the Process Symbol itself.
        if(self.frame.size.height > 168)
        [self.dataBoxController.view setCenter:CGPointMake(currentCenter.x, currentCenter.y+self.frame.size.height-kOffsetBottomEdgeSymbol)];
        
        else
        {
            [self.dataBoxController.view setCenter:CGPointMake(currentCenter.x, currentCenter.y+self.frame.size.height*1.5-kOffsetBottomEdgeSymbol)];
        }
        
        }
        

        
        
    }//outer ELSE Ends Here
    //[appDelegate.detailViewController.detailItem bringSubviewToFront:[DataManager getLastProcessBox]];
    
    
     [[VSDrawingManager sharedDrawingManager] forceCallSymbolMoveOnProcessSymbol];

    
}


-(void) scaleSymbol:(id) sender
{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    
    CGFloat currentScale = [[[sender view].layer valueForKeyPath:@"transform.scale"] floatValue];
    

    
    scale = MIN(scale, kMaxScale / currentScale);
    scale = MAX(scale, kMinScale / currentScale);
    
    
    //for Afro Image
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform currentTransformDataBox=self.dataBoxController.view.transform;
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    CGAffineTransform newTransformDatBox = CGAffineTransformScale(currentTransformDataBox, scale, scale);
    [self setTransform:newTransform];
    [self.dataBoxController.view setTransform:newTransformDatBox];
    
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        [self saveSymbolState];
        return;
    }
    
}


-(void) removeCompleteSymbol
{
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kProcessKey];
    [super alertForWrongSymbolPosition];
    [self.dataBoxController.view removeFromSuperview];
    
}

-(void)longPress:(id) sender
{
    
    //If it has any attached Time Lines
    if(self.timeLineRefernce != nil)
    {
        [[VSDrawingManager sharedDrawingManager] removeTimeLineFromViewAttachedToProcessSymbol:self];
    }
    
    //Removing all the Outgoing Arrows associated with current Symbol
    for(UIView *arrowView in self.outgoingArrows)
    {
        
        //Removing the attached Inventory Symbol,IF ANY
        VSPushArrowSymbol *arrowSymbol=(VSPushArrowSymbol*)arrowView;
        if(arrowSymbol.inventoryObjectReference != nil)
            [arrowSymbol.inventoryObjectReference removeTheReferenceOfMaterialSymbolFromArrowSymbol];
        [arrowSymbol removeFromSuperview];
    }
    
    //Removing all the Incoming Arrows associated with current Symbol
    for(UIView *arrowView in self.incomingArrows)
    {
        
        
        //Removing the attached Inventory Symbol,IF ANY
        VSPushArrowSymbol *arrowSymbol=(VSPushArrowSymbol*)arrowView;
        if(arrowSymbol.inventoryObjectReference != nil)
            [arrowSymbol.inventoryObjectReference removeTheReferenceOfMaterialSymbolFromArrowSymbol];
        
        [arrowSymbol removeFromSuperview];
    }
    [self.dataBoxController.view removeFromSuperview];
    
    
    
    //Handling the scenario where Process box which is removed,is placed between two other process boxes
    if([[VSDrawingManager sharedDrawingManager] findingNumberOfProcessBoxInDetaiView] > 2)
    {
        [[VSDrawingManager sharedDrawingManager] addArrowsBetweenDisconnectedProcessSymbols:self];
        //self.shouldBeRemoved=YES;
    }
    

    
    
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    

    
    //Hanlding the case where there is only one process box added to the drawing pad
    if([VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference.processBoxReferenceForCustomer == [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference.processBoxReferenceForSupplier && [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference != nil && [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference != nil)
    {
            [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=NO;
            [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=NO;
            //[self removeFromSuperview];
        
        self.shouldBeRemoved=YES;
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
    //Handling the case where the current symbol is attached to the Supplier Symbol
    if(self.supplierSymbolReference != nil)
    {
        //Removing the current Process Symbol, so that next can be found through iteration
        self.shouldBeRemoved=YES;
       // [self removeFromSuperview];

        for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
            //If the current symbol is found from the Detail Views
            if([tmpView isKindOfClass:[VSProcessSymbol class]] &&( processSymbol.ID.integerValue == 2 || processSymbol.ID.integerValue == 3 || processSymbol.ID.integerValue == 5 || processSymbol.ID.integerValue == 42) && self != tmpView)
            {
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:processSymbol andSymbolView:[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=YES;
                processSymbol.supplierSymbolReference=[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference;
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isSupplierAdded"];
                
                break;
            }
            
            else
            {
                [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=NO;

            }
            
        }
    }

    //Just to make sure that the Current View wasnt removed from the View

    if(self.customerSymbolReference != nil)
    {
        //Removing the current Process Symbol, so that next can be found through iteration
        self.shouldBeRemoved=YES;
        //[self removeFromSuperview];
            NSArray *reversedViewsArray = [[[appDelegate.detailViewController.detailItem subviews] reverseObjectEnumerator] allObjects]  ;
    
        for(UIView *tmpView in reversedViewsArray)
        {
            VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
            //If the current symbol is found from the Detail Views
            if([tmpView isKindOfClass:[VSProcessSymbol class]] &&( processSymbol.ID.integerValue == 2 || processSymbol.ID.integerValue == 3 || processSymbol.ID.integerValue == 5 || processSymbol.ID.integerValue == 42) && self != tmpView)
            {
                [[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference.incomingArrows removeAllObjects];
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference andSymbolView:processSymbol withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=YES;
                processSymbol.customerSymbolReference=[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference;
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isCustomerAdded"];
                
                break;
            }
            
            else
            {
                [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=NO;
                
            }
            
        }
    }
  
    //Handling the case where the Current symbol was the first Supplier Symbol
    if(self == [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference)
    {
        int numberOfSupplierSymbols=0;
        
        for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
            if([tmpView isKindOfClass:[VSProcessSymbol class]] && processSymbol.ID.integerValue == 1 && processSymbol != [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference)
            {
                //Making the new found supplier symbol our new Main Supplier for Auto-Coonection
                [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=processSymbol;
                
                //Adding Arrow to the Production Control if it exists
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"YES"] && [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference != nil)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:[VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference  andSymbolView:processSymbol withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
                }//Inner IF ends here
                
                
                //IF the current Symbol is attached to any other Process box
                if(self.processBoxReferenceForSupplier)
                {
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self.processBoxReferenceForSupplier andSymbolView:processSymbol withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                }
                
                processSymbol.processBoxReferenceForSupplier=[self.processBoxReferenceForSupplier retain];
                numberOfSupplierSymbols++;
                [self removeFromSuperview];
                break;
                
            }//Outer IF ends here

        }
        
        if(numberOfSupplierSymbols == 0)
        {
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToSupplier=NO;
            [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=NO;
            [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=nil;
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
           
        }
    }
    
    
    
    NSArray *reversedViewsArray = [[[appDelegate.detailViewController.detailItem subviews] reverseObjectEnumerator] allObjects]  ;
    
    //Handling the case where the Current symbol was the last Customer Symbol
    if(self == [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)
    {
        int numberOfCustomerSymbols=0;
        
        for(UIView *tmpView in reversedViewsArray)
        {
            VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
            if([tmpView isKindOfClass:[VSProcessSymbol class]] && processSymbol.ID.integerValue == 43 && processSymbol != [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)
            {
                //Making the new found supplier symbol our new Main Supplier for Auto-Coonection
                [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=processSymbol;
                
                //Adding Arrow to the Production Control if it exists
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"YES"] && [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference != nil)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:processSymbol andSymbolView:[VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference  withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
                }//Inner IF ends here
                
                
                //IF the current Symbol is attached to any other Process box
                if(self.processBoxReferenceForCustomer)
                {
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:processSymbol  andSymbolView:self.processBoxReferenceForCustomer withType:@"push-symbols" andCustomerSupplierSymbol:NO];
                    
                }
                
                processSymbol.processBoxReferenceForCustomer=[self.processBoxReferenceForCustomer retain];
                numberOfCustomerSymbols++;
                [self removeFromSuperview];
                break;
                
            }//Outer IF ends here
            
        }
        
        if(numberOfCustomerSymbols == 0)
        {
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToCustomer=NO;
            [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox=NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];

            [self removeFromSuperview];
        }
    }
      if(self.ID.integerValue == 2 || self.ID.integerValue == 3 || self.ID.integerValue == 5 || self.ID.integerValue == 42  )
    {        
        
        if([self.outgoingArrows count] > 0 && [self.incomingArrows count] >0)
        {
            
        }
     
        //[self removeFromSuperview];

    }

    //if(self.shouldBeRemoved)
      // [self removeFromSuperview];
        
    }//AUtomation Check ends here
    

    [self saveSymbolState];
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kProcessKey];
    [self removeFromSuperview];
    
    
    
    //Removing the timeline,if the deleted process box was the last one
    if([[VSDrawingManager sharedDrawingManager].arrayOfTimeLine count] ==1)
    {
        VSTimeLineHeadViewController *head=[[VSDrawingManager sharedDrawingManager].arrayOfTimeLine objectAtIndex:0];
        [head.view removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimeLineHeadAdded"];
        [[VSDrawingManager sharedDrawingManager].arrayOfTimeLine removeAllObjects];
    }
    
    else
    {
    [[VSDrawingManager sharedDrawingManager] updateTimeOnHeadTimeLine];
    }

    
    
}

-(void)removeAndAdjustingConnectionBetweenSupplierAndProcess{
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    //Handling the case where the current symbol is the Supplier Symbol to which the first process box is attached
 
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
        [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=NO;
        
        for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            VSProcessSymbol*supplierSymbol=(VSProcessSymbol*)tmpView;
            if([tmpView isKindOfClass:[VSProcessSymbol class]] && supplierSymbol.ID.integerValue == 1)
            {
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:supplierSymbol andSymbolView:[VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference withType:@"information-flow" andCustomerSupplierSymbol:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isSupplierAdded"];
                [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox=YES;
                break;
                
            }
            
        }//FOR Ends here
        
        
        
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
    
    if(self.processNameTextField !=nil)
    {
        [state setObject:self.processNameTextField.text forKey:kTextField1];
    }
    
    if(self.processNumberTextField != nil)
    {
        [state setObject:self.processNumberTextField.text forKey:kTextField2];
    }
    
    if([self.outgoingArrows count] > 0)
    {
//        id lastObject;
//        
//        if([self.outgoingArrows count] == 2)
//        {
//            lastObject = [self.outgoingArrows lastObject];
//            [self.outgoingArrows removeAllObjects];
//            [self.outgoingArrows addObject:lastObject];
//        }
  
        [state setObject:self.outgoingArrows forKey:kOutgoingArrows];
    }
    
    if([self.incomingArrows count] > 0)
    {
        [state setObject:self.incomingArrows forKey:kIncomingArrows];
    }
    
    if([VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference == self)
    {
        [state setObject:kIsCustomer forKey:kIsCustomer];
    }
    
    else if([VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference == self)
    {
        [state setObject:kIsSupplier forKey:kIsSupplier];
    }
    
    if(self.dataBoxController != nil)
    {
        NSMutableArray *arrayDataBox = [self.dataBoxController getDataboxArray];
        if(self.ID.doubleValue == 4)
        {
            [state setObject:[NSNumber numberWithFloat:self.dataBoxController.view.frame.origin.x] forKey:@"x"];
            [state setObject:[NSNumber numberWithFloat:self.dataBoxController.view.frame.origin.y] forKey:@"y"];
            [state setObject:[NSNumber numberWithInt:self.dataBoxController.view.frame.size.height] forKey:@"H"];
            [state setObject:[NSNumber numberWithInt:self.dataBoxController.view.frame.size.width] forKey:@"W"];
        }
        if(arrayDataBox != nil)
        {
            [state setObject:arrayDataBox forKey:kDataBox];
        }
        
        else
        {
            [state setObject:kDataBox forKey:kDataBox];
        }
    }
    
    if(self.processBoxReferenceForCustomer != nil)
    {
        [state setObject:self.processBoxReferenceForCustomer.tagSymbol forKey:kProcessBoxReferenceForCustomer];
    }
    
    if(self.processBoxReferenceForSupplier != nil)
    {
        [state setObject:self.processBoxReferenceForSupplier.tagSymbol forKey:kProcessBoxReferenceForSupplier];
    }
    
    if(self.supplierSymbolReference != nil)
    {
        [state setObject:self.supplierSymbolReference.tagSymbol forKey:kSupplierSymRef];
    }
    
    if(self.customerSymbolReference != nil)
    {
        [state setObject:self.customerSymbolReference.tagSymbol forKey:kCustomerSymRef];
    }
    
    if(self.dataBoxImageColorFileName != nil)
    {
        [state setObject:self.dataBoxImageColorFileName forKey:kDataBoxImageColorFileName];
    }
    
    if(self.imageColorFileName != nil)
    {
        [state setObject:self.imageColorFileName forKey:kColorFileName];

    }
    
    
    
    [DataManager setSymbolDictionary:state andType:kProcessKey andTag:self.tagSymbol];
}
@end
