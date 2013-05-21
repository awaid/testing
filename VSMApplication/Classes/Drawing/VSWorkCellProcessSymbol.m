//
//  VSWorkCellProcessSymbol.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/17/13.
//
//

#import "VSWorkCellProcessSymbol.h"

@implementation VSWorkCellProcessSymbol


- (id)initWithName:(NSString*) name withTag:(NSNumber*)tag
{
    if (self = [super init]) {
        
        [self settingInitialParameters:name andWithTag:tag];
    }
    return  self;
    
}
             
@end
