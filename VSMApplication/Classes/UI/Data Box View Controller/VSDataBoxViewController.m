//
//  VSDataBoxViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import "VSDataBoxViewController.h"
#import "VSDataBoxCustomCell.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSUIManager.h"
#import "VSDataRowViewController.h"
#import "VSDrawingManager.h"
#import "VSSymbols.h"
#import "VSProcessSymbol.h"
#import "VSPushArrowSymbol.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "VSDataManager.h"
#define kMinPlacementOffsetY 51
#define kOffsetBottomEdgeSymbol 225
#define kMaxScale 1.5
#define kMinScale 1.0
#define kDefaultScrollView 150
#define kDefaultHeightOfDataBoxRow 30
#define kBufferBetweenRows 2

@interface VSDataBoxViewController ()
{
    int tableCount_;
    NSNumber *x_;
    NSNumber *y_;
    NSNumber *width_;
    NSNumber *height_;
    CGFloat lastScale_;
	CGFloat lastRotation_;
	CGFloat firstTouchLocationX_;
	CGFloat firstTouchLocationY_;
    NSMutableArray *tempArray_;
    BOOL didAddNewRow_;
    int rowViewWidth_;
    int rowViewHeight_;
    int xCoord_;
    int yCoord_;
    BOOL isAlertViewShown_;
}
@property (readwrite,nonatomic) int tableCount;
@property(nonatomic, readwrite) CGFloat lastScale;
@property(nonatomic, readwrite) CGFloat lastRotation;
@property(nonatomic, readwrite) CGFloat firstTouchLocationX;
@property(nonatomic, readwrite) CGFloat firstTouchLocationY;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *x;
@property(nonatomic, retain) NSNumber *y;
@property(nonatomic, retain) NSNumber *width;
@property(nonatomic, retain) NSNumber *height;
@property(nonatomic, retain) NSMutableArray *tempArray;
@property(nonatomic, readwrite) BOOL didAddNewRow;
@property(nonatomic, readwrite) int rowViewWidth;
@property(nonatomic, readwrite) int rowViewHeight;
@property(nonatomic, readwrite) int xCoord;
@property(nonatomic, readwrite) int yCoord;
@property(nonatomic, readwrite) BOOL isAlertViewShown;
@end

@implementation VSDataBoxViewController
@synthesize tableCount=tableCount_;
@synthesize tempArray=tempArray_;
@synthesize didAddNewRow=didAddNewRow_;
@synthesize scrollView=scrollView_;
@synthesize rowViewHeight=rowViewHeight_;
@synthesize rowViewWidth=rowViewWidth_;
@synthesize xCoord=xCoord_;
@synthesize yCoord=yCoord_;
@synthesize viewForRows=viewForRows_;
@synthesize outgoingArrows=outgoingArrows_;
@synthesize incomingArrows=incomingArrows_;
@synthesize leftNewSymbolPositionPoint=leftNewSymbolPositionPoint_;
@synthesize topNewSymbolPositionPoint=topNewSymbolPositionPoint_;
@synthesize bottomNewSymbolPositionPoint=bottomNewSymbolPositionPoint_;
@synthesize rightNewSymbolPositionPoint=rightNewSymbolPositionPoint_;
@synthesize isAlertViewShown=isAlertViewShown_;
@synthesize isFristTouchSymbol=isFristTouchSymbol_;
@synthesize ID=ID_;
@synthesize tagSymbol=tagSymbol_;
@synthesize addButton=addButton_;
@synthesize dataBoxImageColorName=dataBoxImageColorName_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(tempArray_ == nil)
            tempArray_=[[NSMutableArray alloc] initWithObjects:@"1",@"2",nil];

        if(outgoingArrows_ == nil)
            outgoingArrows_=[[NSMutableArray alloc] init];
        
        if(incomingArrows_ == nil)
            incomingArrows_=[[NSMutableArray alloc] init];
        self.tableCount=2;
        self.xCoord=0;
        self.yCoord=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self registerKeyboardChangeNotifications];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.view setUserInteractionEnabled:YES];
    
    [self.scrollView setContentSize:CGSizeMake(kDefaultScrollView, kDefaultHeightOfDataBoxRow)];
    [self addGesturesMethods];
}
- (void)dealloc {
    [_tableView release];
    [scrollView_ release];
    [viewForRows_ release];
    [incomingArrows_ release];
    [outgoingArrows_ release];
    [addButton_ release];
    [super dealloc];
}

