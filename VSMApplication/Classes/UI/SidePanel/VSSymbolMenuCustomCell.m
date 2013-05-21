//
//  VSSymbolMenuCustomCell.m
//  VSMAPP
//
//  Created by Apple  on 15/03/2013.
//
//

#import "VSSymbolMenuCustomCell.h"
//temp
#import "VSProcessSymbol.h"
#import "VSDrawingManager.h"
#import "DetailViewController.h"
#import "VSMAPPAppDelegate.h"
#import "VSUtilities.h"
#import "VSDataBoxViewController.h"
#import "VSDataManager.h"
#import "VSSymbols.h"
#import "VSMaterialSymbol.h"
#import "VSExtendedSymbol.h"
#import "VSInfoSymbol.h"
#import "VSGeneralSymbol.h"
#import <QuartzCore/QuartzCore.h>


#import "VSDataBoxViewController.h"
#import "OBDragDropManager.h"


@interface VSSymbolMenuCustomCell()
{
    CGPoint originalPointForSymbol;

}


@end

@implementation VSSymbolMenuCustomCell

@synthesize buttonLeftSymbol = buttonLeftSymbol_;
@synthesize buttonRightSymbol = buttonRightSymbol_;
@synthesize symbols = symbols_;

BOOL isRightButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"VSSymbolMenuCustomCell" owner:self options:nil] objectAtIndex:0];


        isRightButton = NO;
        
    }
    return self;
}

-(void) setGestureMethodsForButtons
{
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
//    longPress.delegate = self;
//    [self.buttonLeftSymbol addGestureRecognizer:longPress];
//    
//    
//    UILongPressGestureRecognizer *longPressRight = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonTapped:)] autorelease];
//    longPressRight.delegate = self;
//    
//    [self.buttonRightSymbol addGestureRecognizer:longPressRight];
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    ((UIView*)appDelegate.detailViewController.view).dropZoneHandler = self;
    
    
     OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    
    UILongPressGestureRecognizer *dragDropRecognizerRight = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    [self.buttonRightSymbol addGestureRecognizer:dragDropRecognizerRight];
    
    UILongPressGestureRecognizer *dragDropRecognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    
    [self.buttonLeftSymbol addGestureRecognizer:dragDropRecognizer];

}

//-(void) leftButtonTapped:(UIGestureRecognizer*) gestureRecognizer
//{
//    [self buttonTouched:self.buttonLeftSymbol];
//    [gestureRecognizer addTarget:self action:@selector(longGestureAction:)];
//}
//
//#pragma mark - Gesture Recogniser
//
//
//-(void) rightButtonTapped:(id) sender
//{
//     [self buttonTouched:self.buttonRightSymbol];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
//    
// 
//    UIView *hitView = [super hitTest:point withEvent:event];
//    
//    if([hitView isKindOfClass:[UIButton class]])
//    {
//        if(self.symbols == nil)
//        {
//
//            if(appDelegate.detailViewController.zoomingScrollViewSlider.value == 1.0)
//            {
//
//            
////            if([self.buttonRightSymbol pointInside:point withEvent:event]) {
////                
////                [self buttonTouched:self.buttonRightSymbol];
////                
////            }
//            
//            
//            
//            //if ([self.buttonLeftSymbol pointInside:point withEvent:event])
//                if ( CGRectContainsPoint( self.buttonLeftSymbol.frame, point ) ){
//                
//                    [self buttonTouched:self.buttonLeftSymbol];
//                
//                }
//                
//                else if ( CGRectContainsPoint( self.buttonRightSymbol.frame, point ) ) {
//                    // inside
//                    [self buttonTouched:self.buttonRightSymbol];
//                }
//            
//            }//IF Ends here
//            
//            else
//            {
//                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
//                                                                  message:@"You can only drop symbols when Drawing pad is zoomed out to default level."
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"No"
//                                                        otherButtonTitles: nil];
//                [message show];
//                [message release];
//            }//ELSE ends here
//            
//        }
//        
// 
//
//           
//
//        
//    }
//
//    
//
//    
//    return self.symbols;
//}



- (UIView*)getSymbolView {
    
    // Get the subviews of the view
    NSArray *subviews = [[[[UIApplication sharedApplication] windows]objectAtIndex:0] subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return nil;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        
        if([subview isKindOfClass:[VSSymbols class]])
        {
            return subview;
        }
        

    }
    
    return nil;
}

