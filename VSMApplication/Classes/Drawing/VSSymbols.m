//
//  VSSymbols.m
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import "VSSymbols.h"
#import "VSMAPPAppDelegate.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "DetailViewController.h"
#import "VSUIManager.h"
#import "VSDrawingManager.h"
#define kOffsetBottomEdgeSymbol 190
#import "VSDataManager.h"
#import <QuartzCore/QuartzCore.h>
#define kMaxScale 1.2
#define kMinScale 0.3
#define kMinPlacementOffsetY 0
#define kUpperEdgeOffsetY 20
double wrapd(double _val, double _min, double _max)
{
    if(_val < _min) return _max - (_min - _val);
    if(_val > _max) return _min - (_max - _val);
    return _val;
}


@implementation VSSymbols
@synthesize ID = ID_;
@synthesize tagSymbol = tagSymbol_;
@synthesize name = name_;
@synthesize x = x_;
@synthesize y = y_;
@synthesize width = width_;
@synthesize height = height_;
@synthesize firstTouchLocationX=firstTouchLocationX_;
@synthesize firstTouchLocationY=firstTouchLocation_;
@synthesize lastRotation=lastRotation_;
@synthesize lastScale=lastScale_;
@synthesize sender = sender_;
@synthesize isShowingSymbolDeleteAlert = isShowingSymbolDeleteAlert_;;
@synthesize isFirstTouchOnSymbol = isFirstTouchOnSymbol_;
@synthesize leftNewSymbolPositionPoint=leftNewSymbolPositionPoint_;
@synthesize topNewSymbolPositionPoint=topNewSymbolPositionPoint_;
@synthesize bottomNewSymbolPositionPoint=bottomNewSymbolPositionPoint_;
@synthesize rightNewSymbolPositionPoint=rightNewSymbolPositionPoint_;
@synthesize outgoingArrows=outgoingArrows_;
@synthesize incomingArrows=incomingArrows_;
@synthesize isRemoved=isRemoved_;
@synthesize shouldBeRemoved=shouldBeRemoved_;
@synthesize connectedFromProcessSymbolID=connectedFromProcessSymbolID_;
@synthesize connectedToProcessSymbolID=connectedToProcessSymbolID_;
@synthesize imageColorFileName=imageColor_;
@synthesize genericName=genericName_;
@synthesize isRotating=isRotating_;
@synthesize dataBoxImageColorFileName=dataBoxImageColorFileName_;


- (id)initWithName:(NSString*) name withTag:(NSString*)tag{
    if (self = [super init]) {
        self.name = name;
        self.tagSymbol = tag;
        [self addGesturesMethods];
        self.isShowingSymbolDeleteAlert = NO;
        self.userInteractionEnabled = YES;
        
        if(outgoingArrows_ == nil)
            outgoingArrows_=[[NSMutableArray alloc] init];
        
        if(incomingArrows_ == nil)
            incomingArrows_=[[NSMutableArray alloc] init];
        
        self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
    }
    return self;
}

-(void)settingInitialParameters:(NSString*)name andWithTag:(NSString*)tag
{
    self.name = name;
    self.tagSymbol = tag;
    [self addGesturesMethods];
    self.isShowingSymbolDeleteAlert = NO;
    self.userInteractionEnabled = YES;
    
    if(outgoingArrows_ == nil)
        outgoingArrows_=[[NSMutableArray alloc] init];
    
    if(incomingArrows_ == nil)
        incomingArrows_=[[NSMutableArray alloc] init];
}

-(NSMutableDictionary*) getAppStateDictionary:(NSMutableDictionary*) dict
{
    //[dict setObject:self.name forKey:@"name"];
    [dict setObject:[NSNumber numberWithFloat:self.bounds.origin.x] forKey:@"x"];
    [dict setObject:[NSNumber numberWithFloat:self.bounds.origin.y] forKey:@"y"];
    [dict setObject:[NSNumber numberWithInt:self.bounds.size.height] forKey:@"H"];
    [dict setObject:[NSNumber numberWithInt:self.bounds.size.width] forKey:@"W"];
    
    if(self.imageColorFileName != nil)
    {
        [dict setObject:self.imageColorFileName forKey:kColorFileName];
    }

    if(self.name != nil)
    {
        [dict setObject:self.name forKey:kName];
    }
    [dict setObject:[NSNumber numberWithFloat:self.lastScale] forKey:@"lastScale"];

    
    if(self.ID != nil)
    {
        [dict setObject:self.ID forKey:@"ID"];
    }
    
    [dict setObject:NSStringFromCGAffineTransform(self.transform) forKey:@"T"];
    [dict setObject:NSStringFromCGPoint(self.center) forKey:@"center"];

    
    return dict;
}

