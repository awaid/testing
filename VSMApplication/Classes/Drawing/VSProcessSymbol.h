//
//  VSProcess.h
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "VSSymbols.h"
#import "VSDataBoxViewController.h"
#import "VSInfoSymbol.h"
@class VSTimeLineHeadViewController;
@interface VSProcessSymbol : VSSymbols <UITextViewDelegate>
{
    VSTimeLineHeadViewController *timeLineRefernce_;
    UITextView *processNameTextField_;
    UITextView *processNumberTextField_;
    VSDataBoxViewController *dataBoxController_;
    VSProcessSymbol *supplierSymbolReference_;
    VSProcessSymbol *customerSymbolReference_;
    VSProcessSymbol *processBoxReferenceForSupplier_;
    VSProcessSymbol *processBoxReferenceForCustomer_;
    VSTimeLineHeadViewController *timeLineRefernceTailReference_;

}
@property (nonatomic,retain) VSDataBoxViewController *dataBoxController;
@property (nonatomic,retain) VSTimeLineHeadViewController *timeLineRefernce;
@property (nonatomic,retain) VSTimeLineHeadViewController *timeLineTailReference;
@property (nonatomic,retain) UITextView *processNameTextField;
@property (nonatomic,retain) UITextView *processNumberTextField;
@property (nonatomic,retain) VSProcessSymbol *supplierSymbolReference;
@property (nonatomic,retain) VSProcessSymbol *processBoxReferenceForSupplier;
@property (nonatomic,retain) VSProcessSymbol *processBoxReferenceForCustomer;
@property (nonatomic,retain) VSProcessSymbol *customerSymbolReference;


-(void) addDataBox;
-(id)initWithName:(NSString *)name withTag:(NSString *)tag andMetaDataID:(NSNumber*)metaID;
-(void) adjustViewsOnSymbolFirstDragAndDrop;
-(void) adjustDataBoxWithPoint:(CGPoint) newPoint;
-(void) addDataBoxOnObjectCreation;
@end