- (void) buttonTouched:(UIButton*) button
{
    
    if(button.imageView.image == nil)
    {
        return;
    }
    
    NSString *type = [DataManager getTypeBasedOnID:button.tag];
    
    NSDictionary *symbolInfo = [DataManager getDictionaryBasedOnID:button.tag];
    
    NSString *name = [symbolInfo objectForKey:@"name"];
    NSNumber *ID = [symbolInfo objectForKey:@"id"];
    
    int symbolID=[[symbolInfo objectForKey:@"id"] integerValue];
    
    VSSymbols *symbol;
    
    /*
    //For DataBox View Controller
    if(ID.integerValue == 4)
    {
        VSDataBoxViewController *dataBoxViewController=[[VSDataBoxViewController alloc] initWithNibName:@"VSDataBoxViewController" bundle:nil];
        
        VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        dataBoxViewController.ID=ID;
        
        [appDelegate.detailViewController.view addSubview:(UIView*)dataBoxViewController.view];
        
        
        originalPointForSymbol =   [button convertPoint:button.frame.origin toView:appDelegate.detailViewController.view];
        
        if(CGPointEqualToPoint(self.buttonRightSymbol.frame.origin,button.frame.origin))
        {
            originalPointForSymbol.x = originalPointForSymbol.x - 140;
        }
    
        dataBoxViewController.isFristTouchSymbol=YES;
        [dataBoxViewController.view setUserInteractionEnabled:YES];
         [dataBoxViewController.view setFrame:CGRectMake(originalPointForSymbol.x,originalPointForSymbol.y, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
        [dataBoxViewController addMoveAndScaleGestures];
        
        [self performSelector:@selector(checkSymbolBounds) withObject:nil afterDelay:1];

    }
    
    //For all Other Symbols
    else
    {
*/
    if([type isEqualToString:kMaterialKey])
    {
        
        symbol = [[VSDrawingManager sharedDrawingManager] createMaterialSymbolWithName:name andID:ID];

        //This indicates that it was an Inventory symbol
        if(symbolID == 6)
        {
            VSMaterialSymbol *materialSymbol=(VSMaterialSymbol*)symbol;
            [materialSymbol addTextFieldToInventorySymbol];
        }
        
        

    }
    
    else if([type isEqualToString:kExtendedKey])
    {
        symbol = [[VSDrawingManager sharedDrawingManager] createExtendedSymbolWithName:name andID:ID];
    }
    
    else if([type isEqualToString:kProcessKey])
    {
 
        symbol = [[VSDrawingManager sharedDrawingManager] createProcessSymbolWithName:name andID:ID];
        ((VSProcessSymbol*)symbol).dataBoxController.view.alpha = 0.0f;

    }
    
    else if([type isEqualToString:kInfoKey])
    {
        symbol = [[VSDrawingManager sharedDrawingManager] createInformationSymbolWithName:name andID:ID];
    }
    
    else if([type isEqualToString:kGeneralKey])
    {
        symbol = [[VSDrawingManager sharedDrawingManager] createGeneralSymbolWithName:name andID:ID];
    }
    
    else
    {
        
    }
    



    //Incase DataBox is added, the image is made NULL since DataBox is a View Controller
//    if(ID.integerValue == 4)
//    {
//        //symbol.image=nil;
//    }
//    
//    else
//    {
    symbol.image =  button.imageView.image;
  //  }
    
    symbol.alpha=1.0;
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    //[appDelegate.detailViewController.view addSubview:symbol];
    
    originalPointForSymbol =   [button convertPoint:button.frame.origin toView:appDelegate.detailViewController.detailItem];

    if(CGPointEqualToPoint(self.buttonRightSymbol.frame.origin,button.frame.origin))
    {
        originalPointForSymbol.x = originalPointForSymbol.x - 140;
    }
    

    
    
     if(symbol.ID.integerValue == 14)
    {
        [symbol setFrame:CGRectMake(originalPointForSymbol.x,originalPointForSymbol.y, kWidthOfProcessSymbol+50, kHeightOfProcessSymbol)];
    }
    
     if(symbol.ID.integerValue != 14)
    {
        [symbol setFrame:CGRectMake(originalPointForSymbol.x,originalPointForSymbol.y, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
    }
    
    
     if(symbol.ID.integerValue == 8) //|| symbol.ID.integerValue == 8 || symbol.ID.integerValue == 9)
    {
    [symbol setFrame:CGRectMake(originalPointForSymbol.x,originalPointForSymbol.y, kWidthOfProcessSymbol, 50)];
    }
  

    self.symbols = symbol;
    
    [self performSelector:@selector(checkSymbolBounds) withObject:nil afterDelay:1];
        
    

    
}
- (void)checkSymbolBounds
{
    if(self.symbols.frame.origin.x == originalPointForSymbol.x && self.symbols.frame.origin.y ==  originalPointForSymbol.y)
    {
        [self.symbols removeCompleteSymbol];
        //self.symbols = nil;
    }
}


-(void) setCellSymbolsWithFirstSymbol:(NSDictionary*) symbol1 andSecondSymbol:(NSDictionary*) symbol2
{

    [self.buttonLeftSymbol setImage:[UIImage imageNamed:[symbol1 objectForKey:@"path"]] forState:UIControlStateNormal];
    self.buttonLeftSymbol.tag = [[symbol1 objectForKey:@"id"] doubleValue];
    self.leftLabel.text=[NSString stringWithFormat:@"%@",[symbol1 objectForKey:@"generic-name"]];
    
    if(symbol2 != nil)
    {
        [self.buttonRightSymbol setImage:[UIImage imageNamed:[symbol2 objectForKey:@"path"]] forState:UIControlStateNormal];
        self.buttonRightSymbol.tag = [[symbol2 objectForKey:@"id"] doubleValue];
        self.rightLabel.text=[NSString stringWithFormat:@"%@",[symbol2 objectForKey:@"generic-name"]];
    }
    
    else if(symbol2 == nil)
    {
        //self.buttonRightSymbol = nil;
        self.rightLabel.text=nil;
        //self.leftLabel.text=nil;
    }
    
    self.symbols = nil;
}

- (IBAction)buttonRightPressed:(UIButton *)sender {
    [self buttonTouched:sender];
}


#pragma mark - OBOvumSource

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
    if(isRightButton == YES)
    {
        [self buttonTouched:self.buttonRightSymbol];
    }
    
    else
    {
        [self buttonTouched:self.buttonLeftSymbol];
    }
    
    OBOvum *ovum = [[[OBOvum alloc] init] autorelease];
    ovum.dataObject = [NSNumber numberWithInteger:self.symbols.tag];
    return ovum;
}


-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
    
    return self.symbols;
}