-(void)addGesturesMethods
{
    self.isFirstTouchOnSymbol = YES;
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleSymbol:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateSymbol:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self addGestureRecognizer:rotationRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSymbol:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer *longGesture=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCheck:)] autorelease];
    [longGesture setDelegate:self];
    longGesture.minimumPressDuration=1.0;
    [self addGestureRecognizer:longGesture];
    
    UITapGestureRecognizer *tapGesture=[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapSymbol:)] autorelease];
    [tapGesture setDelegate:self];
    [tapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGestureForRotate=[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(singleTap:)] autorelease];
    [tapGestureForRotate setDelegate:self];
    [tapGestureForRotate setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    
}
-(void)singleTap:(id)sender
{
    
}

- (float) updateRotation:(CGPoint)_location
{
    float fromAngle = atan2(m_locationBegan.y-self.center.y, m_locationBegan.x-self.center.x);
    float toAngle = atan2(_location.y-self.center.y, _location.x-self.center.x);
    float newAngle = wrapd(m_currentAngle + (toAngle - fromAngle), 0, 2*3.14);
    
    CGAffineTransform cgaRotate = CGAffineTransformMakeRotation(newAngle);
    self.transform = cgaRotate;
    
    //int oneInFifty = (newAngle*50)/(2*3.14);

    
    return newAngle;
}
-(void) scaleSymbol:(id) sender
{
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [self saveSymbolState];
    }
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    
 
    else
    {
    CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    
    CGFloat currentScale = [[[sender view].layer valueForKeyPath:@"transform.scale"] floatValue];
    
    if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9 )
    {
        scale = MIN(scale, 50 / currentScale);
        scale = MAX(scale, kMinScale / currentScale);
    }
    else
    {
    
    scale = MIN(scale, kMaxScale / currentScale);
    scale = MAX(scale, kMinScale / currentScale);
    }
    
    //for Afro Image
    
    CGAffineTransform currentTransform = self.transform;
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self setTransform:newTransform];
    
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
        
    }
}
-(void) tapSymbol:(id)sender;
{
    NSLog(@"Tap made");
    [[VSUIManager sharedUIManager] showColorPickerViewFromView:self];
}

-(void) rotateSymbol:(id) sender
{
    /*
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {

        self.lastRotation = 0.0;
        [self saveSymbolState];
        self.isRotating=NO;

        
    }
    else
    {
    
    self.isRotating=YES;
    CGFloat rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [self setTransform:newTransform];
    
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    }*/
    
    /*
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    UIView *detailView=(UIView*)appDelegate.detailViewController.detailItem;

    UIPanGestureRecognizer *gesture=(UIPanGestureRecognizer*)sender;
    
    if ([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        // Get the location of the touch in the view we're dragging.
        CGPoint location = [gesture locationInView:appDelegate.detailViewController.detailItem];
        
        // Now to fix the rotation we set a new anchor point to where our finger touched. Remember AnchorPoints are 0.0 - 1.0 so we need to convert from points to that by dividing
        [detailView.layer setAnchorPoint:CGPointMake(location.x/detailView.frame.size.width, location.y/detailView.frame.size.height)];
        
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // Calculate Our New Angle
        CGPoint p1 = self.center;
        CGPoint p2 = detailView.center;
        
        float adjacent = p2.x-p1.x;
        float opposite = p2.y-p1.y;
        
        float angle = atan2f(adjacent, opposite);
        
        // Get the location of our touch, this time in the context of the superview.
        CGPoint location = [gesture locationInView:self];
        
        // Set the center to that exact point, We don't need complicated original point translations anymore because we have changed the anchor point.
        [detailView setCenter:CGPointMake(location.x, location.y)];
        
        // Rotate our view by the calculated angle around our new anchor point.
        [detailView setTransform:CGAffineTransformMakeRotation(angle*-1)];
     
    }
     */
    UIRotationGestureRecognizer *gesture=(UIRotationGestureRecognizer*)sender;

    self.transform = CGAffineTransformMakeRotation(gesture.rotation+m_currentAngle);

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
    m_currentAngle = atan2(self.transform.b, self.transform.a);
    return YES;
}

