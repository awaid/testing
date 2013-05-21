//
//  VSDrawingManager.m
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import "VSDrawingManager.h"
#import "VSSymbols.h"
#import "VSProcessSymbol.h"
#import "VSDataBoxSymbol.h"
#import "VSDataBoxViewController.h"
#import "VSPushArrowSymbol.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSMaterialSymbol.h"
#import "VSTimeLineHeadViewController.h"
#import "VSInfoSymbol.h"
#import "VSGeneralSymbol.h"
#import "VSExtendedSymbol.h"
#import "VSDataManager.h"
#import "VSCustomImageSymbol.h"
#import "VSMapPopulationManager.h"
#import "VSInfoSymbol.h"

#define kDefaultOffsetTimeLinePositionX 300
#define kDefaultOffsetTimelinePositionY 175
#define kTagForHeadTimeLine 100
#define kDefaultTailTimeLineOffsetPositionX -36
#define kDefaultTimeLineWidth 194
#define kDefaultTimeLineHeight 147
#define kDefaultPreceedingTimeLifeOffsetX 24
#define kDefaultWidth 65
#define kDefaultHeight 65
#define kHeadTimelineLeftEdgePositionX 1475
#define kDefaultTimeLineTailWidth 113
#define kDefaulttimeLineTailHeight 84



@implementation VSDrawingManager

@synthesize headTimeLineController=headTimeLineController_;
@synthesize numberOfTimeLines=numberOfTimeLines_;
@synthesize arrayOfTimeLine=arrayOfTimeLine_;
@synthesize firstSupplierSymbolReference=firstSupplierSymbolReference_;
@synthesize firstProductionCenterSymbolReference=firstProductionCenterSymbolReference_;
@synthesize firstCustomerSymbolReference=firstCustomerSymbolReference_;
@synthesize isProductionControlConnectedToCustomer=isProductionControlConnectedToCustomer_;
@synthesize isProductionControlConnectedToSupplier=isProductionControlConnectedToSupplier_;
@synthesize isSupplierConnectedToProcessBox=isSupplierConnectedToProcessBox_;
@synthesize isCustomerConnectedToProcessBox=isCustomerConnectedToProcessBox_;
@synthesize lastProcessBox=lastProcessBox_;
@synthesize isTailPresent=isTailPresent_;
static VSDrawingManager * _sharedDrawingManager_ = nil;

+(VSDrawingManager*) sharedDrawingManager
{
    if(!_sharedDrawingManager_)
    {
        _sharedDrawingManager_ = [[VSDrawingManager alloc] init];
    }
    return _sharedDrawingManager_;
}

-(void)destroyDrawManager
{
    if([self.arrayOfTimeLine count] > 0)
    {
        [self.arrayOfTimeLine removeAllObjects];
    }
    // self.headTimeLineController = nil;
    self.numberOfTimeLines = nil;
    
    self.isTailPresent=NO;
    
    self.firstCustomerSymbolReference = nil;
    self.firstProductionCenterSymbolReference = nil;
    self.firstSupplierSymbolReference = nil;
    self.isProductionControlConnectedToCustomer = nil;
    self.isProductionControlConnectedToSupplier = nil;
    self.isSupplierConnectedToProcessBox = nil;
    self.isCustomerConnectedToProcessBox = nil;
    _sharedDrawingManager_=nil;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    _sharedDrawingManager_ = self;
    return self;
}

-(void) scaleSymbol:(VSSymbols*) sender
{
    [sender scaleSymbol:sender];
}

-(void) moveSymbol:(VSSymbols*) sender
{
    // [sender moveSymbolToPoint:CGPointMake(100,100)];
}

-(void) rotateSymbol:(VSSymbols*) sender
{
    [sender rotateSymbol:sender];
}

-(void) resizeSymbol:(VSSymbols*) sender
{
    [sender resizeSymbol:sender];
}

#pragma mark Create Symbols

-(VSProcessSymbol*) createProcessSymbolWithName:(NSString*) name andID:(NSNumber*)ID
{
    
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kProcessKey];
    VSProcessSymbol *process = [[VSProcessSymbol alloc] initWithName:name withTag:tagSymbol andMetaDataID:ID];
    [process autorelease];
    return process;
}
-(VSPushArrowSymbol*) createPushArrowSymbol:(NSString*)name
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kProcessKey];
    VSPushArrowSymbol *arrowSymbol = [[VSPushArrowSymbol alloc] initWithName:name withTag:tagSymbol];
    arrowSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    return arrowSymbol;
    
}
-(VSCustomImageSymbol*) createCustomImageSymbol:(NSString*)name
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kCustomKey];
    VSCustomImageSymbol *customSymbol=[[VSCustomImageSymbol alloc] initWithName:name withTag:tagSymbol];
    customSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    return customSymbol;
    
}

-(id) initiateSymbolForClassName:(NSString *)className
{
    id classInstance = [[[NSClassFromString(className) alloc] init] autorelease];
    return classInstance;
    
}
-(VSDataBoxViewController*) createDataBoxSymbol:(NSString*)name
{
    VSDataBoxViewController *dataBox= [[VSDataBoxViewController alloc] initWithNibName:@"VSDataBoxViewController" bundle:nil];
    dataBox.ID=[NSNumber numberWithInt:4];
    [dataBox autorelease];
    return dataBox;
}

-(VSMaterialSymbol*)createMaterialSymbolWithName:(NSString*)name andID:(NSNumber*) ID
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kMaterialKey];
    VSMaterialSymbol *inventorySymbol = [[VSMaterialSymbol alloc] initWithName:name withTag:tagSymbol];
    inventorySymbol.ID = ID;
    
    
    
    inventorySymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    [inventorySymbol autorelease];
    return inventorySymbol;
}

-(VSInfoSymbol*) createInformationSymbolWithName:(NSString*)name andID:(NSNumber*) ID
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kInfoKey];
    VSInfoSymbol *symbol = [[VSInfoSymbol alloc] initWithName:name withTag:tagSymbol andMetaDataID:ID];
    return symbol;
}

-(VSExtendedSymbol*) createExtendedSymbolWithName:(NSString*)name andID:(NSNumber*)ID
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kExtendedKey];
    VSExtendedSymbol *symbol = [[VSExtendedSymbol alloc] initWithName:name withTag:tagSymbol andMetaDataID:ID];
    return symbol;
}

-(VSGeneralSymbol*) createGeneralSymbolWithName:(NSString*)name andID:(NSNumber*)metaID
{
    NSString *tagSymbol = [DataManager getSymbolTagForNewObjectForType:kGeneralKey];
    VSGeneralSymbol *symbol = [[VSGeneralSymbol alloc] initWithName:name withTag:tagSymbol andMetaDataID:metaID];
    return symbol;
}
#pragma mark - Adjusting Outgoing & Incoming Arrows with DataBox



-(void) addArrowsBetweenInfoSymbol:(VSInfoSymbol*) symbolInfo
{
    NSLog(@"Production value : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"]);
    //Incase where its added for the First Time,Draw out arrows to all existing Process Box
    if([VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference == nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isProductionControlAdded"] isEqualToString:@"NO"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"] && !symbolInfo.isRemoved)
    {
        
        VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
        {
            if([tmpView isKindOfClass:[VSProcessSymbol class]])
            {
                VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
                if(processSymbol.ID.integerValue != 1 && processSymbol.ID.integerValue != 43 && processSymbol.ID.integerValue != 4)
                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)tmpView andSymbolView:(VSSymbols*)symbolInfo withType:@"information-flow" andCustomerSupplierSymbol:YES];
                
            }
            
        }
        
        //Adding Arrows to Customer Symbol and Production control
        if([VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference)
        {
            [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSSymbols*)symbolInfo andSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference   withType:@"information-flow-2" andCustomerSupplierSymbol:YES];
            
        }
        
        //Adding Arrows to Supplier Symbol and Production control
        if([VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference)
        {
            [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSProcessSymbol*)[VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference    andSymbolView:(VSSymbols*)symbolInfo withType:@"information-flow-2" andCustomerSupplierSymbol:YES];

        }
        
        
        [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=symbolInfo ;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isProductionControlAdded"];
        
        [symbolInfo saveSymbolState];
        
    }
}