#pragma mark - Custom Methods
//The following method resizes the Rows when the number of Rows of data Box in the View exceeds more than 5 in number
-(void)adjustTheRowsInView
{
    //Adjusting the rows in the view only when sub-View(rows) are more than 3 in number
    if([[self.viewForRows subviews] count] >3)
    {
        int numberOfRows=[[self.viewForRows subviews] count];
        int newHeightOfRow=(self.viewForRows.frame.size.height-48)/numberOfRows;
        
        int newViewOriginY=0;
        
        for(UIView *tmpView in [self.viewForRows subviews])
        {
            tmpView.frame=CGRectMake(tmpView.frame.origin.x, newViewOriginY, kDefaultScrollView, newHeightOfRow);
            newViewOriginY=tmpView.frame.origin.y+tmpView.frame.size.height+kBufferBetweenRows;
        }
    }
}

#pragma mark - Button Methods
- (IBAction)addDataBoxRoxButtonPressed:(id)sender {    

    //VSDataRowViewController *rowController=[[VSDataRowViewController alloc] initWithNibName:@"VSDataRowViewController" bundle:nil];
    
    VSDataRowViewController *rowController = [[VSDataRowViewController alloc] initWithFrame:CGRectMake(0, 0,150,30)];

    [self setParametersForRowController:rowController];

    
    if([[self.viewForRows subviews] count ]>=1)
    {
    [self settingTheColorOfDataBoxRow:rowController];
    }
    [rowController release];

}

-(void)settingTheColorOfDataBoxRow:(VSDataRowViewController*)rowController
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    for(UIView* tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
            
            if(processSymbol.dataBoxController == self)
            {
                rowController.databoxBackgroundImageView.image=[UIImage imageNamed:processSymbol.dataBoxImageColorFileName];
                self.dataBoxImageColorName=processSymbol.dataBoxImageColorFileName;
            }
        }
    }
}

-(void)setColorOnDataBox:(VSProcessSymbol*)processSymbol;
{


                for(UIView *tmpView in [self.viewForRows subviews])
                {
                    
                        VSDataRowViewController *row=(VSDataRowViewController*)tmpView;
                   
                        row.databoxBackgroundImageView.image=[UIImage imageNamed:processSymbol.dataBoxImageColorFileName];
           
                    }
  
}

-(void)setColorOfDataBox
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    for(UIView* tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;

            if(processSymbol.dataBoxController == self)
            {
                
                for(UIView *tmpView in [processSymbol.dataBoxController.viewForRows subviews])
                {
                    if([tmpView isKindOfClass:[VSDataRowViewController class]])
                    {
                        VSDataRowViewController *row=(VSDataRowViewController*)tmpView;

                        
                        if(processSymbol.ID.integerValue != 4)
                        {
                        row.databoxBackgroundImageView.image=[UIImage imageNamed:processSymbol.dataBoxImageColorFileName];
                            [processSymbol.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",processSymbol.dataBoxImageColorFileName]] forState:UIControlStateNormal];

                        }
                        
                        else
                        {
                        row.databoxBackgroundImageView.image=[UIImage imageNamed:processSymbol.imageColorFileName];
                            NSString *colorName=[VSUtilities stringBetweenString:@"data-box-single-" andString:@".png" withstring:processSymbol.imageColorFileName];
                            [processSymbol.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"data-box-bottom-%@",colorName]] forState:UIControlStateNormal];
                        }
                       
   
                        
                    }
                }
            }
        }
        
    }
}

