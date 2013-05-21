//
//  VSUIManager.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/29/13.
//
//

#import "VSUIManager.h"
#import "VSSymbolTextInputViewController.h"
#import "VSMAPPAppDelegate.h"
#import "VSUtilities.h"
#import "DetailViewController.h"
#import "VSColorPickerViewController.h"
#import "VSSymbols.h"
#import "VSDataRowViewController.h"
#import "VSDataBoxViewController.h"
#import "VSProcessSymbol.h"
#import "VSPushArrowSymbol.h"
#import "VSMaterialSymbol.h"
#define kDefaultDetailViewPositionX 5
#define kDefaultDetailViewPositionY 44
#define kMaxBottomEdgePositionY  540
#define kMiddleBottomEdgePositionY 371
#define kMinBottomEdgePositionY 146
#define kOffsetDettailViewFirstPositionY 350
#define kOffsetDettailViewSecondPositionY 200
#define kOffsetSymbolPositionY 110
#define kDefaultColorPickerWidth 174
#define kDefaultColorPickerHeight 409

@interface VSUIManager()
{
    UIView *greyBackgroundView_;
    VSSymbolTextInputViewController *controller_;
    UIPopoverController *popOverController_;
    VSColorPickerViewController *colorPickerController_;
    CGPoint previousLocationOfSymbolView_;
    VSSymbols * symbolView_;
    VSDataBoxViewController *dataBoxRowViewController_;
}
@property (retain, nonatomic) UIView *greyBackgroundView;
@property (retain, nonatomic) VSSymbolTextInputViewController *controller;
@property (retain, nonatomic) UIPopoverController *popOverController;
@property (retain, nonatomic) VSColorPickerViewController *colorPickerController;
@property (readwrite, nonatomic) CGPoint previousLocationOfSymbolView;
@property (retain, nonatomic) VSSymbols * symbolView;
@property (retain, nonatomic) VSDataBoxViewController *dataBoxRowViewController;
@end
@implementation VSUIManager


static VSUIManager * _sharedUIManager_ = nil;
@synthesize greyBackgroundView=greyBackgroundView_;
@synthesize controller=controller_;
@synthesize popOverController=popOverController_;
@synthesize colorPickerController=colorPickerController_;
@synthesize previousLocationOfSymbolView=previousLocationOfSymbolView_;
@synthesize symbolView=symbolView_;
@synthesize dataBoxRowViewController=dataBoxRowViewController_;

+(VSUIManager*) sharedUIManager
{
    if(!_sharedUIManager_)
    {
        _sharedUIManager_ = [[VSUIManager alloc] init];
    }
    return _sharedUIManager_;
}

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    _sharedUIManager_ = self;
    return self;
}
-(void)dealloc
{
    [controller_ release];
    [popOverController_ release];
    [colorPickerController_ release];
    [super dealloc];
}
-(void)showSymbolNumberInputViewWithText:(NSString*)string;
{

    self.controller=nil;
    controller_=[[VSSymbolTextInputViewController alloc] initWithNibName:@"VSSymbolTextInputViewController" bundle:nil];
    
    controller_.headingText=@"Enter Number";
    controller_.inputText=string;
    controller_.isNumPad=YES;
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    
    self.greyBackgroundView=[VSUtilities addGreyBackgroundViewToWindow];
    [frontWindow addSubview:controller_.view];
    
    //following function adds Greys background to the backdrop along with animation
    [VSUtilities addAndAnimateGreyBackground:self.greyBackgroundView withView:controller_.view];
}

//following adds Symbol Text Input View to the main Window
-(void)showSymbolTextInputViewWithText:(NSString*)string
{

    self.controller=nil;
    controller_=[[VSSymbolTextInputViewController alloc] initWithNibName:@"VSSymbolTextInputViewController" bundle:nil];
    
    controller_.headingText=@"Enter text";
    controller_.inputText=string;
    controller_.isNumPad=NO;
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]objectAtIndex:0];

    self.greyBackgroundView=[VSUtilities addGreyBackgroundViewToWindow];
    [frontWindow addSubview:controller_.view];
    
    //following function adds Greys background to the backdrop along with animation
    [VSUtilities addAndAnimateGreyBackground:self.greyBackgroundView withView:controller_.view];
    
    
}

//Following removes Symbol Text Input View to the main Window 
-(void)removeSymbolTextInputView;
{
    [self.controller.view removeFromSuperview];
    [self.greyBackgroundView removeFromSuperview];
}