-(int)findingNumberOfProcessBoxInDetaiView
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    int count=0;
    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            VSProcessSymbol *symbol=(VSProcessSymbol*)tmpView;
            //The following Check makes sure that found Process Symbol is a Process Box Only
            if(symbol.ID.integerValue == 2 || symbol.ID.integerValue == 3 || symbol.ID.integerValue == 5 || symbol.ID.integerValue == 42 || symbol.ID.integerValue == 44)
            {
                count++;
            }
        }
    }
    
    return count;
}
-(void)settingConnectedToAndConnectedFromProcessSymbolIDS:(VSProcessSymbol*)processSymbol
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSArray *reverseArray=[[[appDelegate.detailViewController.detailItem subviews]  reverseObjectEnumerator] allObjects];
    
    for(UIView * tmpView in reverseArray)
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]] && tmpView != processSymbol)
        {
            VSProcessSymbol *symbol=(VSProcessSymbol*)tmpView;
            if(symbol.ID.integerValue == 2 || symbol.ID.integerValue == 3 || symbol.ID.integerValue == 5 || symbol.ID.integerValue == 42 || symbol.ID.integerValue == 44)
            {
                
                NSLog(@"--------------BEFORE------------------------");
                NSLog(@"Deleted Process Symbol ID -> %d",processSymbol.tagSymbol.integerValue);
                NSLog(@"Process Symbol ID -> %d",symbol.tagSymbol.integerValue);
                NSLog(@"Prcocess Connected To Symbol ID -> %@",symbol.connectedToProcessSymbolID);
                NSLog(@"Prcocess Connect From Symbol ID -> %@",symbol.connectedFromProcessSymbolID);
                NSLog(@"--------------BEFORE ENDS-------------------");
                
                
                if([symbol.connectedToProcessSymbolID isEqualToNumber:[NSNumber numberWithInt:processSymbol.tagSymbol.integerValue]])
                {
                    if(processSymbol.connectedToProcessSymbolID == NULL)
                        symbol.connectedToProcessSymbolID=NULL;
                    else
                    {
                        symbol.connectedToProcessSymbolID=[NSNumber numberWithInt:0];
                    }
                }
                
                if([symbol.connectedFromProcessSymbolID isEqualToNumber:[NSNumber numberWithInt:processSymbol.tagSymbol.integerValue]])
                {
                    if(processSymbol.connectedFromProcessSymbolID == NULL)
                    {
                        symbol.connectedFromProcessSymbolID=NULL;
                    }
                    
                    else
                        symbol.connectedFromProcessSymbolID=[NSNumber numberWithInt:0];
                    //break;
                }
                
                NSLog(@"--------------AFTER------------------------");
                NSLog(@"Deleted Process Symbol ID -> %d",processSymbol.tagSymbol.integerValue);
                NSLog(@"Process Symbol ID -> %d",symbol.tagSymbol.integerValue);
                NSLog(@"Prcocess Connected To Symbol ID -> %@",symbol.connectedToProcessSymbolID);
                NSLog(@"Prcocess Connect From Symbol ID -> %@",symbol.connectedFromProcessSymbolID);
                NSLog(@"--------------AFTER ENDS-------------------");
            }
        }
    }
    
}
-(void)addArrowsBetweenDisconnectedProcessSymbols:(VSSymbols*)processSymbol
{
    [self settingConnectedToAndConnectedFromProcessSymbolIDS:(VSProcessSymbol*)processSymbol];
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    VSProcessSymbol *disconnectedArrow1=NULL;
    VSProcessSymbol *disconnctedArrow2=NULL;
    
    
    for(UIView * tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        VSProcessSymbol *symbol=(VSProcessSymbol*)tmpView;
        if([tmpView isKindOfClass:[VSProcessSymbol class]] && symbol != processSymbol )//&& symbol.connectedFromProcessSymbolID != NULL)
        {
            if([symbol.connectedToProcessSymbolID isEqualToNumber:[NSNumber numberWithInt:0]] )//&& symbol.connectedFromProcessSymbolID != NULL)
            {
                disconnectedArrow1=symbol;
                break;
            }
        }
    }
    
    for(UIView * tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        VSProcessSymbol *symbol=(VSProcessSymbol*)tmpView;
        if([tmpView isKindOfClass:[VSProcessSymbol class]] && symbol != processSymbol && symbol != disconnectedArrow1 )//&& symbol.connectedToProcessSymbolID != NULL)
        {
            if([symbol.connectedFromProcessSymbolID isEqualToNumber:[NSNumber numberWithInt:0]])//&& symbol.connectedToProcessSymbolID != NULL)
            {
                disconnctedArrow2=symbol;
                break;
            }
        }
    }
    //Adding arrows between the 2 disconnected Symbols
    if(disconnectedArrow1 != NULL && disconnctedArrow2 != NULL)
    {
        [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:(VSSymbols*)disconnctedArrow2 andSymbolView:(VSSymbols*)disconnectedArrow1 withType:@"push-symbols" andCustomerSupplierSymbol:NO];
    }
    
    
}
-(void)addingArrowBetweenDataBoxView:(VSDataBoxViewController*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 withType:(NSString*)arrowImageName
{
    
    NSArray *arrayWithPoints=[[VSDrawingManager sharedDrawingManager] findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:symbolView2 andCurrenDataBox:symbolView1];
    VSPushArrowSymbol *pushArrowSymbol=[[VSDrawingManager sharedDrawingManager] createPushArrowSymbol:arrowImageName];
    
    NSValue *val = [arrayWithPoints objectAtIndex:0];
    CGPoint point1 = [val CGPointValue];
    
    NSValue *val2 = [arrayWithPoints objectAtIndex:1];
    CGPoint point2 = [val2 CGPointValue];
    
    
    [pushArrowSymbol adjustingWidthOfSymbolWithPoint:point1 andPoint:point2];
    [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:point2];
    
    pushArrowSymbol.startingPoint=point2;
    pushArrowSymbol.endingPoint=point1;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.detailViewController.detailItem addSubview:pushArrowSymbol];
    
    //Adding Push Arrow as an incoming arrow to the Current Process Box
    [symbolView1.incomingArrows addObject:pushArrowSymbol];
    
    //Adding Push arrow as an outgoing arrow to Previous Process Box
    VSProcessSymbol *previousSymbolView=(VSProcessSymbol*)symbolView2;
    if(previousSymbolView.isDataBoxIndependant == NO)
        [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
    
    else if (previousSymbolView.isDataBoxIndependant == YES)
    {
        [previousSymbolView.dataBoxController.outgoingArrows addObject:pushArrowSymbol];
    }
    
    //Releasing the push Symbol
    [pushArrowSymbol release];
    
    
    //Adding Inventory symbol along with the Current Push Arrow
    VSMaterialSymbol *materialSymbol=[[VSDrawingManager sharedDrawingManager] createMaterialSymbolWithName:@"Material" andID:[NSNumber numberWithInt:6]];
    [materialSymbol addTextFieldToInventorySymbol];
    [appDelegate.detailViewController.detailItem addSubview:materialSymbol];
    
    
    
    
    materialSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    materialSymbol.center=CGPointMake(pushArrowSymbol.center.x, pushArrowSymbol.center.y);

    
    
    materialSymbol.textField.frame=CGRectMake(5, materialSymbol.frame.size.height-20, materialSymbol.frame.size.width-18, 20);
    
    
    materialSymbol.textField.center=CGPointMake(materialSymbol.frame.size.width/2,materialSymbol.frame.size.height/2);
    
    
    
    
    pushArrowSymbol.inventoryObjectReference=materialSymbol;
    [materialSymbol release];
    
}

-(void)addingArrowBetweenDataBoxView:(VSDataBoxViewController*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 andPushArrowSymbol:(VSPushArrowSymbol*)pushArrowSymbol
{
    
    NSArray *arrayWithPoints=[[VSDrawingManager sharedDrawingManager] findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:symbolView2 andCurrenDataBox:symbolView1];
    
    
    NSValue *val = [arrayWithPoints objectAtIndex:0];
    CGPoint point1 = [val CGPointValue];
    
    NSValue *val2 = [arrayWithPoints objectAtIndex:1];
    CGPoint point2 = [val2 CGPointValue];
    
    
    [pushArrowSymbol adjustingWidthOfSymbolWithPoint:point1 andPoint:point2];
    [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:point2];
    
    pushArrowSymbol.startingPoint=point2;
    pushArrowSymbol.endingPoint=point1;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.detailViewController.detailItem addSubview:pushArrowSymbol];
    
    //Adding Push Arrow as an incoming arrow to the Current Process Box
    [symbolView1.incomingArrows addObject:pushArrowSymbol];
    
    //Adding Push arrow as an outgoing arrow to Previous Process Box
    VSProcessSymbol *previousSymbolView=(VSProcessSymbol*)symbolView2;
    if(previousSymbolView.isDataBoxIndependant == NO)
        [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
    
    else if (previousSymbolView.isDataBoxIndependant == YES)
    {
        [previousSymbolView.dataBoxController.outgoingArrows addObject:pushArrowSymbol];
    }
    
    
    
    
    //    //Adding Inventory symbol along with the Current Push Arrow
    //    VSMaterialSymbol *materialSymbol=[[VSDrawingManager sharedDrawingManager] createMaterialSymbolWithName:@"Material" andID:[NSNumber numberWithInt:1000]];
    //    [materialSymbol addTextFieldToInventorySymbol];
    //    [appDelegate.detailViewController.detailItem addSubview:materialSymbol];
    //
    //
    //
    //
    //    materialSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    //    materialSymbol.center=CGPointMake(pushArrowSymbol.center.x, pushArrowSymbol.center.y);
    //
    //
    //
    //    materialSymbol.textField.frame=CGRectMake(5, materialSymbol.frame.size.height-20, materialSymbol.frame.size.width-18, 20);
    //
    //
    //    materialSymbol.textField.center=CGPointMake(materialSymbol.frame.size.width/2,materialSymbol.frame.size.height/2+37);
    //
    //
    //
    //
    //    pushArrowSymbol.inventoryObjectReference=materialSymbol;
    //    [materialSymbol release];
    
}
//The following function adjusts the position of all OutGoing Arrows from the Given Symbol View
-(void)adjustOutGoingArrowsConnectedToDataBox:(VSDataBoxViewController*)symbolView
{
    int numberOfArrows=[symbolView.outgoingArrows count];
    
    for(int i=0; i < numberOfArrows; i++)
    {
        VSPushArrowSymbol *pushArrowSymbol=[symbolView.outgoingArrows objectAtIndex:i];
        
        //Finding the new center of position of each side of symbol,after it has been moved
        [self findingNewPointsOfDataBox:symbolView];
        CGPoint point1;
        
        NSNumber* distanceBetweenTopPoint=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenLeftPoint=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenRightPoint=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenBottomPoint=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        
        //Shorest Distance between all above 4 calculated points
        NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenTopPoint,distanceBetweenLeftPoint,distanceBetweenRightPoint,distanceBetweenBottomPoint, nil]];
        
        
        if([shortestDistance isEqualToNumber:distanceBetweenTopPoint])
        {
            point1=symbolView.topNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPoint])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPoint])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPoint])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
        }
        //The new starting point,based on the new position of the moved symbol
        
        
        pushArrowSymbol.startingPoint=point1;
        
        
        [pushArrowSymbol applyRotationToSymbolWithPoint:pushArrowSymbol.endingPoint andPoint:point1];
        [pushArrowSymbol adjustingWidthOfSymbolWithPoint:pushArrowSymbol.endingPoint andPoint:point1];
        
        
        if(pushArrowSymbol.inventoryObjectReference!=nil)
            [self adjustInventorySymbolOnPushArrowSymbol:pushArrowSymbol];
        
        
    }
}
//The following function adjusts the position of all Incoming Arrows from the Given Symbol View
-(void)adjustIncomingArrowsConnectedToDataBox:(VSDataBoxViewController*)symbolView
{
    int numberOfArrows=[symbolView.incomingArrows count];
    
    for(int i=0; i < numberOfArrows; i++)
    {
        VSPushArrowSymbol *pushArrowSymbol=[symbolView.incomingArrows objectAtIndex:i];
        
        //Finding the new center of position of each side of symbol,after it has been moved
        [self findingNewPointsOfDataBox:symbolView];
        CGPoint point1;
        
        NSNumber* distanceBetweenTopPoint=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenLeftPoint=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenRightPoint=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenBottomPoint=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        
        //Shorest Distance between all above 4 calculated points
        NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenTopPoint,distanceBetweenLeftPoint,distanceBetweenRightPoint,distanceBetweenBottomPoint, nil]];
        
        
        if([shortestDistance isEqualToNumber:distanceBetweenTopPoint])
        {
            point1=symbolView.topNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPoint])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPoint])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPoint])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
        }
        //The new starting point,based on the new position of the moved symbol
        
        
        
        pushArrowSymbol.endingPoint=point1;
        
        [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:pushArrowSymbol.startingPoint];
        [pushArrowSymbol adjustingWidthOfSymbolWithPoint:pushArrowSymbol.startingPoint andPoint:point1];
        
        
        if(pushArrowSymbol.inventoryObjectReference!=nil)
            [self adjustInventorySymbolOnPushArrowSymbol:pushArrowSymbol];
        
    }
}
-(void)findingNewPointsOfDataBox:(VSDataBoxViewController*)dataBox
{
    float leftNewSymbolPositionY=dataBox.view.frame.origin.y+dataBox.view.frame.size.height/2;
    float leftNewSymbolPositionX=dataBox.view.frame.origin.x;
    dataBox.leftNewSymbolPositionPoint=CGPointMake(leftNewSymbolPositionX, leftNewSymbolPositionY);
    
    //Getting the Right Position Coordinte
    float rightNewSymbolPositionY=dataBox.view.frame.origin.y+dataBox.view.frame.size.height/2;
    float rightNewSymbolPositionX=dataBox.view.frame.origin.x+dataBox.view.frame.size.width+50;
    dataBox.rightNewSymbolPositionPoint=CGPointMake(rightNewSymbolPositionX, rightNewSymbolPositionY);
    
    //Getting the Top Position Coordinate
    float topNewSymbolPositionY=dataBox.view.frame.origin.y;
    float topNewSymbolPositionX=dataBox.view.frame.origin.x+dataBox.view.frame.size.width/2;
    dataBox.topNewSymbolPositionPoint=CGPointMake(topNewSymbolPositionX, topNewSymbolPositionY);
    
    //Getting the Bottom Position Coordinate
    float bottomNewSymbolPositionY=dataBox.view.frame.origin.y+dataBox.view.frame.size.height;
    float bottomNewSymbolPositionX=dataBox.view.frame.origin.x+dataBox.view.frame.size.width/2;
    dataBox.bottomNewSymbolPositionPoint=CGPointMake(bottomNewSymbolPositionX, bottomNewSymbolPositionY);
}
-(NSArray*)findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:(UIView*)oldProcessSymbolView andCurrenDataBox:(VSDataBoxViewController*)symbolView {
    //////----FOR OLD PROCESS SYMBOL----///////
    //Getting left Postion Coordinate
    float leftPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height/2;
    float leftPositionX=oldProcessSymbolView.frame.origin.x;
    CGPoint leftPositionPoint=CGPointMake(leftPositionX, leftPositionY);
    
    //Getting the Right Position Coordinte
    float rightPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height/2;
    float rightPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width;
    CGPoint rightPositionPoint=CGPointMake(rightPositionX, rightPositionY);
    
    //Getting the Top Position Coordinate
    float topPositionY=oldProcessSymbolView.frame.origin.y;
    float topPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width/2;
    CGPoint topPositionPoint=CGPointMake(topPositionX, topPositionY);
    
    //Getting the Bottom Position Coordinate
    float bottomPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height;
    float bottomPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width/2;
    
    CGPoint bottomPositionPoint=CGPointMake(bottomPositionX, bottomPositionY);
    
    
    /////----FOR NEW CURRENT PROCESS SYMBOL----//////
    //Getting left Postion Coordinate
    [self findingNewPointsOfDataBox:symbolView];
    
    
    //Finding Distance Between Top Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber*  distanceBetweenLeftPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber*  distanceBetweenRightPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber*  distanceBetweenBottomPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromTopPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointTop,distanceBetweenLeftPointTop,distanceBetweenRightPointTop,distanceBetweenTopPointTop,nil]];
    
    //Finding Distance Between Bottom Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromBottomPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointBottom,distanceBetweenLeftPointBottom,distanceBetweenRightPointBottom,distanceBetweenTopPointBottom,nil]];
    
    //Finding Distance Between Left Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromLeftPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointLeft,distanceBetweenLeftPointLeft,distanceBetweenRightPointLeft,distanceBetweenTopPointLeft,nil]];
    
    //Finding Distance Between Right Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromRightPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointRight,distanceBetweenLeftPointRight,distanceBetweenRightPointRight,distanceBetweenTopPointRight,nil]];
    
    
    //Shorest Distance between all above 4 calculated points
    NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:shortestDistanceFromTopPoint,shortestDistanceFromBottomPoint,shortestDistanceFromLeftPoint,shortestDistanceFromRightPoint, nil]];
    
    CGPoint point1;
    CGPoint point2;
    
    //shortest Distance from Top point
    if([shortestDistance isEqualToNumber:shortestDistanceFromTopPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
        
    }//Check for top position point ends here
    
    
    //Bottom point comparison starts
    else if([shortestDistance isEqualToNumber:shortestDistanceFromBottomPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//bottom point comparison ends here
    
    //Left point comparison ends here
    else if([shortestDistance isEqualToNumber:shortestDistanceFromLeftPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//left point comparison ends here
    
    //right point comparison ends here
    else if([shortestDistance isEqualToNumber:shortestDistanceFromRightPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//left point comparison ends here
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],nil];
    
}
#pragma mark - Auto adjustment of Push Arrow Symbol
//The following method adds Arrows between given process Symbol Views
-(void)addingArrowBetweenSymbolView:(VSSymbols*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 withType:(NSString*)arrowImageName andCustomerSupplierSymbol:(BOOL)isCustomer
{
    
    
    NSArray *arrayWithPoints=[[VSDrawingManager sharedDrawingManager] findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:symbolView2 andCurrenProcessSymbol:symbolView1 withCustomerSupplierSymbol:isCustomer];
    VSPushArrowSymbol *pushArrowSymbol=[[VSDrawingManager sharedDrawingManager] createPushArrowSymbol:arrowImageName];
    
    pushArrowSymbol.image=[UIImage imageNamed:pushArrowSymbol.imageColorFileName];
    
    NSString *namedImage;
    
    if(self.isParsingInfo == YES)
    {
        if(![symbolView1 isKindOfClass:[VSInfoSymbol class]])
        {
            namedImage = [[VSMapPopulationManager sharedPopulationManager] getColorForCustomerArrow:isCustomer andForTag:symbolView1.tagSymbol];

        }
        
        else if(![symbolView2 isKindOfClass:[VSInfoSymbol class]])
        {
            namedImage = [[VSMapPopulationManager sharedPopulationManager] getColorForCustomerArrow:isCustomer andForTag:symbolView2.tagSymbol];
            
        }
        
        
        if(namedImage != nil)
        {
            pushArrowSymbol.image=[UIImage imageNamed:namedImage];
            pushArrowSymbol.imageColorFileName = namedImage;
        }

    }
    NSValue *val = [arrayWithPoints objectAtIndex:0];
    CGPoint point1 = [val CGPointValue];
    
    NSValue *val2 = [arrayWithPoints objectAtIndex:1];
    CGPoint point2 = [val2 CGPointValue];
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    [pushArrowSymbol adjustingWidthOfSymbolWithPoint:point1 andPoint:point2];
    [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:point2];
    
    pushArrowSymbol.startingPoint=point2;
    pushArrowSymbol.endingPoint=point1;
    
    [appDelegate.detailViewController.detailItem addSubview:pushArrowSymbol];
    
    
    VSProcessSymbol*newSymbol=(VSProcessSymbol*)symbolView1;
    //For handling case where The current symbol might be Customer/Supplier, Databox Controller property needs not to be checked
    if(isCustomer == NO)
    {
        //Adding Push Arrow as an incoming arrow to the Current Process Box
        if(symbolView1.isDataBoxIndependant == NO)
            [newSymbol.incomingArrows addObject:pushArrowSymbol];
        else if(symbolView1.isDataBoxIndependant == YES)
            [newSymbol.dataBoxController.incomingArrows addObject:pushArrowSymbol];
    }
    
    else
    {
        [newSymbol.incomingArrows addObject:pushArrowSymbol];
        
    }
    
    VSProcessSymbol *previousSymbolView=(VSProcessSymbol*)symbolView2;
    
    //For handling case where The current symbol might be Customer/Supplier, Databox Controller property needs not to be checked
    if(isCustomer == NO)
    {
        
        //Adding Push arrow as an outgoing arrow to Previous Process Box
        if(symbolView2.isDataBoxIndependant == NO)
        {
            // [previousSymbolView.outgoingArrows removeAllObjects];
            [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
            
        }
        
        else if (symbolView2.isDataBoxIndependant == YES)
        {
            // [previousSymbolView.dataBoxController.outgoingArrows removeAllObjects];
            
            [previousSymbolView.dataBoxController.outgoingArrows addObject:pushArrowSymbol];
        }
        
    }
    
    else
    {
        [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
        
    }
    
    
    if([arrowImageName isEqualToString:@"push-symbols"])
    {
        //Setting the Two IDs for connecting Process Symbols
        symbolView1.connectedFromProcessSymbolID=[NSNumber numberWithInt:symbolView2.tagSymbol.integerValue];
        symbolView2.connectedToProcessSymbolID=[NSNumber numberWithInt:symbolView1.tagSymbol.integerValue];
        
        if(symbolView2.connectedFromProcessSymbolID == 0)
            symbolView2.connectedFromProcessSymbolID=NULL;
        
        if(symbolView1.connectedToProcessSymbolID == 0)
            symbolView1.connectedToProcessSymbolID=NULL;
        
        
    }
    
    //Releasing the push Symbol
    //[pushArrowSymbol release];
    
    
    //Adding Inventory Symbol only for Push-arrow-symbol.png
    if([arrowImageName isEqualToString:@"push-symbols"])
    {
        //Adding Inventory symbol along with the Current Push Arrow
        VSMaterialSymbol *materialSymbol=[[VSDrawingManager sharedDrawingManager] createMaterialSymbolWithName:@"inventory" andID:[NSNumber numberWithInt:6]];
        [materialSymbol addTextFieldToInventorySymbol];
        [appDelegate.detailViewController.detailItem addSubview:materialSymbol];
        
        materialSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight+3);
        materialSymbol.center=CGPointMake(pushArrowSymbol.center.x, pushArrowSymbol.center.y);
        materialSymbol.textField.center=CGPointMake(materialSymbol.center.x, materialSymbol.center.y-10);
        
        materialSymbol.isFirstTouchOnSymbol=NO;
        
        
        
        materialSymbol.textField.frame=CGRectMake(5, materialSymbol.frame.size.height-20, materialSymbol.frame.size.width-18, 20);
        
        
        materialSymbol.textField.center=CGPointMake(materialSymbol.frame.size.width/2,materialSymbol.frame.size.height/2+25);
        
        
        
        
        pushArrowSymbol.inventoryObjectReference=[materialSymbol retain];
        [pushArrowSymbol.inventoryObjectReference saveSymbolState];
        [materialSymbol release];
        [pushArrowSymbol.inventoryObjectReference saveSymbolState];
        
        
    }
    else
    {
        pushArrowSymbol.inventoryObjectReference = nil;
    }
    
    
    [symbolView1 saveSymbolState];
    [symbolView2 saveSymbolState];
    
    
    
    
    
    
    //Setting the Parameters to Nil
    previousSymbolView=nil;
    newSymbol=nil;
    
    
}

-(void)addingArrowBetweenSymbolView:(VSSymbols*)symbolView1 andSymbolView:(VSSymbols*)symbolView2 andPushSymbol:(VSPushArrowSymbol*)pushArrowSymbol andMaterialSymbol:(VSMaterialSymbol*)materialSymbol andCustomerSupplierSymbol:(BOOL)isCustomer
{
    
    NSArray *arrayWithPoints=[[VSDrawingManager sharedDrawingManager] findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:symbolView2 andCurrenProcessSymbol:symbolView1 withCustomerSupplierSymbol:isCustomer];
    
    NSValue *val = [arrayWithPoints objectAtIndex:0];
    CGPoint point1 = [val CGPointValue];
    
    NSValue *val2 = [arrayWithPoints objectAtIndex:1];
    CGPoint point2 = [val2 CGPointValue];
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    [pushArrowSymbol adjustingWidthOfSymbolWithPoint:point1 andPoint:point2];
    [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:point2];
    pushArrowSymbol.image=[UIImage imageNamed:pushArrowSymbol.imageColorFileName];
    
    pushArrowSymbol.startingPoint=point2;
    pushArrowSymbol.endingPoint=point1;
    
    [appDelegate.detailViewController.detailItem addSubview:pushArrowSymbol];
    
    
    VSProcessSymbol*newSymbol=(VSProcessSymbol*)symbolView1;
    //For handling case where The current symbol might be Customer/Supplier, Databox Controller property needs not to be checked
    if(isCustomer == NO)
    {
        //Adding Push Arrow as an incoming arrow to the Current Process Box
        if(newSymbol.isDataBoxIndependant == NO)
            [newSymbol.incomingArrows addObject:pushArrowSymbol];
        else if(newSymbol.isDataBoxIndependant == YES)
            [newSymbol.dataBoxController.incomingArrows addObject:pushArrowSymbol];
    }
    
    else
    {
        [newSymbol.incomingArrows addObject:pushArrowSymbol];
        
    }
    
    VSProcessSymbol *previousSymbolView=(VSProcessSymbol*)symbolView2;
    
    //For handling case where The current symbol might be Customer/Supplier, Databox Controller property needs not to be checked
    if(isCustomer == NO)
    {
        //Adding Push arrow as an outgoing arrow to Previous Process Box
        if(previousSymbolView.isDataBoxIndependant == NO)
            [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
        
        else if (previousSymbolView.isDataBoxIndependant == YES)
        {
            [previousSymbolView.dataBoxController.outgoingArrows addObject:pushArrowSymbol];
        }
        
    }
    
    else
    {
        [previousSymbolView.outgoingArrows addObject:pushArrowSymbol];
        
    }
    
    //Setting the Two IDs for connecting Process Symbols
    newSymbol.connectedFromProcessSymbolID=symbolView1.ID;
    previousSymbolView.connectedToProcessSymbolID=symbolView2.ID;
    
    
    //Releasing the push Symbol
    [pushArrowSymbol release];
    
    
    //Adding Inventory Symbol only for Push-arrow-symbol.png
    //if([arrowImageName isEqualToString:@"push-arrow"])
    // {
    //Adding Inventory symbol along with the Current Push Arrow
    
    [appDelegate.detailViewController.detailItem addSubview:materialSymbol];
    
    materialSymbol.frame=CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
    materialSymbol.center=CGPointMake(pushArrowSymbol.center.x, pushArrowSymbol.center.y);
    
    materialSymbol.isFirstTouchOnSymbol=NO;
    
    
    
    materialSymbol.textField.frame=CGRectMake(5, materialSymbol.frame.size.height-20, materialSymbol.frame.size.width-18, 20);
    
    
    materialSymbol.textField.center=CGPointMake(materialSymbol.frame.size.width/2,materialSymbol.frame.size.height/2+25);
    
    
    
    
    pushArrowSymbol.inventoryObjectReference=[materialSymbol retain];
    [materialSymbol release];
    // }
    
}

-(void)adjustTheBoundsOfTheTextViewInInventorySymbol:(VSSymbols*)symbol
{
    VSMaterialSymbol *materialSymbol=(VSMaterialSymbol*)symbol;
    
    materialSymbol.textField.frame=CGRectMake(materialSymbol.textField.frame.origin.x, materialSymbol.textField.frame.origin.y, materialSymbol.bounds.size.width, materialSymbol.bounds.size.height-200);
}
//The following function finds shortest distance between two points for the given Symbol and previous Symbol
-(NSArray*)findingShortestConnectingPointsBetweenNewSymbolAndOldSymbol:(VSSymbols*)oldProcessSymbolView andCurrenProcessSymbol:(VSProcessSymbol*)symbolView withCustomerSupplierSymbol:(BOOL)isCustomer{
    //////----FOR OLD PROCESS SYMBOL----///////
    //Getting left Postion Coordinate
    float leftPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height/2;
    float leftPositionX=oldProcessSymbolView.frame.origin.x;
    CGPoint leftPositionPoint=CGPointMake(leftPositionX, leftPositionY);
    
    //Getting the Right Position Coordinte
    float rightPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height/2;
    float rightPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width;
    CGPoint rightPositionPoint=CGPointMake(rightPositionX, rightPositionY);
    
    //Getting the Top Position Coordinate
    float topPositionY=oldProcessSymbolView.frame.origin.y;
    float topPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width/2;
    CGPoint topPositionPoint=CGPointMake(topPositionX, topPositionY);
    
    //Getting the Bottom Position Coordinate
    float bottomPositionY=oldProcessSymbolView.frame.origin.y+oldProcessSymbolView.frame.size.height;
    float bottomPositionX=oldProcessSymbolView.frame.origin.x+oldProcessSymbolView.frame.size.width/2;
    
    CGPoint bottomPositionPoint=CGPointMake(bottomPositionX, bottomPositionY);
    
    
    /////----FOR NEW CURRENT PROCESS SYMBOL----//////
    //Getting left Postion Coordinate
    [self findingNewPointsOfSymbolView:symbolView];
    
    
    //Finding Distance Between Top Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber*  distanceBetweenLeftPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber*  distanceBetweenRightPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber*  distanceBetweenBottomPointTop=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromTopPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointTop,distanceBetweenLeftPointTop,distanceBetweenRightPointTop,distanceBetweenTopPointTop,nil]];
    
    //Finding Distance Between Bottom Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointBottom=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromBottomPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointBottom,distanceBetweenLeftPointBottom,distanceBetweenRightPointBottom,distanceBetweenTopPointBottom,nil]];
    
    //Finding Distance Between Left Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointLeft=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromLeftPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointLeft,distanceBetweenLeftPointLeft,distanceBetweenRightPointLeft,distanceBetweenTopPointLeft,nil]];
    
    //Finding Distance Between Right Position of Current View and Previous Symbol View
    NSNumber* distanceBetweenTopPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:topPositionPoint];
    NSNumber* distanceBetweenLeftPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:leftPositionPoint];
    NSNumber* distanceBetweenRightPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:rightPositionPoint];
    NSNumber* distanceBetweenBottomPointRight=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:bottomPositionPoint];
    
    NSNumber* shortestDistanceFromRightPoint=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenBottomPointRight,distanceBetweenLeftPointRight,distanceBetweenRightPointRight,distanceBetweenTopPointRight,nil]];
    
    
    //Shorest Distance between all above 4 calculated points
    NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:shortestDistanceFromTopPoint,shortestDistanceFromBottomPoint,shortestDistanceFromLeftPoint,shortestDistanceFromRightPoint, nil]];
    
    CGPoint point1;
    CGPoint point2;
    
    //shortest Distance from Top point
    if([shortestDistance isEqualToNumber:shortestDistanceFromTopPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointTop])
        {
            point1=symbolView.topNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
        
    }//Check for top position point ends here
    
    
    //Bottom point comparison starts
    else if([shortestDistance isEqualToNumber:shortestDistanceFromBottomPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointBottom])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//bottom point comparison ends here
    
    //Left point comparison ends here
    else if([shortestDistance isEqualToNumber:shortestDistanceFromLeftPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointLeft])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//left point comparison ends here
    
    //right point comparison ends here
    else if([shortestDistance isEqualToNumber:shortestDistanceFromRightPoint])
    {
        if([shortestDistance isEqualToNumber:distanceBetweenTopPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=topPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=leftPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=rightPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPointRight])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
            point2=bottomPositionPoint;
        }
    }//left point comparison ends here
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],nil];
    
}
//The following function updates the location of the Symbol View after it has been moved
-(void)findingNewPointsOfSymbolView:(VSProcessSymbol*)symbolView
{
    float leftNewSymbolPositionY=symbolView.frame.origin.y+symbolView.frame.size.height/2;
    float leftNewSymbolPositionX=symbolView.frame.origin.x;
    symbolView.leftNewSymbolPositionPoint=CGPointMake(leftNewSymbolPositionX, leftNewSymbolPositionY);
    
    //Getting the Right Position Coordinte
    float rightNewSymbolPositionY=symbolView.frame.origin.y+symbolView.frame.size.height/2;
    float rightNewSymbolPositionX=symbolView.frame.origin.x+symbolView.frame.size.width;
    symbolView.rightNewSymbolPositionPoint=CGPointMake(rightNewSymbolPositionX, rightNewSymbolPositionY);
    
    //Getting the Top Position Coordinate
    float topNewSymbolPositionY=symbolView.frame.origin.y;
    float topNewSymbolPositionX=symbolView.frame.origin.x+symbolView.frame.size.width/2;
    symbolView.topNewSymbolPositionPoint=CGPointMake(topNewSymbolPositionX, topNewSymbolPositionY);
    
    //Getting the Bottom Position Coordinate
    float bottomNewSymbolPositionY=symbolView.frame.origin.y+symbolView.frame.size.height;
    float bottomNewSymbolPositionX=symbolView.frame.origin.x+symbolView.frame.size.width/2;
    symbolView.bottomNewSymbolPositionPoint=CGPointMake(bottomNewSymbolPositionX, bottomNewSymbolPositionY);
}

