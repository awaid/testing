//
//  VSArrowSymbol.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/12/13.
//
//

#import "VSPushArrowSymbol.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSMaterialSymbol.h"
#import "VSDrawingManager.h"
#import "VSDataManager.h"
#import <QuartzCore/QuartzCore.h>
#define kMaxScale 50
#define kMinScale 0.1
@interface VSPushArrowSymbol ()
{
    CGAffineTransform oldTransform_;
    NSString *imageName_;
    UIImageView * tmpImageView_;
}
@property (nonatomic,readwrite) CGAffineTransform oldTransform;
@property (nonatomic,retain) NSString *imageName;
@property (nonatomic,retain) UIImageView * tmpImageView;
@end

@implementation VSPushArrowSymbol
@synthesize startingPoint=startingPoint_;
@synthesize endingPoint=endingPoint_;
@synthesize oldTransform=oldTransform_;
@synthesize inventoryObjectReference=inventoryObjectReference_;
@synthesize imageName=imageName_;
@synthesize tmpImageView=tmpImageView_;

-(id)initWithName:(NSString *)name withTag:(NSNumber *)tag
{
    if (self = [super init]) {
        [self settingInitialParameters:name andWithTag:tag];
        
        

        if([name isEqualToString:@"push-symbols"])
        {

 
            self.imageName=@"push-symbols-outline.png";
            self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
            self.image=[UIImage imageNamed:@"push-symbols-outline.png"];
            //self.contentMode = UIViewContentModeCenter;
            //self.contentMode=UIViewContentModeCenter;
        

        }
        
        else if([name isEqualToString:@"information-flow"])
        {
            self.image=[UIImage imageNamed:@"information-flow-outline.png"];
            self.imageName=@"information-flow-outline.png";
            self.imageColorFileName=[NSString stringWithFormat:@"%@-outline.png",self.name];
        }
        
        else if([name isEqualToString:@"information-flow-2"])
        {
            self.image=[UIImage imageNamed:@"information-flow-2-outline-rotated"];
            self.imageName=@"information-flow-2-outline-rotated.png";
            self.imageColorFileName=[NSString stringWithFormat:@"%@-outline-rotated.png",self.name];
        }
        
        self.ID = [[VSDataManager sharedDataManager] getIDBasedOnImageName:self.imageName];
        
        self.lastRotation=0.0;
        self.oldTransform=self.transform;
        //self.contentMode = UIViewContentModeScaleAspectFill;
        //self.clipsToBounds = YES;
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, 60);
        self.isFirstTouchOnSymbol = NO;
        }
    
    //[self removeTapGesture];
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [tmpImageView_ release];
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

-(void)applyRotationToSymbolWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    CGFloat rotation = [VSUtilities pointPairDegrees:point1 endingPoint:point2];
    
    CGAffineTransform currentTransform = self.oldTransform;
    CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform,rotation);
    [self setTransform:newTransform];
}
-(void)adjustingWidthOfSymbolWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    //Removing the Old Image
    self.image=nil;
    
    //Getting the new Width for the Image based on the two new Points
    NSNumber *widthForArrowImage=[VSUtilities distanceBetweenPoint:point2 andPoint:point1];
    

    
    //Finding a new scaled images based on the new Width for the Image
    self.image=[VSUtilities imageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageColorFileName]] scaledToWidth:widthForArrowImage.floatValue];

    
    

    //The following IF ELSE condition is to make sure that the height of the arrow doesnt increase greater than 200 when the width is increased
    //updating the Bounds of the UIImage
    if(self.image.size.height > 200)
    {
        if(self.ID.integerValue == 8)
        self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForArrowImage.floatValue, 30);
        
        else
        {
            self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForArrowImage.floatValue, 60);

        }
        
    }
    
    else
    {
        if(self.ID.integerValue == 8)
    self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForArrowImage.floatValue, 30);
        
        else
        {
            self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForArrowImage.floatValue, 60);

        }
        
        
    }
    
    
    //applying the center
    self.center=[VSUtilities centerCoordinateBetweenPoint:point1 andPoint2:point2];
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
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self setTransform:newTransform];
    
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}
-(void) rotateSymbol:(id) sender
{
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        self.lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [self setTransform:newTransform];
    
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

-(void)longPress:(id)sender
{
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    for(UIView* tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSMaterialSymbol class]])
        {
            if(tmpView == self.inventoryObjectReference)
            {
                [self.inventoryObjectReference removeTheReferenceOfMaterialSymbolFromArrowSymbol];
                [tmpView removeFromSuperview];
                self.inventoryObjectReference=nil;
            }
        }
    }
    
    [self removeFromSuperview];

}

-(NSMutableDictionary*) getAppStateDictionary
{
    if(self.tagSymbol == nil)
    {
        return nil;
    }
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    [symbolDictionary setObject:self.tagSymbol forKey:kTagArrow];
    if(self.inventoryObjectReference != nil)
    {
        [symbolDictionary setObject:self.inventoryObjectReference.tagSymbol forKey:kTagMaterialArrow];
        [self.inventoryObjectReference saveSymbolState];
    }
    
    
    
    
    [symbolDictionary setObject:self.name forKey:kName];

    if(self.imageColorFileName != nil)
    {
        [symbolDictionary setObject:self.imageColorFileName forKey:kColorFileName];
    }
    return [symbolDictionary autorelease];
    
    
}


@end