#pragma mark - Color Picker Related Methods
//the following line shows the color picker View
-(void)showColorPickerFromDataBox:(VSDataBoxViewController*)dataBoxViewController
{
    if(colorPickerController_ == nil)
        colorPickerController_=[[VSColorPickerViewController alloc] initWithNibName:@"VSColorPickerViewController" bundle:nil];
    
    if(popOverController_ == nil)
        popOverController_=[[UIPopoverController alloc] initWithContentViewController:colorPickerController_];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    [popOverController_ setPopoverContentSize:CGSizeMake(kDefaultColorPickerWidth, kDefaultColorPickerHeight)];
    
    [popOverController_ presentPopoverFromRect:dataBoxViewController.view.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [VSUIManager sharedUIManager].dataBoxRowViewController=dataBoxViewController;
    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            if([tmpView isKindOfClass:[VSProcessSymbol class]])
            {
                    VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
                    if(processSymbol.dataBoxController == dataBoxViewController)
                {
                    [VSUIManager sharedUIManager].symbolView=processSymbol;
                }
            }
        }
    
    
}
-(void)showColorPickerViewFromView:(UIView*)view
{
    if(colorPickerController_ == nil)
        colorPickerController_=[[VSColorPickerViewController alloc] initWithNibName:@"VSColorPickerViewController" bundle:nil];
    
    if(popOverController_ == nil)
        popOverController_=[[UIPopoverController alloc] initWithContentViewController:colorPickerController_];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *tmpView=(UIView*)appDelegate.detailViewController.detailItem;
    [popOverController_ setPopoverContentSize:CGSizeMake(kDefaultColorPickerWidth, kDefaultColorPickerHeight)];
    
    [popOverController_ presentPopoverFromRect:view.frame inView:tmpView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    [VSUIManager sharedUIManager].symbolView=(VSSymbols*)view;
        [VSUIManager sharedUIManager].dataBoxRowViewController=nil;
   
}

//following function removes the color picker pop over controller
-(void)closeColorPickerPopOverWithIndex:(int)index
{
    if(popOverController_ != nil)
    {
        [popOverController_ dismissPopoverAnimated:YES];
    }
    
    
    //Only valide incase where the Current Symbol is not a databox
    if([VSUIManager sharedUIManager].symbolView != nil && [VSUIManager sharedUIManager].dataBoxRowViewController == nil)
    {
        [VSUIManager sharedUIManager].symbolView.image=nil;

    if(index == 1)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-darkblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-darkblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-darkblue.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-darkblue.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 2)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-green-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-green-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-green.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-green.png",[VSUIManager sharedUIManager].symbolView.name];
            
        }
    }
    
    if(index == 3)
    {
        
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightblue.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightblue.png",[VSUIManager sharedUIManager].symbolView.name];
            
        }
        
    }
    
    if(index == 4)
    {
        
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightblue-a-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightblue-a-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightblue-a.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightblue-a.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 5)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightgreen-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightgreen-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightgreen.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightgreen.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 6)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightorange-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightorange-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightorange.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightorange.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 7)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])\
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightpurple-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightpurple-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightpurple.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightpurple.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
    }
    if(index == 8)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])\
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightyellow-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightyellow-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-lightyellow.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-lightyellow.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 9)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-orange-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-orange-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-orange.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-orange.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 10)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-pink-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-pink-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
            
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-pink.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-pink.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 11)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-purple-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-purple-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-purple.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-purple.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 12)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-red-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-red-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
            
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-red.png",[VSUIManager sharedUIManager].symbolView.name]];
    
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-red.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 13)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-royalblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-royalblue-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-royalblue.png",[VSUIManager sharedUIManager].symbolView.name]];
        
        //Setting the name of the Symbol View
       [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-royalblue.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 14)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-yellow-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-yellow-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-yellow.png",[VSUIManager sharedUIManager].symbolView.name]];
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-yellow.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 15)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-outline-rotated.png",[VSUIManager sharedUIManager].symbolView.name]];
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-outline-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-outline.png",[VSUIManager sharedUIManager].symbolView.name]];
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    
    if(index == 16)
    {
        if([[VSUIManager sharedUIManager].symbolView.name isEqualToString:@"information-flow-2"])
        {
            [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-default-rotated",[VSUIManager sharedUIManager].symbolView.name]];
            //Setting the name of the Symbol View
            [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-default-rotated.png",[VSUIManager sharedUIManager].symbolView.name];
        }
        
        else
        {
        
        [VSUIManager sharedUIManager].symbolView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-default",[VSUIManager sharedUIManager].symbolView.name]];
        //Setting the name of the Symbol View
        [VSUIManager sharedUIManager].symbolView.imageColorFileName=[NSString stringWithFormat:@"%@-default.png",[VSUIManager sharedUIManager].symbolView.name];
        }
    }
    NSLog(@"Image name %@",[VSUIManager sharedUIManager].symbolView.name);
        [[VSUIManager sharedUIManager].symbolView saveSymbolState];
        
    }
    
    else
    {
        [self changeColorOnDataBoxWithIndex:index];
        [(VSDataBoxViewController*)[VSUIManager sharedUIManager].dataBoxRowViewController saveDataBox];
    }
    
    VSPushArrowSymbol *pushArrowSymbol;
    if([[VSUIManager sharedUIManager].symbolView isKindOfClass:[VSPushArrowSymbol class]])
    {
        pushArrowSymbol=(VSPushArrowSymbol*)[VSUIManager sharedUIManager].symbolView;
        [pushArrowSymbol.inventoryObjectReference saveSymbolState];
         [self savePushArrowSymbolForTag:pushArrowSymbol.tagSymbol];
    }
    else{
        
    [[VSUIManager sharedUIManager].symbolView saveSymbolState];
    }
    
   
}

