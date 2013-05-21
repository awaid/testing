//
//  VSDrawingManager.h
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import <Foundation/Foundation.h>
@class VSProcessSymbol;
@class VSSymbols;
@class VSDataBoxViewController;
@class VSPushArrowSymbol;
@class VSMaterialSymbol;
@class VSTimeLineHeadViewController;
@class VSInfoSymbol;
@class VSExtendedSymbol;
@class VSGeneralSymbol;
@class VSCustomImageSymbol;

@interface VSDrawingManager : NSObject
{
    VSTimeLineHeadViewController *headTimeLineController_;
    int numberOfTimeLines_;
    NSMutableArray *arrayOfTimeLine_;
    VSProcessSymbol *firstSupplierSymbolReference_;
    VSInfoSymbol *firstProductionCenterSymbolReference_;
    VSProcessSymbol *firstCustomerSymbolReference_;

    BOOL isProductionControlConnectedToSupplier_;
    BOOL isProductionControlConnectedToCustomer_;
    
    BOOL isSupplierConnectedToProcessBox_;
    BOOL isCustomerConnectedToProcessBox_;
    VSProcessSymbol *lastProcessBox_;
    BOOL isTailPresent_;
}

@property(retain, nonatomic) VSTimeLineHeadViewController *headTimeLineController;
@property(retain, nonatomic) VSProcessSymbol *firstSupplierSymbolReference;
@property(retain, nonatomic) VSProcessSymbol *firstCustomerSymbolReference;
@property(retain, nonatomic) VSInfoSymbol *firstProductionCenterSymbolReference;
@property(assign, nonatomic) VSProcessSymbol *lastProcessBox;
@property(readwrite, nonatomic) int numberOfTimeLines;
@property (retain, nonatomic) NSMutableArray *arrayOfTimeLine;
@property (readwrite,nonatomic) BOOL isProductionControlConnectedToSupplier;
@property (readwrite,nonatomic) BOOL isProductionControlConnectedToCustomer;
@property (readwrite,nonatomic) BOOL isSupplierConnectedToProcessBox;
@property (readwrite,nonatomic) BOOL isCustomerConnectedToProcessBox;
@property (nonatomic,readwrite) BOOL isParsing;
@property (nonatomic,readwrite) BOOL isParsingInfo;
@property (nonatomic,readwrite) BOOL isPlacingProcessAfterParsing;
@property (nonatomic,readwrite) BOOL isTailPresent;


+(VSDrawingManager*) sharedDrawingManager;
-(void)destroyDrawManager;

-(void) scaleSymbol:(VSSymbols*) sender;
-(void) moveSymbol:(VSSymbols*) sender;
-(void) rotateSymbol:(VSSymbols*) sender;
-(void) resizeSymbol:(VSSymbols*) sender;


-(VSProcessSymbol*) createProcessSymbolWithName:(NSString*) name andID:(NSNumber*)ID;
-(VSDataBoxViewController*) createDataBoxSymbol:(NSString*)name;
-(VSPushArrowSymbol*) createPushArrowSymbol:(NSString*)name;
-(VSMaterialSymbol*)createMaterialSymbolWithName:(NSString*)name andID:(NSNumber*) ID
;
-(VSCustomImageSymbol*) createCustomImageSymbol:(NSString*)name;
-(VSInfoSymbol*) createInformationSymbolWithName:(NSString*)name andID:(NSNumber*) ID;
-(VSExtendedSymbol*) createExtendedSymbolWithName:(NSString*)name andID:(NSNumber*)ID;
-(VSGeneralSymbol*) createGeneralSymbolWithName:(NSString*)name andID:(NSNumber*)metaID;

-(id) initiateSymbolForClassName:(NSString *)className;
-(void)addingArrowBetweenSymbolView:(VSSymbols*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 withType:(NSString*)arrowImageName andCustomerSupplierSymbol:(BOOL)isCustomer;
-(NSArray*)findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:(VSSymbols*)oldProcessSymbolView andCurrenProcessSymbol:(VSSymbols*)symbolView withCustomerSupplierSymbol:(BOOL)isCustomer;
-(void)findingNewPointsOfSymbolView:(VSSymbols*)symbolView;
-(void)adjustOutGoingArrowsConnectedToSymbolView:(VSSymbols*)symbolView;
-(void)adjustIncomingArrowsConnectedToSymbolView:(VSSymbols*)symbolView;
-(void)adjustInventorySymbolOnPushArrowSymbol:(VSSymbols*)pushArrowSymbol;
-(VSTimeLineHeadViewController*)addingHeadAndTimeLineControllerOnSymbol:(VSSymbols*)symbol;
-(VSTimeLineHeadViewController*)addingTailTimeLineControllerToProcessSymbol:(VSSymbols*)symbol;
-(void)addingArrowBetweenDataBoxView:(VSDataBoxViewController*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 andPushArrowSymbol:(VSPushArrowSymbol*)pushArrowSymbol;
-(void)removeTimeLineFromViewAttachedToProcessSymbol:(VSSymbols*)symbolView;
-(void)adjustFrameOfTimeLineAfterRemovingTimeLineController:(VSTimeLineHeadViewController*)timeLineController foundAtIndex:(int)index;
-(void)adjustOutGoingArrowsConnectedToDataBox:(VSDataBoxViewController*)symbolView;
-(void)adjustIncomingArrowsConnectedToDataBox:(VSDataBoxViewController*)symbolView;

-(void)addingArrowBetweenSymbolView:(VSSymbols*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 andPushSymbol:(VSPushArrowSymbol*)pushArrowSymbol andMaterialSymbol:(VSMaterialSymbol*)materialSymbol andCustomerSupplierSymbol:(BOOL)isCustomer;

-(void) addArrowsBetweenInfoSymbol:(VSInfoSymbol*) symbolInfo;

-(int)findingNumberOfProcessBoxInDetaiView;
-(void)addArrowsBetweenDisconnectedProcessSymbols:(VSSymbols*)processSumbol;
-(void)adjustHeadAndTailTimeLinePositionWithProcessSymbol:(VSProcessSymbol*)processSymbol;
-(void)forceCallSymbolMoveOnProcessSymbol;
-(void)updateTimeOnHeadTimeLine;
@end
