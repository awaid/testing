//
//  VSInfoSymbol.m
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import "VSInfoSymbol.h"
#import "VSDataManager.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#define kOffsetBottomEdgeSymbol 230
#define kMinPlacementOffsetY 20
#define kProcessTextFieldWidth 120
#define kProcessTextFieldHeight 10
#define kProcessTextFieldOriginY 10
#define kProcessTextFieldOriginX 10
#import "VSDrawingManager.h"
#import "VSProcessSymbol.h"
#import "VSPushArrowSymbol.h"
#import "VSUIManager.h"

@implementation VSInfoSymbol
@synthesize arrayOfAttachedProcessBoxes=arrayOfAttachedProcessBoxes_;
@synthesize referenceOfCustomerSymbol=referenceOfCustomerSymbol_;
@synthesize referenceOfSupplierSymbol=referenceOfSupplierSymbol_;
@synthesize textField1=textField1_;
@synthesize textField2=textField2_;

BOOL isStillFirstSymbol = NO;
-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID
{
    if (self = [super init]) {
        self.ID = metaID;
        [self settingInitialParameters:name andWithTag:tag];
        
        self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
        
        //Only for production Control Symbol
        if(self.ID.integerValue == 14)
        {
        textField1_=[[UITextField alloc] initWithFrame:CGRectMake(self.frame.origin.x+kProcessTextFieldOriginX, self.frame.origin.y+kProcessTextFieldOriginY, kProcessTextFieldWidth, kProcessTextFieldHeight+10)];
        textField1_.keyboardType=UIKeyboardTypeDefault;
        textField1_.keyboardAppearance=UIKeyboardAppearanceAlert;
        textField1_.font=[UIFont systemFontOfSize:10];
        
        textField1_.text=@"Production Control";
        
        [textField1_ setDelegate:self];
        
        [textField1_ setBackgroundColor:[UIColor clearColor]];
        
        [textField1_ setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [self addSubview:textField1_];
        }
    }
    
    return self;
}


#pragma mark - Move Method
-(void) moveSymbol:(id)sender
{
    
    if(self.ID.integerValue == 14)
    {
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
        
        CGFloat bottomEdgePostionY;
        //following lines gets the bottom edge of the Current symbol
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
            bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol;
        
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
            bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol-180;
        
        
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
        
        
        if(recognizer.state == UIGestureRecognizerStateEnded || self.isFirstTouchOnSymbol == YES)
        {
            if(self.isFirstTouchOnSymbol == YES)
            {
                self.isFirstTouchOnSymbol = NO;
                
                isStillFirstSymbol = YES;

                //temporary
                
                    if (leftEdgeOfSymbolX < 0 || bottomEdgeSymbolX  >= maxX
                        ||topEdgePositionY < -kMinPlacementOffsetY  || bottomEdgePostionY >= maxY )
                    {
                        [self alertForWrongSymbolPosition];
                        self.isRemoved=YES;
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
            
        }
    
    if((recognizer.state == UIGestureRecognizerStateEnded && self.ID.integerValue == 14) ||isStillFirstSymbol == YES)
    {
        isStillFirstSymbol = NO;
        if([self.outgoingArrows count] != 0)
        {
            [[VSDrawingManager sharedDrawingManager] adjustOutGoingArrowsConnectedToSymbolView:self];// [self adjustOutGoingArrowsConnectedToSymbol];
            
        }
        
        if([self.incomingArrows count] != 0)
        {
            [[VSDrawingManager sharedDrawingManager] adjustIncomingArrowsConnectedToSymbolView:self];// [self adjustOutGoingArrowsConnectedToSymbol];

        }
        
    
           NSLog(@"Production value : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"]);
      //Incase where its added for the First Time,Draw out arrows to all existing Process Box
        if([VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference == nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"NO"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"] && !self.isRemoved)
        {
        
            VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

            [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=self;
            
            for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
            {
                if([tmpView isKindOfClass:[VSProcessSymbol class]])
                {
                    VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
                    if(processSymbol.ID.integerValue != 1 && processSymbol.ID.integerValue != 43 && processSymbol.ID.integerValue != 4)
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)tmpView andSymbolView:self withType:@"information-flow" andCustomerSupplierSymbol:YES];
                }
                
            }
            
            //Adding Arrows to Customer Symbol and Production control
            if([VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)
            {
             [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:self andSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
                
            }
            
            //Adding Arrows to Supplier Symbol and Production control
            if([VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference)
            {
                [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference  andSymbolView:self withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
            }
            
     

            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isProductionControlAdded"];
    
        }
        
    }
        
        
    }//Check for Production Control Ends here
    
    else
    {
        [super moveSymbol:sender];
    }
    
}

-(void)longPress:(id)sender
{
    
    //Removing all the Outgoing Arrows associated with current Symbol
    for(UIView *arrowView in self.outgoingArrows)
    {
        [arrowView removeFromSuperview];

    }
    
    //Removing all the Incoming Arrows associated with current Symbol
    for(UIView *arrowView in self.incomingArrows)
    {
        [arrowView removeFromSuperview];

    }
    
    [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
    
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kInfoKey];
     [self removeFromSuperview];
    NSLog(@"here");
}


#pragma mark - Keyboard Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}
-(void)textFieldDidEndEditing:(UITextView *)textView
{
    NSLog(@"end editing");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveSymbolState];

}
-(void)textFieldDidBeginEditing:(UITextView *)textView{
    //[textField resignFirstResponder];
    
    [self registerKeyboardChangeNotifications];
    
}

#pragma mark - Keyboard Notfication Methods
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    [[VSUIManager sharedUIManager] moveDetailViewUpOnEnteringTextInView:self.textField1 withSymbolView:self];
    
    //the following function moves the detail View upward when the keyboard appears
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [[VSUIManager sharedUIManager] moveDetailViewDownEnteringTextInView:self];
    
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
    
    if([VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference == self)
    {
        [state setObject:kIsFirstProduction forKey:kIsFirstProduction];
    }
    
    if(self.textField1 !=nil)
    {
        [state setObject:self.textField1.text forKey:kTextField1];
    }
    
    if(self.textField2 != nil)
    {
        [state setObject:self.textField2.text forKey:kTextField2];
    }
    
    
    
    
    [DataManager setSymbolDictionary:state andType:kInfoKey andTag:self.tagSymbol];
}

@end
