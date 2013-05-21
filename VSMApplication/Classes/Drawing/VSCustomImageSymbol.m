//
//  VSHeadQuarterSymbol.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/17/13.
//
//

#import "VSCustomImageSymbol.h"
#import "VSDataManager.h"
#define kMaxScale 5.0
#define kMinScale 0.3

@interface VSCustomImageSymbol ()

@end
@implementation VSCustomImageSymbol


- (id)initWithName:(NSString*) name withTag:(NSNumber*)tag
{
    if (self = [super init]) {

        [self settingInitialParameters:name andWithTag:tag];

        self.isFirstTouchOnSymbol=YES;
        
        self.ID = [NSNumber numberWithInt:1234];
        
        [self removeTapGesture];
        
        
    }
    
    return self;
}

-(void) longPress:(id) sender
{
    [DataManager removeSymbolWithTag:self.tagSymbol andType:kCustomKey];
    
    [self removeFromSuperview];
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


-(void) scaleSymbol:(id) sender
{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    
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

-(NSMutableDictionary*) getAppStateDictionary
{
    NSMutableDictionary *symbolDictionary = [[NSMutableDictionary alloc] init];
    symbolDictionary = [super getAppStateDictionary:symbolDictionary];
    
    return [symbolDictionary autorelease];
    
    
}

-(void) saveSymbolState
{
    NSMutableDictionary *state = [self getAppStateDictionary];
    
    self.stringImage = [VSUtilities saveUIImage:self.image];
    
    if(self.stringImage !=nil)
    {
        [state setObject:self.stringImage forKey:kCustomImage];
    }
    
    [DataManager setSymbolDictionary:state andType:kCustomKey andTag:self.tagSymbol];
}

@end