-(void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
    dragView.transform = CGAffineTransformIdentity;
    dragView.alpha = 0.0;
    
    //[UIView animateWithDuration:0.25 animations:^{
        dragView.center = location;
        //dragView.transform = CGAffineTransformMakeScale(0.80, 0.80);
        dragView.alpha = 0.75;
    //}];
}



#pragma mark - OBDropZone

static NSInteger kLabelTag = 2323;

-(OBDropAction) ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
  //  NSLog(@"Ovum<0x%x> %@ Entered", (int)ovum, ovum.dataObject);

    
//    CGRect labelFrame = CGRectMake(ovum.dragView.bounds.origin.x, ovum.dragView.bounds.origin.y, ovum.dragView.bounds.size.width, ovum.dragView.bounds.size.height / 2);
//    UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
//    label.text = @"Ovum entered";
//    label.tag = kLabelTag;
//    label.backgroundColor = [UIColor clearColor];
//    label.opaque = NO;
//    label.font = [UIFont boldSystemFontOfSize:24.0];
//    label.textAlignment = UITextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    [ovum.dragView addSubview:label];
    
    return OBDropActionMove;
}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    //  NSLog(@"Ovum<0x%x> %@ Moved", (int)ovum, ovum.dataObject);
    
    //CGFloat hiphopopotamus = 0.33 + 0.66 * location.y / self.view.frame.size.height;
    
//    // This tester currently only supports dragging from left to right view
//    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
//    {
//        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
//        if ([rightViewContents containsObject:itemView])
//        {
//            view.layer.borderColor = [UIColor colorWithRed:hiphopopotamus green:0.0 blue:0.0 alpha:1.0].CGColor;
//            view.layer.borderWidth = 5.0;
//            
//            UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
//            label.text = @"Cannot Drop Here";
//            
//            return OBDropActionNone;
//        }
//    }
//    

    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    label.text = [NSString stringWithFormat:@"Ovum at %@", NSStringFromCGPoint(location)];
    
    return OBDropActionMove;
}