-(void) savePushArrowSymbolForTag:(NSString*)tag
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSArray *subviews = [appDelegate.detailViewController.detailItem subviews];
    
    NSString *tagSymbolFromView;
    
    NSArray *array;
    
    //NSDictionary *metaData;
    
    VSPushArrowSymbol *tempPush;
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        if([subview isKindOfClass:[VSSymbols class]])
        {
            tagSymbolFromView = ((VSSymbols*)subview).tagSymbol;
            
            array = ((VSSymbols*)subview).outgoingArrows;
            
            for(tempPush in array)
            {
                if([tempPush.tagSymbol isEqualToString:tag])
                {
                    [((VSSymbols*)subview) saveSymbolState];
                    //return;
                }
            }
            
            array = ((VSSymbols*)subview).incomingArrows;
            
            for(tempPush in array)
            {
                if([tempPush.tagSymbol isEqualToString:tag])
                {
                    [((VSSymbols*)subview) saveSymbolState];
                    //return;
                }
            }
            
            
            
            
            
//            if([tagSymbolFromView isEqualToString:tag])
//            {
//                //return (VSSymbols*)subview;
//            }
        }
        
    }
}

- (VSSymbols*)getSymbolViewWithTag:(NSString*) tag{
    
    // Get the subviews of the view
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSArray *subviews = [appDelegate.detailViewController.detailItem subviews];
    
    NSString *tagSymbolFromView;
    
    //NSDictionary *metaData;
    
    // Return if there are no subviews
    if ([subviews count] == 0) return nil;
    
    for (UIView *subview in subviews) {
             
        if([subview isKindOfClass:[VSSymbols class]])
        {
            tagSymbolFromView = ((VSSymbols*)subview).tagSymbol;
            
            if([tagSymbolFromView isEqualToString:tag])
            {
                return (VSSymbols*)subview;
            }
        }
        
    }
    
    return nil;
}

-(void)changeColorOfDatabox:(VSDataBoxViewController*)databox withColor:(NSString*)colorName
{
    
    //Changing the color of the "Add Data Box button"
    [databox.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"data-box-bottom%@",colorName]] forState:UIControlStateNormal];
    
    [VSUIManager sharedUIManager].symbolView.dataBoxImageColorFileName=[NSString stringWithFormat:@"data-box-bottom%@",colorName];
    
    
    
    for(UIView *tmpView in [databox.viewForRows subviews])
    {
        if([tmpView isKindOfClass:[VSDataRowViewController class]])
        {
        VSDataRowViewController* rowView=(VSDataRowViewController*)tmpView;
            
        rowView.databoxBackgroundImageView.image=nil;
            //Setting the color of the Row Cell
        rowView.databoxBackgroundImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"data-box-single%@",colorName]];
            
        //Setting the color of the Add Button
       // [databox.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"data-box-bottom%@",colorName]] forState:UIControlStateNormal];
            
            
            VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

            //following FOR loop finds the Process box to which the DataBoxView Controller is attached and changes the ImageColor File name of the Process Symbol for later parsing.
            for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
            {
                if([tmpView isKindOfClass:[VSProcessSymbol class]])
                {
                    VSProcessSymbol*processSymbol=(VSProcessSymbol*)tmpView;
                    if(processSymbol.dataBoxController == [VSUIManager sharedUIManager].dataBoxRowViewController)
                    {
                       // processSymbol.imageColorFileName=[NSString stringWithFormat:@"data-box-single%@",colorName];
                        processSymbol.dataBoxImageColorFileName=[NSString stringWithFormat:@"data-box-bottom%@",colorName];
                    }
                    
                }
            }
  
        }
    }
        
}