//The following function adjusts the position of all OutGoing Arrows from the Given Symbol View
-(void)adjustOutGoingArrowsConnectedToSymbolView:(VSSymbols*)symbolView
{
    int numberOfArrows=[symbolView.outgoingArrows count];
    
    for(int i=0; i < numberOfArrows; i++)
    {
        VSPushArrowSymbol *pushArrowSymbol=[symbolView.outgoingArrows objectAtIndex:i];
        
        //Finding the new center of position of each side of symbol,after it has been moved
        [self findingNewPointsOfSymbolView:symbolView];
        CGPoint point1;
        
        NSNumber* distanceBetweenTopPoint=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenLeftPoint=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenRightPoint=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        NSNumber* distanceBetweenBottomPoint=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:pushArrowSymbol.endingPoint];
        
        //Shorest Distance between all above 4 calculated points
        NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenTopPoint,distanceBetweenLeftPoint,distanceBetweenRightPoint,distanceBetweenBottomPoint, nil]];
        
        
        if([shortestDistance isEqualToNumber:distanceBetweenTopPoint])
        {
            point1=symbolView.topNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPoint])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPoint])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPoint])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
        }
        
        
        pushArrowSymbol.startingPoint=point1;
        
        [pushArrowSymbol applyRotationToSymbolWithPoint:pushArrowSymbol.endingPoint andPoint:point1];
        [pushArrowSymbol adjustingWidthOfSymbolWithPoint:pushArrowSymbol.endingPoint andPoint:point1];
        
        
        if(pushArrowSymbol.inventoryObjectReference!=nil)
            [self adjustInventorySymbolOnPushArrowSymbol:pushArrowSymbol];
        
        
    }
}
//The following function adjusts the position of all Incoming Arrows from the Given Symbol View
-(void)adjustIncomingArrowsConnectedToSymbolView:(VSSymbols*)symbolView
{
    int numberOfArrows=[symbolView.incomingArrows count];
    
    for(int i=0; i < numberOfArrows; i++)
    {
        VSPushArrowSymbol *pushArrowSymbol=[symbolView.incomingArrows objectAtIndex:i];
        
        //Finding the new center of position of each side of symbol,after it has been moved
        [self findingNewPointsOfSymbolView:symbolView];
        CGPoint point1;
        
        NSNumber* distanceBetweenTopPoint=[VSUtilities distanceBetweenPoint:symbolView.topNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenLeftPoint=[VSUtilities distanceBetweenPoint:symbolView.leftNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenRightPoint=[VSUtilities distanceBetweenPoint:symbolView.rightNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        NSNumber* distanceBetweenBottomPoint=[VSUtilities distanceBetweenPoint:symbolView.bottomNewSymbolPositionPoint andPoint:pushArrowSymbol.startingPoint];
        
        //Shorest Distance between all above 4 calculated points
        NSNumber* shortestDistance=[VSUtilities findingShortestDistanceBetween:[NSArray arrayWithObjects:distanceBetweenTopPoint,distanceBetweenLeftPoint,distanceBetweenRightPoint,distanceBetweenBottomPoint, nil]];
        
        
        if([shortestDistance isEqualToNumber:distanceBetweenTopPoint])
        {
            point1=symbolView.topNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenLeftPoint])
        {
            point1=symbolView.leftNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenRightPoint])
        {
            point1=symbolView.rightNewSymbolPositionPoint;
        }
        
        else if([shortestDistance isEqualToNumber:distanceBetweenBottomPoint])
        {
            point1=symbolView.bottomNewSymbolPositionPoint;
        }
        //The new starting point,based on the new position of the moved symbol
        
        
        
        pushArrowSymbol.endingPoint=point1;
        
        [pushArrowSymbol applyRotationToSymbolWithPoint:point1 andPoint:pushArrowSymbol.startingPoint];
        [pushArrowSymbol adjustingWidthOfSymbolWithPoint:pushArrowSymbol.startingPoint andPoint:point1];
        
        
        if(pushArrowSymbol.inventoryObjectReference!=nil)
            [self adjustInventorySymbolOnPushArrowSymbol:pushArrowSymbol];
        
    }
}

//The following method adjust the position and frame of the Inventory Symbol added onto the given Push Arrow Symboo
-(void)adjustInventorySymbolOnPushArrowSymbol:(VSSymbols*)pushArrowSymbol
{
    VSPushArrowSymbol *pushArrow=(VSPushArrowSymbol*)pushArrowSymbol;
    
    //UIImage *tmpImage=[VSUtilities imageWithImage:pushArrow.inventoryObjectReference.image scaledToWidth:pushArrowSymbol.frame.size.width-75];
    //pushArrow.inventoryObjectReference.frame=CGRectMake(0, 0, pushArrowSymbol.frame.size.width-75, tmpImage.size.height);
    //[tmpImage release];
    pushArrow.inventoryObjectReference.center=CGPointMake(pushArrowSymbol.center.x, pushArrowSymbol.center.y);
    
    
    
    //pushArrow.inventoryObjectReference.autoresizesSubviews=YES;
    //[self adjustTheBoundsOfTheTextViewInInventorySymbol:pushArrow.inventoryObjectReference];
    
}

#pragma mark - Automatic Time Line Generation Method
-(void)adjustHeadAndTailTimeLinePositionWithProcessSymbol:(VSProcessSymbol*)processSymbol
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    VSTimeLineHeadViewController*timeLineHeadController=[self.arrayOfTimeLine objectAtIndex:0];
    /*if(CGRectGetMaxX(timeLineHeadController.view.frame) < kHeadTimelineLeftEdgePositionX-250)
     
     {*/
    
    
    if([self.arrayOfTimeLine count] == 3 && [VSDrawingManager sharedDrawingManager].isTailPresent ==YES)
    {
        
        timeLineHeadController.view.frame=CGRectMake(processSymbol.frame.origin.x+(processSymbol.frame.size.width*2),appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-17 ,kDefaultTimeLineWidth, kDefaultTimeLineHeight+20);
        
        processSymbol.timeLineRefernce.view.frame=CGRectMake(timeLineHeadController.view.frame.origin.x-timeLineHeadController.view.frame.size.width+13,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
        

        processSymbol.timeLineTailReference.view.frame=CGRectMake(processSymbol.timeLineRefernce.view.frame.origin.x-processSymbol.timeLineRefernce.view.frame.size.width+93,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineTailWidth, kDefaulttimeLineTailHeight);
        
    }
    
    else if([self.arrayOfTimeLine count] <=2)
    {
        
        timeLineHeadController.view.frame=CGRectMake(processSymbol.frame.origin.x+(processSymbol.frame.size.width*2),appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-17 ,kDefaultTimeLineWidth, kDefaultTimeLineHeight+20);
        
        //adjusting the last part of the tail(non-value)
        
        // tailTimeLineController.view.frame=CGRectMake(CGRectGetMinX(timeLineHeadController.view.frame)-113-85,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
        processSymbol.timeLineRefernce.view.frame=CGRectMake(processSymbol.frame.origin.x,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
    }
    
    //}
}
//the following method adds the time line head & tail to the current Detail View controller
-(VSTimeLineHeadViewController*)addingHeadAndTimeLineControllerOnSymbol:(VSSymbols*)symbol
{
    
    VSProcessSymbol *processSymbol=(VSProcessSymbol*)symbol;
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //Incase where the Head Time Line doesnt Exists
    
    //Adding a Time Line Head Controller
    VSTimeLineHeadViewController *timelineHeadController=[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil];
    timelineHeadController.isTail=NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isTimeLineHeadAdded"];
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)timelineHeadController.view];
    
    timelineHeadController.tagForSymbol= processSymbol.tagSymbol;
    
    //Keeping the refernce of the Head of Time Line with the Drawing Manager
    [VSDrawingManager sharedDrawingManager].headTimeLineController=timelineHeadController;
    
    
    if(self.arrayOfTimeLine == nil)
        arrayOfTimeLine_=[[NSMutableArray alloc] init];
    
    [self.arrayOfTimeLine addObject:timelineHeadController];
    
    [timelineHeadController release];
    
    
    //Adding a tag to it Which Indicates that it is the Time Line Head Controller
    timelineHeadController.view.tag=kTagForHeadTimeLine;
    
    //       timelineHeadController.view.frame=CGRectMake(appDelegate.detailViewController.view.frame.origin.x+appDelegate.detailViewController.view.frame.size.width+kDefaultOffsetTimeLinePositionX,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-17 ,kDefaultTimeLineWidth, kDefaultTimeLineHeight+20);
    
    timelineHeadController.view.frame=CGRectMake(symbol.frame.origin.x+(symbol.frame.size.width*2),appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-17 ,kDefaultTimeLineWidth, kDefaultTimeLineHeight+20);
    
    
    //Adding a Tail Time Line to it
    VSTimeLineHeadViewController *timeLineTailController=[[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil] autorelease];
    timeLineTailController.isTail=YES;
    
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)timeLineTailController.view];
    
    timeLineTailController.view.frame=CGRectMake(timelineHeadController.view.frame.origin.x-timeLineTailController.view.frame.size.width+13,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineWidth, kDefaultTimeLineHeight+50);
    timeLineTailController.tagForSymbol=processSymbol.tagSymbol;
    
    
    //Adding the Last tail
    VSTimeLineHeadViewController *timeLineTailController2=[[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil] autorelease];
    timeLineTailController2.isTail=NO;
    timeLineTailController2.isNonValueAddedTail=YES;
    timeLineTailController2.tagForSymbol=processSymbol.tagSymbol;
    
    
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)timeLineTailController2.view];
    
    timeLineTailController2.view.frame=CGRectMake(timeLineTailController.view.frame.origin.x-timeLineTailController.view.frame.size.width+93,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineTailWidth, kDefaulttimeLineTailHeight);
    
    processSymbol.timeLineTailReference=timeLineTailController2;
    
    
    //tail is added before the Time line itself
    [self.arrayOfTimeLine addObject:timeLineTailController2];
    [self.arrayOfTimeLine addObject:timeLineTailController];
    
    [VSDrawingManager sharedDrawingManager].isTailPresent=YES;
    
    self.numberOfTimeLines=1;
    return timeLineTailController;
}