-(void) setParametersForRowController:(VSDataRowViewController*) rowController
{
    rowController.delegateForBoxController=self;
    //setting the frame of the added row
    rowController.frame= CGRectMake(self.xCoord, self.yCoord,kDefaultScrollView,kDefaultHeightOfDataBoxRow);
    
    [rowController registerKeyboardChangeNotifications];
    
    //when the view first load the button is disabled and is only enabled if some text/data is selected from the left cell
    [rowController.timeButton setEnabled:NO];
    [rowController.numberTextField setEnabled:NO];
    
    //hiding the Labels so that the label appears empty when viewed for the first time
    [rowController setHiddenValueForLabelWithBool:YES];
    
    //updating the yCordinate for preceeding Rows
    self.yCoord=self.yCoord+kBufferBetweenRows+kDefaultHeightOfDataBoxRow;
    
    //updating the content size of the Scroll View
    //[self.scrollView setContentSize:CGSizeMake(kDefaultScrollView, self.scrollView.contentSize.height+kDefaultHeightOfDataBoxRow)];
    [rowController populateRowController];
    [self.viewForRows addSubview:rowController];
    [self adjustTheRowsInView];
}

-(void) populateDataBoxes:(NSMutableArray*) arrayDataBoxes
{
    NSDictionary *dictionaryDataBox;
    
    VSDataRowViewController *rowController;
    
    @try {
        for(dictionaryDataBox in arrayDataBoxes)
        {
            rowController = [[VSDataRowViewController alloc] initWithFrame:CGRectMake(0, 0,150,30)];
            rowController.dataLabel.text = [dictionaryDataBox objectForKey:kDataBoxDataLabel];
            rowController.hoursLabel.text = [dictionaryDataBox objectForKey:kDataBoxHrsLabel];
            rowController.minsLabel.text = [dictionaryDataBox objectForKey:kDataBoxMinLabel];
            rowController.secsLabel.text = [dictionaryDataBox objectForKey:kDataBoxSecsLabel];
            rowController.numberTextField.text = [dictionaryDataBox objectForKey:kDataBoxNoField];
            [self setParametersForRowController:rowController];
            
            [rowController release];
        }
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    
}

//#pragma mark - Gesture Methods
-(void)addMoveAndScaleGestures
{
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSymbol:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer *longGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCheck:)] autorelease];
    [longGesture setDelegate:self];
    longGesture.minimumPressDuration=1.0;
    [self.view addGestureRecognizer:longGesture];
    NSLog(@"Here in Gestsure Method");
}
-(void)addGesturesMethods
{
    /*
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateDataBox:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
   

*/
//
    UITapGestureRecognizer *tapGesture=[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapSymbol:)] autorelease];
    [tapGesture setDelegate:self];
    [tapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tapGesture];
   
}
//
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
    
    CGAffineTransform currentTransform = self.view.transform;
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.view setTransform:newTransform];
    
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}
-(void)rotateDataBox:(id)sender
{
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        self.lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform dataBoxTransform = self.view.transform;
    CGAffineTransform newDataBoxTransform = CGAffineTransformRotate(dataBoxTransform,rotation);
    [self.view setTransform:newDataBoxTransform];
    
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}
-(void) tapSymbol:(id)sender;
{
    NSLog(@"Tap made");
    [[VSUIManager sharedUIManager] showColorPickerFromDataBox:self];
}