-(void)changeColorOnDataBoxWithIndex:(int)index
{
    VSDataBoxViewController *dataBox=(VSDataBoxViewController*)[VSUIManager sharedUIManager].dataBoxRowViewController;
    
    
    if(index == 1)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-darkblue.png"];
    }
    
    if(index == 2)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-green.png"];

    }
    
    if(index == 3)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-lightblue.png"];

        
    }
    
    if(index == 4)
    {
     
        [self changeColorOfDatabox:dataBox withColor:@"-lightblue-a.png"];

    }
    
    if(index == 5)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-lightgreen.png"];

    }
    
    if(index == 6)
    {
      
        [self changeColorOfDatabox:dataBox withColor:@"-lightorange.png"];

    }
    
    if(index == 7)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-lightpurple.png"];

        
    }
    if(index == 8)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-lightyellow.png"];

    }
    
    if(index == 9)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-orange.png"];

    }
    
    if(index == 10)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-pink.png"];

    }
    
    if(index == 11)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-purple.png"];

    }
    
    if(index == 12)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-red.png"];

    }
    
    if(index == 13)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-royalblue.png"];
   
    }
    
    if(index == 14)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-yellow.png"];

    }
    
    if(index == 15)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-outline.png"];

    }
    
    if(index == 16)
    {
        [self changeColorOfDatabox:dataBox withColor:@"-default.png"];
   
    }
    NSLog(@"Image name %@",[VSUIManager sharedUIManager].symbolView.name);
    
}
#pragma mark - Symbol Views Related Methods
//the following function moves the Detail View controller up when text is entered into the Symbol View
-(void)moveDetailViewUpOnEnteringTextInView:(UIView *)textFieldView withSymbolView:(UIView *)symbolView{

    
    //Following function hides all the Symbol View except the given one
    [self hideAllSymbolViewExceptView:symbolView];
    

    float bottomEdgeOfSymbolViewPostionY=CGRectGetMinY(symbolView.frame);


    self.previousLocationOfSymbolView=CGPointMake(symbolView.center.x, symbolView.center.y);
    
    NSLog(@"Content Scale Factor %f",symbolView.frame.size.height);
    
    //if(symbolView.frame.size.height <=200)
    //{
    if(bottomEdgeOfSymbolViewPostionY > kMinBottomEdgePositionY)
    {
   
        [UIView animateWithDuration:0.5 animations:^{
            
            
            symbolView.center=CGPointMake(symbolView.center.x,  kOffsetSymbolPositionY+symbolView.frame.size.height/2);

        } completion:^(BOOL finished){}];
    
    }

}

//the following function moves the Detail View controller down when text is entered into the Symbol View
-(void)moveDetailViewDownEnteringTextInView:(UIView*)symbolView;
{
 
        [UIView animateWithDuration:1.0 animations:^{
            
            symbolView.center=CGPointMake(self.previousLocationOfSymbolView.x,self.previousLocationOfSymbolView.y);
           
        } completion:^(BOOL finished){}];
    
    [self showAllSymbolViewsInDetailView];

}

//Following Function hides all the Symbol View in detail View except the Given Symbol View
-(void)hideAllSymbolViewExceptView:(UIView*)symbolView
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *detailView=(UIView*)appDelegate.detailViewController.detailItem;
    
    for(UIView *tmpView in [detailView subviews])
    {
        //Following hides all the views except the given Symbol View
        if(tmpView != symbolView)
            [UIView animateWithDuration:0.5
            animations:^{
            tmpView.alpha=0.0;
            } completion:^(BOOL finished){
            }];
            
    }
    
}

-(void)showAllSymbolViewsInDetailView
{
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    // To get the Detail Item view on which the symbols are added upon
    UIView *detailView=(UIView*)appDelegate.detailViewController.detailItem;
    
    for(UIView *tmpView in [detailView subviews])
    {
        //Following shows all the views except the given Symbol View
        [UIView animateWithDuration:0.75
                         animations:^{
                             tmpView.alpha=1.0;
                         } completion:^(BOOL finished){
                         }];

        
    }
}
@end