//The following methods adds a Tail Timeline to the Existing Timeline
-(VSTimeLineHeadViewController*)addingTailTimeLineControllerToProcessSymbol:(VSSymbols*)symbol
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //Adding a Tail Time Line to it
    VSTimeLineHeadViewController *timeLineTailController=[[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil] autorelease];
    timeLineTailController.isTail=YES;
    [appDelegate.detailViewController.detailItem addSubview:(UIView*)timeLineTailController.view];
    
    
    timeLineTailController.tagForSymbol=symbol.tagSymbol;
    
    //Getting the Last Added Tail Time Line added to the timeline
    NSArray *reverseArray=[[[VSDrawingManager sharedDrawingManager].arrayOfTimeLine  reverseObjectEnumerator] allObjects];
    
    
    
    
    //This is to make sure that it executed when there are 2 timeline controllers,One Head and other Tail timeline
    if([reverseArray count] >= 1)
    {
        for(UIViewController *tmpController in reverseArray)
        {
            if([tmpController isKindOfClass:[VSTimeLineHeadViewController class]])
            {
                //To handle the case where only the head time line exists
                if([reverseArray count] == 1)
                {
                    timeLineTailController.view.frame=CGRectMake([VSDrawingManager sharedDrawingManager].headTimeLineController.view.frame.origin.x-[VSDrawingManager sharedDrawingManager].headTimeLineController.view.frame.size.width-3, [VSDrawingManager sharedDrawingManager].headTimeLineController.view.frame.origin.y-8, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                }
                
                //Else to be places at the exact position of the previous Time line
                else
                {
                    timeLineTailController.view.frame=CGRectMake(tmpController.view.frame.origin.x, tmpController.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                }
                //timeLineTailController.view.frame=CGRectMake(tmpController.view.frame.origin.x,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-35, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                break;
            }
        }
    }
    
    [self.arrayOfTimeLine addObject:timeLineTailController];
    
    
    //Adjust Timeline only if there are more than 2 timelines, since this 2 include the head and a tail already
    // if([reverseArray count] > 2)
    [self adjustingFrameOfTimeLines];
    
    return timeLineTailController;
}

//The following adjust time lines when the Head controller reaches the left edge of the
-(void)adjustingFrameOfTimeLines
{
    //This excludes the recently added Time Line Controller,since its Frame is already adjusted
    int numberOfTmpControllers=[self.arrayOfTimeLine count];
    
    VSTimeLineHeadViewController *tmpController=[self.arrayOfTimeLine objectAtIndex:0];
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CGRect rect=CGRectMake(tmpController.view.frame.origin.x+tmpController.view.frame
                           .size.width, tmpController.view.frame.origin.y, tmpController.view.frame.size.width, tmpController.view.frame.size.height);
    
    //To check whether the Head has reached the Bottom right Edge of the Detail View
    if(CGRectGetMaxX(rect) > kHeadTimelineLeftEdgePositionX)
    {
        
        for(int i=3; i <=numberOfTmpControllers;i++)
        {
            if(i==3)//&& CGRectGetMaxX(tmpController.view.frame) > kHeadTimelineLeftEdgePositionX-10)
            {
                
                NSLog(@"In first View controller");
                VSTimeLineHeadViewController *tmpController=[self.arrayOfTimeLine objectAtIndex:i-1];
                tmpController.view.frame=CGRectMake(tmpController.view.frame.origin.x-tmpController.view.frame.size.width, tmpController.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                
                VSTimeLineHeadViewController *tmpController2=[self.arrayOfTimeLine objectAtIndex:i-2];
                tmpController2.view.frame=CGRectMake(tmpController.view.frame.origin.x-tmpController.view.frame.size.width+93,appDelegate.detailViewController.view.frame.origin.y+appDelegate.detailViewController.view.frame.size.height-kDefaultOffsetTimelinePositionY-25, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                
            }
            
            else if(i!=3)
            {
                NSLog(@"In Second View Controller");
                
                VSTimeLineHeadViewController *headController=[self.arrayOfTimeLine objectAtIndex:0];
                VSTimeLineHeadViewController *tmpController=[self.arrayOfTimeLine objectAtIndex:i-1];
                VSTimeLineHeadViewController *tmpController2=[self.arrayOfTimeLine objectAtIndex:i-2];
                
                headController.view.frame=CGRectMake(appDelegate.detailViewController.view.frame.origin.x+appDelegate.detailViewController.view.frame.size.width+kDefaultOffsetTimeLinePositionX-140,headController.view.frame.origin.y,headController.view.frame.size.width,headController.view.frame.size.height);
                
                tmpController.view.frame=CGRectMake(CGRectGetMaxX(tmpController2.view.frame)-7, tmpController.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
            }
        }
        
    }
    
    
    else if([self.arrayOfTimeLine count] != 2 )
    {
        //Adjusting The latest Added Controller
        VSTimeLineHeadViewController *headController=[self.arrayOfTimeLine objectAtIndex:0];
        VSTimeLineHeadViewController *latestController=[self.arrayOfTimeLine objectAtIndex:numberOfTmpControllers-1];
        VSTimeLineHeadViewController *secondLastController=[self.arrayOfTimeLine objectAtIndex:numberOfTmpControllers-2];
        
        headController.view.frame=CGRectMake(CGRectGetMaxX(secondLastController.view.frame)+secondLastController.view.frame.size.width+kDefaultPreceedingTimeLifeOffsetX-30, headController.view.frame.origin.y, headController.view.frame.size.width, headController.view.frame.size.height);
        
        latestController.view.frame=CGRectMake(CGRectGetMaxX(secondLastController.view.frame)-7, latestController.view.frame.origin.y, latestController.view.frame.size.width, latestController.view.frame.size.height);
        
    }
    
}
-(void)updateTimeOnHeadTimeLine
{
    int numberOfTailTimeLines=[[VSDrawingManager sharedDrawingManager].arrayOfTimeLine count];
    
    int valueAddedTotalTimeHours=0;
    int valueAddedTotalTimeMins=0;
    int valueAddedTotalTimeSecs=0;
    
    int nonValueAddedTotalTimeHours=0;
    int nonValueAddedTotalTimeMins=0;
    int nonValueAddedTotalTimeSecs=0;
    
    
    
    for(int i=0; i < numberOfTailTimeLines ;i++)
    {
        
        VSTimeLineHeadViewController *timeLineController=(VSTimeLineHeadViewController*)[self.arrayOfTimeLine objectAtIndex:i];
        
        //For Value added Part
        valueAddedTotalTimeHours=valueAddedTotalTimeHours+timeLineController.hoursValueAdded.text.integerValue;
        valueAddedTotalTimeMins=valueAddedTotalTimeMins+timeLineController.minsValueAdded.text.integerValue;
        valueAddedTotalTimeSecs=valueAddedTotalTimeSecs+timeLineController.secsValueAdded.text.integerValue;
        
        float remainderMins=valueAddedTotalTimeMins / 60;
        
        if(remainderMins >= 0 && valueAddedTotalTimeMins > 0)
        {
            while(remainderMins >= 0)
            {
                if(remainderMins == 0)
                    break;
                
                valueAddedTotalTimeHours=valueAddedTotalTimeHours+1;
                valueAddedTotalTimeMins=valueAddedTotalTimeMins-60;
                remainderMins=valueAddedTotalTimeMins / 60;
            }
        }
        
        float remainderSecs=valueAddedTotalTimeSecs / 60;
        
        if(remainderSecs >= 0 && valueAddedTotalTimeSecs > 0)
        {
            while (remainderSecs >= 0)
            {
                if(remainderSecs == 0)
                    break;
                
                valueAddedTotalTimeMins=valueAddedTotalTimeMins+1;
                valueAddedTotalTimeSecs=valueAddedTotalTimeSecs-60;
                remainderSecs=valueAddedTotalTimeSecs / 60;
            }
        }
        
        
        //For Non-Value Added Part
        if(i==1)
        {
            nonValueAddedTotalTimeHours=nonValueAddedTotalTimeHours+timeLineController.tailHoursLabel.text.integerValue;
            nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins+timeLineController.tailMinutesLabel.text.integerValue;
            nonValueAddedTotalTimeSecs=nonValueAddedTotalTimeSecs+timeLineController.tailSecondsLabel.text.integerValue;
        }
        
        else
        {
            nonValueAddedTotalTimeHours=nonValueAddedTotalTimeHours+timeLineController.hoursNonValueAdded.text.integerValue;
            nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins+timeLineController.minsNonValueAdded.text.integerValue;
            nonValueAddedTotalTimeSecs=nonValueAddedTotalTimeSecs+timeLineController.secsNonValueAdded.text.integerValue;
        }
        
        remainderMins=nonValueAddedTotalTimeMins / 60;
        
        if(remainderMins >= 0 && nonValueAddedTotalTimeMins >0)
        {
            while (remainderMins >= 0) {
                
                if(remainderMins == 0)
                    break;
                
                nonValueAddedTotalTimeHours=nonValueAddedTotalTimeHours+1;
                nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins-60;
                remainderMins=nonValueAddedTotalTimeMins / 60;
                
            }
            
        }
        
        remainderSecs=nonValueAddedTotalTimeSecs / 60;
        
        if(remainderSecs >= 0 && nonValueAddedTotalTimeSecs > 0)
        {
            while (remainderSecs >= 0)
            {
                if(remainderSecs == 0)
                    break;
                
                nonValueAddedTotalTimeMins=nonValueAddedTotalTimeMins+1;
                nonValueAddedTotalTimeSecs=nonValueAddedTotalTimeSecs-60;
                remainderSecs=nonValueAddedTotalTimeSecs / 60;
                
                
            }
            
        }
        
        timeLineController=nil;
    }
    
    //if(self.isNonValueAddedTimePickerShown || self.isTailNonValueAddedTimePickerShow)
    //{
    
    [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadHoursLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeHours];
    
    [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadMinsLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeMins];
    
    [VSDrawingManager sharedDrawingManager].headTimeLineController.nonValueHeadSecsLabel.text=[NSString stringWithFormat:@"%d",nonValueAddedTotalTimeSecs];
    
    // }
    
    // else if (self.isValueAddedTimePickerShown)
    //{
    [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadHoursLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeHours];
    
    [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadMinsLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeMins];
    
    [VSDrawingManager sharedDrawingManager].headTimeLineController.valueHeadSecsLabel.text=[NSString stringWithFormat:@"%d",valueAddedTotalTimeSecs];
    // }
    
    
}

#pragma mark - Automatic Information flow Symbol
-(void)attachInformationFlowSymbolToProcessSymbol:(VSProcessSymbol*)processSymbol
{
    
}

#pragma mark - Custom Method For Force Movement
-(void)forceCallSymbolMoveOnProcessSymbol
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //[VSDrawingManager sharedDrawingManager].isParsing=YES;
    
    NSLog(@"Count %d",[[appDelegate.detailViewController.detailItem subviews] count]);
    if([[appDelegate.detailViewController.detailItem subviews] count]>7)
        
    {
        if([VSDrawingManager sharedDrawingManager].lastProcessBox != nil)
            [appDelegate.detailViewController.detailItem bringSubviewToFront:[VSDrawingManager sharedDrawingManager].lastProcessBox];
        
    }
    /*
     for(UIView * view in [appDelegate.detailViewController.detailItem subviews])
     {
     if([view isKindOfClass:[VSProcessSymbol class]])
     {
     VSProcessSymbol *processSymbol=(VSProcessSymbol*)view;
     
     if(processSymbol.ID.integerValue == [VSDrawingManager sharedDrawingManager].lastProcessBox.ID.integerValue)
     {
     [appDelegate.detailViewController.detailItem bringSubviewToFront:processSymbol];
     NSLog(@"match found");
     }
     
     
     //[processSymbol moveSymbol:nil];
     }
     }
     */
    
    // [VSDrawingManager sharedDrawingManager].isParsing=NO;
    
    
}
#pragma mark - Removing Time Line attached to Process Symbol
//the following function removes all instances of the time Lines attached to the given Symbol View
-(void)removeTimeLineFromViewAttachedToProcessSymbol:(VSSymbols*)symbolView
{
    VSProcessSymbol *processSymbol=(VSProcessSymbol*)symbolView;
    
    int numberOfTimeLineObjects=[self.arrayOfTimeLine count];
    
    VSTimeLineHeadViewController *timelineController;
    BOOL tailRemoved=NO;
    
    for(int i=0; i <numberOfTimeLineObjects ; i++)
    {
        timelineController=[self.arrayOfTimeLine objectAtIndex:i];
        //To find the Given Time Line(attached to the symbol) in the Time Line Array of VSDrawingManager
        if(processSymbol.timeLineRefernce == timelineController)
        {
            [self adjustFrameOfTimeLineAfterRemovingTimeLineController:processSymbol.timeLineRefernce foundAtIndex:i];
            [processSymbol.timeLineRefernce.view removeFromSuperview];
            
            //Removing al instances of Timeline Object from View and Drawing Manager Array
            VSTimeLineHeadViewController *timeLine=[self.arrayOfTimeLine objectAtIndex:i];
            [timeLine.view removeFromSuperview];
            
            //Removing the Tail reference if added
            if(processSymbol.timeLineTailReference != nil)
            {
                [processSymbol.timeLineTailReference.view removeFromSuperview];
                processSymbol.timeLineTailReference=nil;
                [self.arrayOfTimeLine removeObjectAtIndex:1];
                [VSDrawingManager sharedDrawingManager].isTailPresent=NO;
                tailRemoved=YES;
            }
            
            //            //removing the found Time Line object from the DrawingManagers Array
            //            [self.arrayOfTimeLine removeObjectAtIndex:i];
            
            NSLog(@"Removed");
            
            //Adjusting the Timeline if only head and tail exists
            VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            
            if([self.arrayOfTimeLine count] ==3)
            {
                for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
                {
                    
                    if([tmpView isKindOfClass:[VSProcessSymbol class]])
                    {
                        VSProcessSymbol *processSymbol=(VSProcessSymbol*)tmpView;
                        
                        if(processSymbol.connectedToProcessSymbolID == symbolView.connectedFromProcessSymbolID)
                        {
                            [[VSDrawingManager sharedDrawingManager] adjustHeadAndTailTimeLinePositionWithProcessSymbol:(VSProcessSymbol*)processSymbol];
                            
                        }
                        
                        else if(processSymbol.connectedFromProcessSymbolID == symbolView.connectedToProcessSymbolID)
                        {
                            [[VSDrawingManager sharedDrawingManager] adjustHeadAndTailTimeLinePositionWithProcessSymbol:(VSProcessSymbol*)processSymbol];
                        }
                        
                    }
                    
                    
                }
                
            }
            //removing the found Time Line object from the DrawingManagers Array
            
            if(tailRemoved)
            {
                [self.arrayOfTimeLine removeObjectAtIndex:i-1];
                
            }
            else
            {
                [self.arrayOfTimeLine removeObjectAtIndex:i];
            }
            
            
            break;
        }
    }
    
    
}

//The following method adjusts the position of the Time
-(void)adjustFrameOfTimeLineAfterRemovingTimeLineController:(VSTimeLineHeadViewController*)timeLineController foundAtIndex:(int)index
{
    
    
    int countOfTimeLine=[self.arrayOfTimeLine count];

    //setting the position of the Head controller right next to the last added time line controller
    VSTimeLineHeadViewController *headController=[self.arrayOfTimeLine objectAtIndex:0];
    //VSTimeLineHeadViewController *lastTimeController=[self.arrayOfTimeLine objectAtIndex:countOfTimeLine-2];
    if(timeLineController == [self.arrayOfTimeLine lastObject])
    {
        headController.view.frame=CGRectMake(CGRectGetMinX(timeLineController.view.frame), headController.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
    }
    
    else if(index >=2)
    {
        CGPoint previousLocation;
        for(int i =index ; i < countOfTimeLine-1; i++)
        {
            @synchronized(self.arrayOfTimeLine)
            {
                VSTimeLineHeadViewController *nextTimeLine=[self.arrayOfTimeLine objectAtIndex:i+1];
                VSTimeLineHeadViewController *previousTimeLine=[self.arrayOfTimeLine objectAtIndex:i];
                
                //Preserving the Old positiong before setting the new position
                nextTimeLine.previousLocation=CGPointMake(nextTimeLine.view.frame.origin.x, nextTimeLine.view.frame.origin.y);
                
                if(previousTimeLine == timeLineController)
                {
                    nextTimeLine.view.frame=CGRectMake(previousTimeLine.view.frame.origin.x, previousTimeLine.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                    //Storing the old location of nextTimelineController before changing it
                    previousLocation=CGPointMake(nextTimeLine.view.frame.origin.x,nextTimeLine.view.frame.origin.y);
                    
                }
                
                else
                {
                    nextTimeLine.view.frame=CGRectMake(previousTimeLine.previousLocation.x, previousTimeLine.previousLocation.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
                    
                }
                
                
            }
        }
        
        VSTimeLineHeadViewController *headController=[self.arrayOfTimeLine objectAtIndex:0];
        VSTimeLineHeadViewController *lastController=[self.arrayOfTimeLine lastObject];
        
        headController.view.frame=CGRectMake(CGRectGetMaxX(lastController.view.frame), headController.view.frame.origin.y, kDefaultTimeLineWidth, kDefaultTimeLineHeight);
    }
    
    
    
}
- (void)dealloc {
    [arrayOfTimeLine_ release];
    [super dealloc];
}
@end