-(void) moveSymbol:(id)sender
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
    CGFloat topEdgePositionY=CGRectGetMinY(self.frame)+kUpperEdgeOffsetY;
    
    CGFloat bottomEdgePostionY;
    //following lines gets the bottom edge of the Current symbol
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {  bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol-110;
    
    if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
    {
        bottomEdgePostionY=CGRectGetMaxY(self.frame)+60;

    }
        
    }
    
     if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
    {  bottomEdgePostionY=CGRectGetMaxY(self.frame);//+kOffsetBottomEdgeSymbol-50;
        
        if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
        {
            bottomEdgePostionY=CGRectGetMaxY(self.frame)-50;
            
        }
        
    }

    
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

    
    if(recognizer.state == UIGestureRecognizerStateEnded||self.isFirstTouchOnSymbol == YES)
    {
        if(self.isFirstTouchOnSymbol == YES)
        {
            self.isFirstTouchOnSymbol = NO;
            
            //[self adjustViewsOnSymbolFirstDragAndDrop];
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
            bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol;
        
            if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
            {
                bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol-50;
                
            }
        }
        
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"NO"])
        {  bottomEdgePostionY=CGRectGetMaxY(self.frame)+kOffsetBottomEdgeSymbol-140;
         
            if(self.ID.integerValue == 7 || self.ID.integerValue == 8 || self.ID.integerValue == 9)
            {
                bottomEdgePostionY=CGRectGetMaxY(self.frame)+40;
                
            }
        }
        
       
        
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

}


-(void) adjustViewsOnSymbolFirstDragAndDrop
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController reloadTableData];
    
    CGPoint newPoint =   [appDelegate.detailViewController.view convertPoint:self.frame.origin toView:appDelegate.detailViewController.detailItem];
    
    [self removeFromSuperview];
    
    [appDelegate.detailViewController.detailItem addSubview:self];
    
    self.frame=CGRectMake(newPoint.x,newPoint.y ,self.frame.size.width,self.frame.size.height);
    
    
}

-(void) longPressCheck:(id) sender
{
    if(self.isShowingSymbolDeleteAlert == NO)
    {
        self.isShowingSymbolDeleteAlert = YES;
        self.sender = sender;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                          message:@"Are you sure you want to delete the symbol?"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        [message show];
        [message release];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isShowingSymbolDeleteAlert = NO;
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        [self longPress:self.sender];
        
    }
    
    else if([title isEqualToString:@"NO"] || [title isEqualToString:@"Ok"])
    {
        self.sender = nil;
        
        for(UIView *arrowView in self.outgoingArrows)
        {
            [arrowView removeFromSuperview];
            
       
        }
        
        //Removing all the Incoming Arrows associated with current Symbol
        for(UIView *arrowView in self.incomingArrows)
        {
            [arrowView removeFromSuperview];
      
        }
        
        //To check if the Last Production Control was removed
        if(self.ID.integerValue == 14)
        {
            VSInfoSymbol *productionControl=(VSInfoSymbol*)self;
            if(productionControl == [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
                [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=nil;

            }
        }
        [self removeFromSuperview];
        
    }
    
    
    

}

-(void) longPress:(id) sender
{
    [self removeFromSuperview];
}


-(void) resizeSymbol:(id) sender
{

}


-(void) removeCompleteSymbol
{
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

-(void) saveSymbolState
{
    
}
- (void)dealloc {
    self.ID = nil;
    self.tagSymbol = nil;
    self.name = nil;
    self.x = nil;
    self.y = nil;
    self.width = nil;
    self.height = nil;
    [super dealloc];
}


@end
