//
//  VSArrowSymbol.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/12/13.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"
@class VSMaterialSymbol;

@interface VSPushArrowSymbol : VSSymbols
{
    CGPoint startingPoint_;
    CGPoint endingPoint_;
    VSMaterialSymbol *inventoryObjectReference_;
    NSString*imageColorFileName_;

}
@property (nonatomic,readwrite) CGPoint startingPoint;
@property (nonatomic,readwrite) CGPoint endingPoint;
@property (nonatomic,retain) VSMaterialSymbol *inventoryObjectReference;


-(void)applyRotationToSymbolWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2;
-(void)adjustingWidthOfSymbolWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2;

-(NSMutableDictionary*) getAppStateDictionary;
@end
