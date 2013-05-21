//
//  VSMaterial.m
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import "VSMaterialSymbol.h"
#import "VSUIManager.h"
#import "VSMAPPAppDelegate.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "DetailViewController.h"
#import "VSPushArrowSymbol.h"
#import "VSDataManager.h"
#define kMaxScale 1.2
#define kMinScale 0.1
#define kOffsetBottomEdgeSymbol 10
#define kDefaultTextViewPositionX 0
#define kDefaultTextViewPositionY 100
#define kDefaultTextViewWidth 50
#define kDefaultTextViewHeight 50
#define kDefaultWidth 100
#define kDefaultHeight 100


@implementation VSMaterialSymbol
@synthesize textField=textField_;
@synthesize isInventorySymbol=isInventorySymbol_;
@synthesize oldScale=oldScale_;

-(id)initWithName:(NSString *)name withTag:(NSString *)tag
{
    if (self = [super init]) {

        [self settingInitialParameters:name andWithTag:tag];
        self.image=[UIImage imageNamed:@"inventory-outline.png"];
        self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];

        

        //Removing tap gesture for color on arrows for time being
        //if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
        if([self.name isEqualToString:@"information-flow"] || [self.name isEqualToString:@"push-symbols"] || [self.name isEqualToString:@"information-flow-2"])
        {
            //[self removeTapGesture];
        }
    }

    return self;
    
}
-(void)removeTapGesture
{
    for(UIGestureRecognizer *gesture in [self gestureRecognizers])
    {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            UITapGestureRecognizer *tapGesture=(UITapGestureRecognizer*)gesture;
            if (tapGesture.numberOfTapsRequired == 2)
            {
                [self removeGestureRecognizer:tapGesture];
            }
        }
        
    }
    
}

-(void)addTextFieldToInventorySymbol
{
        if(textField_ == nil)
            textField_=[[UITextView alloc] initWithFrame:CGRectMake(kDefaultTextViewPositionX,-kDefaultTextViewPositionY, kDefaultTextViewWidth, kDefaultTextViewHeight)];
        
        
        [textField_ setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [textField_ setBackgroundColor:[UIColor clearColor]];
        
        [textField_ setKeyboardType:UIKeyboardTypeNumberPad];
        
        
        textField_.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [textField_ setDelegate:self];
        
    
        textField_.frame=CGRectMake(5, self.frame.size.height-20, self.frame.size.width-18, 20);
    
    
        textField_.center=CGPointMake(self.frame.size.width/2,self.frame.size.height/2+37);
    
        [self addSubview:textField_];
    
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
    
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.textField withSymbolView:self];
    
    //the following function moves the detail View upward when the keyboard appears
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
    
}

#pragma mark - UITextView delegate Methods
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveSymbolState];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //[textField resignFirstResponder];
    
    [self registerKeyboardChangeNotifications];
    
}
#pragma mark - Gesture Methods
-(void)scaleSymbol:(id)sender
{
    if((self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9) && !self.isRotating )
    {
   
        
        if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
            self.lastScale = 1.0;
            
            NSLog(@"Save----");
            [self saveSymbolState];
        }
        else
        {
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
        
  
    
     
    CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    
    CGFloat currentScale = [[[sender view].layer valueForKeyPath:@"transform.scale.x"] floatValue];
    
        if(!self.oldScale)
        self.oldScale=currentScale;
    
    
        scale = MIN(scale, 50 / currentScale);
        scale = MAX(scale, kMinScale / currentScale);
    
    
    //for Afro Image
    
    CGAffineTransform currentTransform = self.transform;
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, self.oldScale);
    [self setTransform:newTransform];
            NSLog(@"transform -> %@",NSStringFromCGAffineTransform(self.transform));
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    }
     
    }
    
    else
    {
        [super scaleSymbol:sender];
    }
        
        
    
}

    /*
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MyCacheUpdatedNotification" object:self];
    UIPanGestureRecognizer *recognizer=(UIPanGestureRecognizer*)sender;
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    
    [tmpView bringSubviewToFront:self];
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    CGPoint currentCenter =self.center;//CGPointMake(self.frame.origin.x,self.frame.origin.y);
    
    CGFloat maxX = tmpView.frame.size.width;
    
    //following lines helps find the Left Edge position of the current symbol
    CGFloat leftEdgeOfSymbolX=CGRectGetMinX(self.frame);
    //following Lines helps find the Right Edge position of the current symbol
    CGFloat bottomEdgeSymbolX=CGRectGetMaxX(self.frame);
    
    CGFloat maxY = tmpView.frame.size.height;
    //following lines helps find the Left Edge position of the current symbol
    CGFloat topEdgePositionY=CGRectGetMinY(self.frame);
    //following lines gets the bottom edge of the Current symbol
    CGFloat bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol;
    
    
    if(self.isFirstTouchOnSymbol == NO)
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
    self.center = currentCenter;
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
*/



#pragma mark - Alert View Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        [self removeTheReferenceOfMaterialSymbolFromArrowSymbol];
    }
    
    else if ([title isEqualToString:@"Ok"])
    {
        [self removeTheReferenceOfMaterialSymbolFromArrowSymbol];

    }
}

#pragma mark - Custom Method
//the following method removes the refernce of the current Material Symbol from the arrow Symbol to which it was added in the first place
-(void)removeTheReferenceOfMaterialSymbolFromArrowSymbol
{
    BOOL wasInventorySymbolFound=NO;
    
    //Handling the case, where the current material symbol was added automatically
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    //The following loop finds the Push Symbol which has the refernce of the Current Material Symbol
    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSPushArrowSymbol class]])
        {
            VSPushArrowSymbol *pushArrowSymobl=(VSPushArrowSymbol*)tmpView;
            if(pushArrowSymobl.inventoryObjectReference == self)
            {
                [self longPress:nil];
                [self removeFromSuperview];
                pushArrowSymobl.inventoryObjectReference=nil;
                wasInventorySymbolFound=YES;
            }
        }
    }
    }
    
    //Handling the case where it was added manually from drag and drop
    if(!wasInventorySymbolFound)
    {
        [self longPress:nil];
        [self removeFromSuperview];
    }
    
   
}

-(void)longPress:(id)sender
{
    
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kMaterialKey];
  //  [self removeFromSuperview];
    
}

-(NSMutableDictionary*) getAppStateDictionary
{
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    symbolDictionary = [super getAppStateDictionary:symbolDictionary];
    if(self.textField !=nil)
    {
        [symbolDictionary setObject:self.textField.text forKey:kTextField1];
    }
    return [symbolDictionary autorelease];
    
    
}

-(void) saveSymbolState
{
    NSMutableDictionary *state = [self getAppStateDictionary];
    
    [DataManager setSymbolDictionary:state andType:kMaterialKey andTag:self.tagSymbol];
}
-(void)dealloc
{
    [textField_ release];
    [super dealloc];

}
@end