-(void)longPressCheck:(id)sender
{
    if(!isAlertViewShown_)
    {
    
        self.isAlertViewShown=YES;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                      message:@"Are you sure you want to delete the symbol?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
    [message release];
    }
    
}
/*
-(void)moveSymbol:(id)sender
{
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MyCacheUpdatedNotification" object:self];
    UIPanGestureRecognizer *recognizer=(UIPanGestureRecognizer*)sender;
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    [tmpView bringSubviewToFront:self.view];
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    CGPoint currentCenter =self.view.center;//CGPointMake(self.frame.origin.x,self.frame.origin.y);
    
    CGFloat maxX = tmpView.frame.size.width;
    
    //following lines helps find the Left Edge position of the current symbol
    CGFloat leftEdgeOfSymbolX=CGRectGetMinX(self.view.frame);
    //following Lines helps find the Right Edge position of the current symbol
    CGFloat bottomEdgeSymbolX=CGRectGetMaxX(self.view.frame);
    
    CGFloat maxY = tmpView.frame.size.height;
    //following lines helps find the Left Edge position of the current symbol
    CGFloat topEdgePositionY=CGRectGetMinY(self.view.frame);
    
    CGFloat bottomEdgePostionY;
    //following lines gets the bottom edge of the Current symbol
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
        
        bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+kOffsetBottomEdgeSymbol-110;
        
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
    {
        
        bottomEdgePostionY=CGRectGetMaxY(self.view.frame);//+kOffsetBottomEdgeSymbol-50;
     
    }
    
    
    if(self.isFristTouchSymbol == NO)
    {
        if (leftEdgeOfSymbolX + translation.x < 0  )
        {
            translation.x =  (0 - leftEdgeOfSymbolX);
            NSLog(@"in first");
        }
        
        if (bottomEdgeSymbolX + translation.x >= maxX ) // A CHANGE HERE
        {
            translation.x = (maxX - bottomEdgeSymbolX - 1);
            NSLog(@"in second");// A CHANGE HERE
        }
        
        
        if (topEdgePositionY  + translation.y < 0)
        {
            translation.y = (0 - topEdgePositionY);
        }
        
        if (bottomEdgePostionY + translation.y >= maxY ) // A CHANGE HERE
        {
            translation.y = (maxY - bottomEdgePostionY - 1); // A CHANGE HERE
        }
        
        //self.frame=CGRectMake(self.frame.origin.x+translation.x, self.frame.origin.y+translation.y, self.frame.size.width, self.frame.size.height);
        
        
    }
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.isFristTouchSymbol == YES)
        {
            self.isFristTouchSymbol = NO;
            
            [self adjustViewsOnSymbolFirstDragAndDrop];
            //temporary
            VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate.rootViewController reloadTableData];
            
            if (leftEdgeOfSymbolX < 0 || bottomEdgeSymbolX  >= maxX
                ||topEdgePositionY < kMinPlacementOffsetY  || bottomEdgePostionY >= maxY )
            {
                [self alertForWrongSymbolPosition];
            }
            
            else
            {
                [self saveSymbolState];
            }
            
        }
        
        
        //Since the Final Position of the Process Symbol is within bounds so draw the Push Arrow Symbol
        else
        {
            [self saveSymbolState];
            
        }
    }
    
    //for moving the current Symbol
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
        {
            bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+kOffsetBottomEdgeSymbol;
  
        }
        
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
        {
            bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+kOffsetBottomEdgeSymbol-140;

        }
        
        
        
        if(self.isFristTouchSymbol == NO)
        {
            if (leftEdgeOfSymbolX + translation.x < 0  )
            {
                translation.x =  (0 - leftEdgeOfSymbolX);
                NSLog(@"in first");
            }
            
            if (bottomEdgeSymbolX + translation.x >= maxX ) // A CHANGE HERE
            {
                translation.x = (maxX - bottomEdgeSymbolX - 1);
                NSLog(@"in second");// A CHANGE HERE
            }
            
            
            if (topEdgePositionY  + translation.y < 0)
            {
                translation.y = (0 - topEdgePositionY);
            }
            
            if (bottomEdgePostionY + translation.y >= maxY ) // A CHANGE HERE
            {
                translation.y = (maxY - bottomEdgePostionY - 1); // A CHANGE HERE
            }
            
            //self.frame=CGRectMake(self.frame.origin.x+translation.x, self.frame.origin.y+translation.y, self.frame.size.width, self.frame.size.height);
            
        }
        
        currentCenter.x += translation.x;
        currentCenter.y += translation.y;
        self.view.center = currentCenter;
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
        
    }
    

}
*/
-(void) moveSymbol:(id)sender
{
    UIPanGestureRecognizer *recognizer=(UIPanGestureRecognizer*)sender;
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    [tmpView bringSubviewToFront:self.view];
    //[tmpView bringSubviewToFront:self.view];
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    CGPoint currentCenter =self.view.center;//CGPointMake(self.frame.origin.x,self.frame.origin.y);
    
    CGFloat maxX = tmpView.frame.size.width;
    
    //following lines helps find the Left Edge position of the current symbol
    CGFloat leftEdgeOfSymbolX=CGRectGetMinX(self.view.frame);
    //following Lines helps find the Right Edge position of the current symbol
    CGFloat bottomEdgeSymbolX=CGRectGetMaxX(self.view.frame);
    
    
    if (leftEdgeOfSymbolX + translation.x < 0  )
    {
        translation.x =  (0 - leftEdgeOfSymbolX);
        NSLog(@"in first");
    }
    
    if (bottomEdgeSymbolX + translation.x >= maxX ) // A CHANGE HERE
    {
        translation.x = (maxX - bottomEdgeSymbolX - 1);
        NSLog(@"in second");// A CHANGE HERE
    }
    
    
    CGFloat maxY = tmpView.frame.size.height;
    //following lines helps find the Left Edge position of the current symbol
    CGFloat topEdgePositionY=CGRectGetMinY(self.view.frame);
    //following lines gets the bottom edge of the Current symbol
    CGFloat bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+kOffsetBottomEdgeSymbol;
    
    //following lines gets the bottom edge of the Current symbol
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
        
        bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+kOffsetBottomEdgeSymbol-35;
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
    {
        bottomEdgePostionY=CGRectGetMaxY(self.view.frame)+45;//+kOffsetBottomEdgeSymbol-50;
  
    }
    
    if (topEdgePositionY  + translation.y < 0)
    {
        translation.y = (0 - topEdgePositionY);
    }
    
    if (bottomEdgePostionY + translation.y >= maxY ) // A CHANGE HERE
    {
        translation.y = (maxY - bottomEdgePostionY - 1); // A CHANGE HERE
    }
    
    //self.frame=CGRectMake(self.frame.origin.x+translation.x, self.frame.origin.y+translation.y, self.frame.size.width, self.frame.size.height);
    /*if (leftEdgeOfSymbolX < 0 ||topEdgePositionY < 0  || bottomEdgePostionY >= maxY )
    {
        [self removeCompleteSymbol];
        
    }
    */
    currentCenter.x += translation.x;
    currentCenter.y += translation.y;
    self.view.center = currentCenter;
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.isFristTouchSymbol == YES)
        {
            self.isFristTouchSymbol = NO;
            
            [self adjustViewsOnSymbolFirstDragAndDrop];
            
        }
        if([self.outgoingArrows count] != 0)
        {
            [[VSDrawingManager sharedDrawingManager] adjustOutGoingArrowsConnectedToDataBox:self];// [self adjustOutGoingArrowsConnectedToSymbol];
            
        }
        
        if([self.incomingArrows count] != 0)
        {
            [[VSDrawingManager sharedDrawingManager] adjustIncomingArrowsConnectedToDataBox:self]; //[self adjustIncomingArrowsConnectedToSymbol];
        }
        
         [self saveDataBox];
    }
    
}