-(void) ovumExited:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
   // NSLog(@"Ovum<0x%x> %@ Exited", (int)ovum, ovum.dataObject);
    
    //view.layer.borderColor = [UIColor clearColor].CGColor;
    //view.layer.borderWidth = 0.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    [label removeFromSuperview];
}

-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
  //  NSLog(@"Ovum<0x%x> %@ Dropped", (int)ovum, ovum.dataObject);
    
    //view.layer.borderColor = [UIColor clearColor].CGColor;
    //view.layer.borderWidth = 0.0;
    
    //UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    //[label removeFromSuperview];
    
//    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
//    {
//        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
//        if (itemView)
//        {
//            [itemView retain];
//            [itemView removeFromSuperview];
//            [leftViewContents removeObject:itemView];
//            
//            NSInteger insertionIndex = [self insertionIndexForLocation:location withContents:rightViewContents];
//            [rightView insertSubview:itemView atIndex:insertionIndex];
//            [rightViewContents insertObject:itemView atIndex:insertionIndex];
//            
//            [itemView release];
//        }
//    }
//    else if ([ovum.dataObject isKindOfClass:[UIColor class]])
//    {
//        // An item from AdditionalSourcesViewController
//        UIView *itemView = [self createItemView];
//        itemView.backgroundColor = ovum.dataObject;
//        NSInteger insertionIndex = rightViewContents.count;
//        [rightView insertSubview:itemView atIndex:insertionIndex];
//        [rightViewContents insertObject:itemView atIndex:insertionIndex];
//    }
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
   
    
   // [appDelegate.detailViewController.detailItem addSubview:ovum.dragView];
    
}

-(void) adjustViewsOnSymbolFirstDragAndDropWithView:(VSSymbols*) symbols
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CGPoint newPoint =   [appDelegate.detailViewController.view convertPoint:symbols.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [symbols removeFromSuperview];
    
    symbols.frame=CGRectMake(newPoint.x-130,newPoint.y-128 ,symbols.frame.size.width,symbols.frame.size.height);
    
    symbols.alpha = 1.0f;
    [appDelegate.detailViewController.detailItem addSubview:symbols];

    symbols.isFirstTouchOnSymbol = YES;
    
    [symbols moveSymbol:nil];
    [symbols moveSymbol:nil];
    
    //[symbols saveSymbolState];

    
    
    
    
}
-(void) handleDropAnimationForOvum:(OBOvum*)ovum withDragView:(UIView*)dragView dragDropManager:(OBDragDropManager*)dragDropManager
{
    
    [self adjustViewsOnSymbolFirstDragAndDropWithView:(VSSymbols*)ovum.dragView];
    
    
    
    
//    UIView *itemView = nil;
//    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
//        itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
//    else if ([ovum.dataObject isKindOfClass:[UIColor class]])
//        itemView = [rightViewContents lastObject];
//    
//    if (itemView)
//    {
//        // Set the initial position of the view to match that of the drag view
//        CGRect dragViewFrameInTargetWindow = [ovum.dragView.window convertRect:dragView.frame toWindow:rightView.window];
//        dragViewFrameInTargetWindow = [rightView convertRect:dragViewFrameInTargetWindow fromView:rightView.window];
//        itemView.frame = dragViewFrameInTargetWindow;
//        
//        CGRect viewFrame = [ovum.dragView.window convertRect:itemView.frame fromView:itemView.superview];
//        
//        void (^animation)() = ^{
//            dragView.frame = viewFrame;
//            
//            [self layoutScrollView:leftView withContents:leftViewContents];
//            [self layoutScrollView:rightView withContents:rightViewContents];
//        };
//        
//        [dragDropManager animateOvumDrop:ovum withAnimation:animation completion:nil];
//    }
}
- (IBAction)buttonRightTapped:(UIButton *)sender {
    isRightButton = YES;
}
- (IBAction)buttonLeftTapped:(UIButton *)sender {
    isRightButton = NO;
}

- (void)dealloc {
    [buttonLeftSymbol_ release];
    [buttonRightSymbol_ release];
    [super dealloc];
}
@end
