//
//  VSDataBoxSymbol.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import "VSDataBoxSymbol.h"

@implementation VSDataBoxSymbol

- (id)initWithName:(NSString*) name withTag:(NSNumber*)tag
{
     if (self = [super init])
     {
    
         [self settingInitialParameters:name andWithTag:tag];
     }
    
    return self;

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