#pragma mark - Custom Methods
-(void) removeCompleteSymbol
{
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kProcessKey];
    [self.view removeFromSuperview];
    [self alertForWrongSymbolPosition];
}

-(void) alertForWrongSymbolPosition
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                      message:@"Symbols can only be dropped on the drawing pad!"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
    [message release];
}

#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        NSLog(@"delete");
        self.isAlertViewShown=NO;
        
        VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

        for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            if([tmpView isKindOfClass:[VSProcessSymbol class]])
            {
                VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;

                if(processSymbol.dataBoxController == self)
                {
                    [processSymbol removeFromSuperview];
                    break;
                }
            }
        }
        
        [self.view removeFromSuperview];

  
        //Removing all the Outgoing Arrows associated with current Symbol
        for(UIView *arrowView in self.outgoingArrows)
        {
            [arrowView removeFromSuperview];
            
            //Removing the attached Inventory Symbol,IF ANY
            VSPushArrowSymbol *arrowSymbol=(VSPushArrowSymbol*)arrowView;
            if(arrowSymbol.inventoryObjectReference != nil)
                [arrowSymbol.inventoryObjectReference removeFromSuperview];
        }
        
        //Removing all the Incoming Arrows associated with current Symbol
        for(UIView *arrowView in self.incomingArrows)
        {
            [arrowView removeFromSuperview];
            
            //Removing the attached Inventory Symbol,IF ANY
            VSPushArrowSymbol *arrowSymbol=(VSPushArrowSymbol*)arrowView;
            if(arrowSymbol.inventoryObjectReference != nil)
                [arrowSymbol.inventoryObjectReference removeFromSuperview];
        }

    }
    
    if([title isEqualToString:@"Ok"])
    {
        
        [self.view removeFromSuperview];
        
    }
    else
    {
        //self.sender = nil;
    }
    
    
    
}

#pragma mark - Custom Methods
-(void) adjustViewsOnSymbolFirstDragAndDrop
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController reloadTableData];
    
    CGPoint newPoint =   [appDelegate.detailViewController.view convertPoint:self.view.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [self.view removeFromSuperview];
    
    [appDelegate.detailViewController.detailItem addSubview:self.view];
    
    self.view.frame=CGRectMake(newPoint.x,newPoint.y ,self.view.frame.size.width,self.view.frame.size.height);
    
    
}

-(void)saveSymbolState
{
    NSMutableDictionary *state = [self getAppStateDictionary];
    
    
    [DataManager setSymbolDictionary:state andType:kProcessKey andTag:self.tagSymbol];
}
-(NSMutableDictionary*) getAppStateDictionary
{
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    symbolDictionary = [self getAppStateDictionary:symbolDictionary];
    
    return [symbolDictionary autorelease];
    
    
}
-(NSMutableDictionary*) getAppStateDictionary:(NSMutableDictionary*) dict
{
    //[dict setObject:self.name forKey:@"name"];
    [dict setObject:[NSNumber numberWithFloat:self.view.frame.origin.x] forKey:@"x"];
    [dict setObject:[NSNumber numberWithFloat:self.view.frame.origin.y] forKey:@"y"];
    [dict setObject:[NSNumber numberWithInt:self.view.frame.size.height] forKey:@"H"];
    [dict setObject:[NSNumber numberWithInt:self.view.frame.size.width] forKey:@"W"];
    
    [dict setObject:self.ID forKey:@"ID"];
    
    [dict setObject:NSStringFromCGAffineTransform(self.view.transform) forKey:@"T"];
    
    
    return dict;
}
#pragma mark - Class Delegate Method
-(CGPoint)getCurrentDataBoxCordinates
{
    return CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y);
}
-(UIView*)getTheDataBoxView
{
    return self.view;
}
-(void)disableTableViewUserInteraction;
{
    [self.tableView setUserInteractionEnabled:NO];
}
-(void)enableTableViewUserInteraction;
{
    [self.tableView setUserInteractionEnabled:YES];
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
    //[[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.view withSymbolView:self.view];
    
    //the following function moves the detail View upward when the keyboard appears
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
   // [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self.view];
}

- (void)saveDataBox
{

    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    VSProcessSymbol* processSymbol;

    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            processSymbol=(VSProcessSymbol*)tmpView;
            
            if(processSymbol.dataBoxController == self)
            {
                [processSymbol saveSymbolState];
                break;
            }
        }
    }

}

-(NSMutableArray*) getDataboxArray
{
    NSArray *subviews = [self.viewForRows subviews];
    
    // Return if there are no subviews

    if ([subviews count] == 0)
    {
        return nil;
    }
    
    NSMutableArray *dataBoxArray = [[[NSMutableArray alloc] init] autorelease];
    
    UIView *subview;
    
    NSDictionary *tempRowDictionary;
    
    for (subview in subviews) {
        
        if([subview isKindOfClass:[VSDataRowViewController class]])
        {
            tempRowDictionary = [((VSDataRowViewController*)subview) getCustomDataBoxDictionary];
            [dataBoxArray addObject:tempRowDictionary];
        }
        
        
        
    }
    
    return dataBoxArray;
}
@end
