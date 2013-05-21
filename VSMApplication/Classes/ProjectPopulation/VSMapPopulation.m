//
//  VSMapPopulation.m
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import "VSMapPopulation.h"
#import "VSMAPPAppDelegate.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "VSDataManager.h"
#import "VSProcessSymbol.h"
#import "VSMaterialSymbol.h"
#import "DetailViewController.h"
#import "VSGeneralSymbol.h"
#import "VSDrawingManager.h"
#import "VSInfoSymbol.h"
#import "VSExtendedSymbol.h"
#import "VSSymbols.h"
#import "VSPushArrowSymbol.h"
#import "VSTimeLineHeadViewController.h"
#import "VSCustomImageSymbol.h"
#define kDefaultHeightOfTexField 20


@interface VSMapPopulation()
{
    VSProcessSymbol *supplierSymbol_;
    VSProcessSymbol *customerSymbol_;
    NSString *stringProcessInCustomerID_;
    NSString *stringProcessInSupplierID_;
    NSDictionary *dictionaryProcessSymbol_;
}

@property(assign, nonatomic) VSProcessSymbol *supplierSymbol;
@property(assign, nonatomic) VSProcessSymbol *customerSymbol;
@property(assign, nonatomic) NSString *stringProcessInCustomerID;
@property(retain, nonatomic) NSString *stringProcessInSupplierID;
@property(retain, nonatomic) NSDictionary *dictionaryProcessSymbol;

@end
@implementation VSMapPopulation
@synthesize supplierSymbol = supplierSymbol_;
@synthesize customerSymbol = customerSymbol_;
@synthesize stringProcessInCustomerID = stringProcessInCustomerID_;
@synthesize stringProcessInSupplierID = stringProcessInSupplierID_;
@synthesize dictionaryProcessSymbol = dictionaryProcessSymbol_;

-(void) settingDrawingPadForPopulation
{
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController setUpDrawingPadForProject];
}

-(void)openDictionaryWithJSON:(NSDictionary*)dictionary
{
    //[DataManager setCurrentProjectName:name];
    //self.stringProcessInSupplierID = nil;
    //self.stringProcessInCustomerID = nil;
    
    NSDictionary* dictionaryProject =dictionary; //[DataManager getProjectDictionaryForName:name];
    

    
    NSDictionary* dictionarySymbols = [dictionaryProject objectForKey:kSymbols];
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController setUpDrawingPadForProject];
    
    // [[VSDrawingManager sharedDrawingManager] destroyDrawManager];
    
    [[VSDrawingManager sharedDrawingManager] destroyDrawManager];
    [self setEmptyBools];
    
    [self setProjectBools:dictionaryProject];
    [VSDrawingManager sharedDrawingManager].isParsing = YES;
    [self createProcessSymbolsWithDictionary:[dictionarySymbols objectForKey:kProcessKey]];
    [self createMaterialSymbolsWithDictionary:[dictionarySymbols objectForKey:kMaterialKey]];
    [self createGeneralSymbolsWithDictionary:[dictionarySymbols objectForKey:kGeneralKey]];
    [self createExtendedSymbolsWithDictionary:[dictionarySymbols objectForKey:kExtendedKey]];
    [self createCustomSymbolsWithDictionary:[dictionarySymbols objectForKey:kCustomKey]];
    [self adjustArrowsInProcessBoxes:[dictionarySymbols objectForKey:kProcessKey]];
    self.dictionaryProcessSymbol = [dictionarySymbols objectForKey:kProcessKey];
    [self createInfoSymbolsWithDictionary:[dictionarySymbols objectForKey:kInfoKey]];
    [self createTimeLines:[dictionarySymbols objectForKey:kTimeLine]];
    //self.stringProcessInSupplierID = nil;
    //self.stringProcessInCustomerID = nil;
    
    [VSDrawingManager sharedDrawingManager].isParsing = NO;

}
-(void) openProjectWithName:(NSString*)name
{
    self.stringProcessInSupplierID = nil;
    self.stringProcessInCustomerID = nil;
    [DataManager setCurrentProjectName:name];
    
    
    
    
    NSDictionary* dictionaryProject = [DataManager getProjectDictionaryForName:name];
    
    NSDictionary* dictionarySymbols = [dictionaryProject objectForKey:kSymbols];
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    //   [appDelegate.rootViewController setUpDrawingPadForProject];
    
    [[VSDrawingManager sharedDrawingManager] destroyDrawManager];
    [self setEmptyBools];
    
    [self setProjectBools:dictionaryProject];
    
    [appDelegate.rootViewController setUpDrawingPadForProject];
    
    [VSDrawingManager sharedDrawingManager].isParsing = YES;
    
    [self createProcessSymbolsWithDictionary:[dictionarySymbols objectForKey:kProcessKey]];
    [self createMaterialSymbolsWithDictionary:[dictionarySymbols objectForKey:kMaterialKey]];
    [self createGeneralSymbolsWithDictionary:[dictionarySymbols objectForKey:kGeneralKey]];
    [self createExtendedSymbolsWithDictionary:[dictionarySymbols objectForKey:kExtendedKey]];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
        [self adjustArrowsInProcessBoxes:[dictionarySymbols objectForKey:kProcessKey]];
        self.dictionaryProcessSymbol = [dictionarySymbols objectForKey:kProcessKey];
    }
    
    [self createInfoSymbolsWithDictionary:[dictionarySymbols objectForKey:kInfoKey] ];
    [self createCustomSymbolsWithDictionary:[dictionarySymbols objectForKey:kCustomKey]];
    
    
    
    //[self setProjectBools:dictionaryProject];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
        [self createTimeLines:[dictionarySymbols objectForKey:kTimeLine]];
    }
    
    [VSDrawingManager sharedDrawingManager].isParsing = NO;
    
    
    //[VSMAPPAppDelegate sharedAppDelegate].rootViewController
}

-(void) setEmptyBools
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isAutomation"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
    //Setting the NSUserDefaults that need to be set to NO
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimeLineHeadAdded"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setProjectBools:(NSDictionary*)dictionaryProject
{
    NSString *string = [dictionaryProject objectForKey:kIsAutoProject];
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:kIsAutoProject];
    
    string = [dictionaryProject objectForKey:kIsSupplierAdded];
    
    if(string !=nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kIsSupplierAdded];
    }
    
    string = [dictionaryProject objectForKey:kIsCustomerAdded];
    
    if(string !=nil)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kIsCustomerAdded];
    }
    
    string = [dictionaryProject objectForKey:kIsProductionControlAdded];
    
    if(string !=nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kIsProductionControlAdded];
    }
    //Setting the NSUserDefaults that need to be set to NO
    string = [dictionaryProject objectForKey:kIsTimeLineHeadAdded];
    
    if(string !=nil)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kIsTimeLineHeadAdded];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Process Symbol
-(void) createProcessSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{

    
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSProcessSymbol *process;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        process = [[VSProcessSymbol alloc] initWithName:[dictionarySymbol objectForKey:kName] withTag:keyName andMetaDataID:[dictionarySymbol objectForKey:@"ID"]];
        
        [process.dataBoxController.view removeFromSuperview];
        process.dataBoxController = nil;
        
        process.processNameTextField.text = [dictionarySymbol objectForKey:kTextField1];
        process.processNumberTextField.text = [dictionarySymbol objectForKey:kTextField2];
        
        [appDelegate.detailViewController.detailItem addSubview:process];
        
        process.isFirstTouchOnSymbol = NO;
        
        process.ID = [dictionarySymbol objectForKey:@"ID"];
        
        process.name = [metaData objectForKey:kName];
        
        if([[metaData objectForKey:@"type"] integerValue] != 4)
        {
        process.bounds=CGRectMake(
                                   [[dictionarySymbol objectForKey:@"x"] floatValue],
                                   [[dictionarySymbol objectForKey:@"y"] floatValue],
                                   [[dictionarySymbol objectForKey:@"W"] floatValue],
                                   [[dictionarySymbol objectForKey:@"H"] floatValue]);
            [process setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
            [process setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
        }
        else
        {
            process.frame=CGRectMake(
                                      [[dictionarySymbol objectForKey:@"x"] floatValue],
                                      [[dictionarySymbol objectForKey:@"y"] floatValue],
                                      [[dictionarySymbol objectForKey:@"W"] floatValue],
                                      [[dictionarySymbol objectForKey:@"H"] floatValue]);
        }
        

       // process.dataBoxImageColorFileName=[dictionarySymbol objectForKey:kDataBoxImageColorFileName];
 
        
        
        NSMutableArray *arrayDataBox = [dictionarySymbol objectForKey:kDataBox];
        
        //if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
       // {
            
            // type 4 does not have databox
            if([[metaData objectForKey:@"type"] integerValue] != 4)
            {
                //process.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
                process.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
                
                    // in case there is no value in databox, a string is added while saving
                    if(arrayDataBox != nil && ![arrayDataBox isKindOfClass:[NSString class]])
                    {
                        //process.dataBoxController = nil;
                        [process addDataBox];
                        
                        // CGPoint newPoint =   [appDelegate.detailViewController.detailItem convertPoint:process.frame.origin toView:appDelegate.detailViewController.view];
                        process.dataBoxImageColorFileName=[dictionarySymbol objectForKey:kDataBoxImageColorFileName];
                        [process.dataBoxController populateDataBoxes:arrayDataBox];
                        [process.dataBoxController setColorOfDataBox];
                        
                        [process.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",process.dataBoxImageColorFileName]] forState:UIControlStateNormal];
                        
                        //[process adjustDataBoxWithPoint:process.frame.origin];
                        [process moveSymbol:nil];
                    }
                    // for adding databox only
                    else if([arrayDataBox isKindOfClass:[NSString class]] && process.dataBoxController == nil)
                    {
                        if([((NSString*)arrayDataBox) isEqualToString:kDataBox])
                        {
                            [process addDataBox];
                            //[process adjustDataBoxWithPoint:process.frame.origin];
                            [process moveSymbol:nil];
                            process.dataBoxImageColorFileName=[dictionarySymbol objectForKey:kDataBoxImageColorFileName];
                            [process.dataBoxController setColorOfDataBox];
                            
                            [process.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",process.dataBoxImageColorFileName]] forState:UIControlStateNormal];

                        }
                    }
                
                process.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];

            }
        
            else
            {
                process.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
                process.dataBoxImageColorFileName=[dictionarySymbol objectForKey:kDataBoxImageColorFileName];
                

                [process.dataBoxController.view removeFromSuperview];
                [process addDataBoxOnObjectCreation];
                
                [process.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",process.dataBoxImageColorFileName]] forState:UIControlStateNormal];
                [process.dataBoxController setColorOnDataBox:process];

                
                if(arrayDataBox != nil && ![arrayDataBox isKindOfClass:[NSString class]])
                {
                    [process.dataBoxController populateDataBoxes:arrayDataBox];
                    process.dataBoxImageColorFileName=[dictionarySymbol objectForKey:kDataBoxImageColorFileName]; 
                    [process.dataBoxController setColorOnDataBox:process];
                    
                    [process.dataBoxController.addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",process.dataBoxImageColorFileName]] forState:UIControlStateNormal];
                    
                }
                
            }
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
        {
            
            // for customer and supplier presence
            if([dictionarySymbol objectForKey:kIsSupplier])
            {
                
                self.stringProcessInSupplierID = keyName;//[dictionarySymbol objectForKey:kSupplierSymRef];
                
                //self.supplierSymbol = process;
                [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference = process;
                [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox = YES;
                
            }
            
            else if([dictionarySymbol objectForKey:kIsCustomer])
            {
                //self.customerSymbol = process;
                self.stringProcessInCustomerID = keyName;//[dictionarySymbol objectForKey:kCustomerSymRef];
                [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference = process;
                [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox = YES;
                [VSDrawingManager sharedDrawingManager].isPlacingProcessAfterParsing  = YES;
            }
            
        }
            if([[metaData objectForKey:kType] doubleValue] == 3)
            {
//                if([self isProcessSymbolLastForDictionary:dictionarySymbols andTag:process.tagSymbol] == YES)
//                {
//                    //process.isLastProcessBox = YES;
//                }
            }
            
            // [process moveSymbol:nil];
            
            process.dataBoxController.view.alpha = 1.0f;
  //      }
        
        [process release];
        
    }
    
   // [self setInstancesForProcessSymbol:dictionarySymbols];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomation"] isEqualToString:@"YES"])
    {
        [self setCustomerAndSupplier];
    }

    
}

-(void) setCustomerAndSupplier
{
    VSProcessSymbol *symbol;
    
    BOOL isFirst = YES;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    VSSymbols *supplier;
    if(self.stringProcessInSupplierID != nil)
    {
        supplier = [self getSymbolViewWithTag:self.stringProcessInSupplierID];
    }
    
    for(UIView *tmpView in [appDelegate.detailViewController.detailItem subviews])
    {
        if([tmpView isKindOfClass:[VSProcessSymbol class]])
        {
            symbol=(VSProcessSymbol*)tmpView;
            
            if(symbol.ID.integerValue != 1 && symbol.ID.integerValue != 4 && symbol.ID.integerValue != 43)
            {
                if(isFirst == YES)
                {
                    if(self.stringProcessInSupplierID != nil)
                    {
                        symbol.supplierSymbolReference = (VSProcessSymbol*)supplier;
                    }
                    isFirst = NO;
                }
                [appDelegate.detailViewController.detailItem bringSubviewToFront:symbol];
            }
        }
    }
    
    if(self.stringProcessInCustomerID != nil)
    {
        
        
        VSSymbols *customer = [self getSymbolViewWithTag:self.stringProcessInCustomerID];
        symbol.customerSymbolReference = (VSProcessSymbol*)customer;
    }
    
}

//-(void) createCustomerSymbolWithDictionary:(NSDictionary*) dictionary
//{
//    if(dictionary objectForKey:<#(id)#>)
//}
//
-(BOOL) isProcessSymbolFirstForDictionary:(NSDictionary*)dictionarySymbols andTag:(NSString*) comparedTag
{
    NSString *keyName;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    NSDictionary *dictionarySymbol;
    
    NSDictionary *metaData;
    
    NSNumber *type;
    
    double ID;
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        type = [metaData objectForKey:kType];
        
        if([type isEqualToNumber:[NSNumber numberWithInt:3]])
        {
            if([keyName isEqualToString:comparedTag])
            {
                return YES;
            }
        }
        
    }
    
    return NO;
}

-(BOOL) isProcessSymbolLastForDictionary:(NSDictionary*)dictionarySymbols  andTag:(NSString*) comparedTag
{
    NSString *keyName;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    NSDictionary *dictionarySymbol;
    
    NSDictionary *metaData;
    
    NSNumber *type;
    
    double ID;
    
    BOOL isLast;
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        type = [metaData objectForKey:kType];
        
        if([type isEqualToNumber:[NSNumber numberWithInt:3]])
        {
            if(isLast == YES)
            {
                return NO;
            }
            
            if([keyName isEqualToString:comparedTag])
            {
                isLast = YES;
            }
        }
        
    }
    
    return isLast;
}


-(void) setInstancesForProcessSymbol:(NSDictionary*) dictionarySymbols
{

    NSString *keyName;
    
    NSDictionary *dictionarySymbol;

    for(keyName in dictionarySymbols)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        //tag = [dictionarySymbol objectForKey:kSymbolTag];
    
        if([self isProcessSymbolLastForDictionary:dictionarySymbols andTag:keyName] == YES)
        {
            VSProcessSymbol *customer = (VSProcessSymbol*)[self getSymbolViewWithTag:self.stringProcessInCustomerID];
            
            VSProcessSymbol *lastProcessSymbol = (VSProcessSymbol*)[self getSymbolViewWithTag:keyName];
            
            lastProcessSymbol.customerSymbolReference = customer;
            
            return;
        }
        
        if([self isProcessSymbolFirstForDictionary:dictionarySymbols andTag:keyName] == YES)
        {
            
         //   tag = [dictionarySymbol objectForKey:kSymbolTag];
            
            if([self isProcessSymbolFirstForDictionary:dictionarySymbols andTag:keyName] == YES)
            {
                VSProcessSymbol *supplier = (VSProcessSymbol*)[self getSymbolViewWithTag:self.stringProcessInSupplierID];
                
                VSProcessSymbol *firstProcessSymbol = (VSProcessSymbol*)[self getSymbolViewWithTag:keyName];
                
                firstProcessSymbol.supplierSymbolReference = supplier;
                
                return;
            }
        }
        
    
        
        
    }
    
    
//    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    
//    NSArray* arraySubviews = [((UIView*)appDelegate.detailViewController.detailItem) subviews];
//    
//    UIView *view;
//    
//    VSProcessSymbol *process;
//    
//    for(view in arraySubviews)
//    {
//        if([view isKindOfClass:[VSProcessSymbol class]])
//        {
//            process = (VSProcessSymbol*)view;
//            
//            if([process.tagSymbol isEqualToString:self.stringProcessInCustomerID])
//            {
//                self.customerSymbol.processBoxReferenceForCustomer = process;
//                [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference = self.customerSymbol;
//                process.customerSymbolReference = self.customerSymbol;
//                [VSDrawingManager sharedDrawingManager].isCustomerConnectedToProcessBox = YES;
//            }
//            
//            if([process.tagSymbol isEqualToString:self.stringProcessInSupplierID])
//            {
//                self.supplierSymbol.processBoxReferenceForSupplier = process;
//                [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference = self.supplierSymbol;
//                process.supplierSymbolReference = self.supplierSymbol;
//                [VSDrawingManager sharedDrawingManager].isSupplierConnectedToProcessBox = YES;
//            }
//            
//            //    [process moveSymbol:nil];
//            
//        }
//    }
    
    
    
}

-(void) createTimeLines:(NSArray*) arrayTimeLine
{
    NSMutableArray *arrayTimeLineForDrawingManager = [[NSMutableArray alloc] init];
    
    NSDictionary *timeLineDictionary;
    
    VSTimeLineHeadViewController *timeLine;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    int count = [arrayTimeLine count];
    
    
    //For handling the case of Bool for Timeline is present or NOT
    NSMutableDictionary *tmpDict=[arrayTimeLine lastObject];
   int number= [[tmpDict objectForKey:kTailPresentBool] integerValue];
    if(number == 1)
    {
        [VSDrawingManager sharedDrawingManager].isTailPresent=YES;
    }
    
    else
    {
        [VSDrawingManager sharedDrawingManager].isTailPresent=NO;
    }

    VSProcessSymbol *process;
    
    for(int i = 0; i < count; i++)
    {
        timeLineDictionary = [arrayTimeLine objectAtIndex:i];
        
        if(i == 0 && count > 0) {
            
            
            timeLine=[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil];
            
            timeLine.isTail = NO;
            
            [appDelegate.detailViewController.detailItem addSubview:timeLine.view];
            
            
            timeLine.view.frame = CGRectFromString([timeLineDictionary objectForKey:kFrame]);
            
            timeLine.nonValueHeadSecsLabel.text = [timeLineDictionary objectForKey:kNVeHeadSecs];
            timeLine.nonValueHeadMinsLabel.text = [timeLineDictionary objectForKey:kNVHeadMin];
            timeLine.nonValueHeadHoursLabel.text = [timeLineDictionary objectForKey:kNVHeadHours];
            timeLine.valueHeadSecsLabel.text = [timeLineDictionary objectForKey:kVHeadSecs];
            timeLine.valueHeadMinsLabel.text =  [timeLineDictionary objectForKey:kVHeadMins];
            timeLine.valueHeadHoursLabel.text = [timeLineDictionary objectForKey:kVHeadHours];
            
            [arrayTimeLineForDrawingManager addObject:timeLine];
            [timeLine release];
            
            continue;
        }
        
        if(i == 1 && count > 1 && [VSDrawingManager sharedDrawingManager].isTailPresent==YES ){
            
            timeLine=[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil];
            
            timeLine.isNonValueAddedTail = YES;
            
            [appDelegate.detailViewController.detailItem addSubview:timeLine.view];
            timeLine.view.frame = CGRectFromString([timeLineDictionary objectForKey:kFrame]);
            
            timeLine.tailSecondsLabel.text = [timeLineDictionary objectForKey:kTailSecs];
            timeLine.tailMinutesLabel.text = [timeLineDictionary objectForKey:kTailMins];
            timeLine.tailHoursLabel.text = [timeLineDictionary objectForKey:kTailHours];
           
            process = (VSProcessSymbol*)[self getSymbolViewWithTag:[timeLineDictionary objectForKey:kSymbolTag]];
            
            process.timeLineTailReference = timeLine;
            process.timeLineRefernce = timeLine;
            
            [arrayTimeLineForDrawingManager addObject:timeLine];
            [timeLine release];
            continue;
        }
        
        if((i >= 1 && count > 2) && ((i+1) != count))
        {
            timeLine=[[VSTimeLineHeadViewController alloc] initWithNibName:@"VSTimeLineHeadViewController" bundle:nil];
            
            timeLine.isTail = YES;
            
            [appDelegate.detailViewController.detailItem addSubview:timeLine.view];
            timeLine.view.frame = CGRectFromString([timeLineDictionary objectForKey:kFrame]);
            
            timeLine.minsNonValueAdded.text = [timeLineDictionary objectForKey:kNVMinAdded];
            timeLine.secsNonValueAdded.text = [timeLineDictionary objectForKey:kNVSecsAdded];
            timeLine.hoursNonValueAdded.text= [timeLineDictionary objectForKey:kNVHoursAdded];
            timeLine.minsValueAdded.text = [timeLineDictionary objectForKey:kVMinAdded];
            timeLine.secsValueAdded.text = [timeLineDictionary objectForKey:kVSecsAdded];
            timeLine.hoursValueAdded.text = [timeLineDictionary objectForKey:kVHoursAdded];
            process = (VSProcessSymbol*)[self getSymbolViewWithTag:[timeLineDictionary objectForKey:kSymbolTag]];
            
            process.timeLineRefernce = timeLine;
            [arrayTimeLineForDrawingManager addObject:timeLine];
            [timeLine release];
        }
        
        /*
        else if((i+1) == count)
        {
            int number=[[timeLineDictionary objectForKey:kTailPresentBool] integerValue];
            
            if(number == 1)
            {
                [VSDrawingManager sharedDrawingManager].isTailPresent=YES;
            }
            
            else
            {
                [VSDrawingManager sharedDrawingManager].isTailPresent=NO;
            }
        
         
            
        }
         */
        
    }


    [VSDrawingManager sharedDrawingManager].arrayOfTimeLine = arrayTimeLineForDrawingManager;
    if(count > 0)
    {
        [VSDrawingManager sharedDrawingManager].headTimeLineController=[arrayTimeLineForDrawingManager objectAtIndex:0];
    }


    
    
    [arrayTimeLineForDrawingManager release];
    
}



-(NSMutableArray*) parseArrowArrays:(NSMutableArray*) array forOutGoing:(BOOL) isOutGoing
{
    
    NSMutableArray *pushSymbolArray = [[[NSMutableArray alloc] init] autorelease];
    NSDictionary *dictionaryPushSymbol;
    
    VSPushArrowSymbol *arrow;
    
    NSDictionary *metaData;
    
    // VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    for(dictionaryPushSymbol in array)
    {
        metaData = [DataManager getDictionaryBasedOnID:[[dictionaryPushSymbol objectForKey:@"ID"] doubleValue]];
        
        
        arrow = [[VSPushArrowSymbol alloc] initWithName:@"push-symbols" withTag:@""];
        arrow.ID = [dictionaryPushSymbol objectForKey:@"ID"];
        arrow.startingPoint = CGPointFromString([dictionaryPushSymbol objectForKey:@"s"]);
        arrow.endingPoint = CGPointFromString([dictionaryPushSymbol objectForKey:@"e"]);
        [arrow setFrame:CGRectMake(
                                   [[dictionaryPushSymbol objectForKey:@"x"] floatValue],
                                   [[dictionaryPushSymbol objectForKey:@"y"] floatValue],
                                   [[dictionaryPushSymbol objectForKey:@"W"] floatValue],
                                   [[dictionaryPushSymbol objectForKey:@"H"] floatValue])
         ];
        arrow.transform = CGAffineTransformFromString([dictionaryPushSymbol objectForKey:@"T"]);
        arrow.image = [UIImage imageNamed:[dictionaryPushSymbol objectForKey:kColorFileName]];
        [pushSymbolArray addObject:arrow];
        
        
        
        // [appDelegate.detailViewController.detailItem addSubview:arrow];
        //[[VSDrawingManager sharedDrawingManager] adjustOutGoingArrowsConnectedToSymbolView:process];
        // }//
        
        // else
        // {
        //  arrow = [self getPushSymbolViewWithID:[dictionaryPushSymbol objectForKey:@"ID"]];
        
        // [pushSymbolArray addObject:arrow];
        
        
        
        //[[VSDrawingManager sharedDrawingManager] adjustIncomingArrowsConnectedToSymbolView:process];
        
        
        [arrow release];
        
    }
    
    
    
    return pushSymbolArray;
}

-(void) adjustArrowsInProcessBoxes:(NSDictionary*) dictionarySymbols
{
    NSDictionary *dictionarySymbol;
    
    NSDictionary *dictionaryPushInSymbol;
    
    NSDictionary *dictionaryPushOutSymbol;
    
    NSString *keyName;
    
    NSString *subKeyName;
    
    NSString *tagPushSymbol;
    
    VSPushArrowSymbol *arrow;
    
    VSProcessSymbol *symbol1;
    
    VSProcessSymbol *symbol2;
    
    VSMaterialSymbol *materialSymbol;
    
    NSArray* inComingArray;
    
    NSArray* outGoingArray;
    
    NSDictionary *metaData;
    
    // BOOL isSkip;
    
    
    for(keyName in dictionarySymbols)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        inComingArray = [dictionarySymbol objectForKey:kIncomingArrows];
        
        symbol1 = (VSProcessSymbol*)[self getSymbolViewWithTag:keyName];
        
        inComingArray = [[inComingArray reverseObjectEnumerator] allObjects];
        
        dictionaryPushInSymbol = [self getLatestPushSymbolDictionaryForArray:inComingArray];
        
        tagPushSymbol = [dictionaryPushInSymbol objectForKey:kTagArrow];
        
        
        
        //        for(dictionaryPushInSymbol in inComingArray)
        //        {
        
        
        
        
        if(![[dictionaryPushInSymbol objectForKey:kName] isEqualToString:@"push-symbols"]
           &&[[dictionaryPushInSymbol objectForKey:kName] isEqualToString:@"information-flow"]
           &&[[dictionaryPushInSymbol objectForKey:kName] isEqualToString:@"information-flow-2"])
        {
            
            continue;
        }
        
        for(subKeyName in dictionarySymbols)
        {
            
            dictionarySymbol = [dictionarySymbols objectForKey:subKeyName];
            
            outGoingArray = [dictionarySymbol objectForKey:kOutgoingArrows];
            
            if([outGoingArray count] > 0)
            {
                // dictionaryPushOutSymbol = [outGoingArray lastObject];
                
                metaData = [DataManager getDictionaryBasedOnID:[[dictionarySymbol objectForKey:@"ID"] doubleValue]];
                
                // if([[metaData objectForKey:kType] doubleValue] != 2)
                // {
                
                if(outGoingArray != nil)
                {
                    dictionaryPushOutSymbol = [self getLatestPushSymbolDictionaryForArray:outGoingArray andTag:tagPushSymbol];
                    //dictionaryPushOutSymbol = nil;
                }
                
                else
                {
                    dictionaryPushOutSymbol = nil;
                }
                
                if(dictionaryPushOutSymbol !=nil)
                {
                    
                    if([tagPushSymbol isEqualToString:[dictionaryPushOutSymbol objectForKey:kTagArrow]])
                    {
                        
                        symbol2 = (VSProcessSymbol*)[self getSymbolViewWithTag:subKeyName];
                        
                        arrow = [[VSPushArrowSymbol alloc] initWithName:@"push-symbols" withTag:tagPushSymbol];
                        
                        arrow.image = [UIImage imageNamed:[dictionaryPushOutSymbol objectForKey:kColorFileName]];
                        arrow.imageColorFileName = [dictionaryPushOutSymbol objectForKey:kColorFileName];
                        
                        materialSymbol = (VSMaterialSymbol*)[self getSymbolViewWithTag:[dictionaryPushOutSymbol objectForKey:kTagMaterialArrow]];
                        //materialSymbol.image = [UIImage imageNamed:materialSymbol.imageColorFileName];
                        
                        NSLog(@"testing");
                        
                        
                        //    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:symbol1 andSymbolView:symbol2 andPushSymbol:arrow andMaterialSymbol:materialSymbol andCustomerSupplierSymbol:YES];
                        //     }
                        
                        //  else
                        //  {
                        
                       [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:symbol1 andSymbolView:symbol2 andPushSymbol:arrow andMaterialSymbol:materialSymbol andCustomerSupplierSymbol:NO];
                        
                        if(symbol2.ID.integerValue != 1 && symbol1.ID.integerValue != 43)
                        {
                            symbol1.connectedFromProcessSymbolID =  [NSNumber numberWithDouble:symbol2.tagSymbol.doubleValue ];
                            symbol2.connectedToProcessSymbolID = [NSNumber numberWithDouble:symbol1.tagSymbol.doubleValue ];
                        }
                        
                        //  }
                        
                        
                        //                        symbol1.isFirstTouchOnSymbol = YES;
                        //                        symbol2.isFirstTouchOnSymbol = YES;
                        //                        [symbol1 moveSymbol:nil];
                        //                        [symbol2 moveSymbol:nil];
                        
                        break;
                        
                    }
                    
                }
                
                
                
                
                //                            if([tagPushSymbol isEqualToString:[dictionaryPushOutSymbol objectForKey:kTagArrow]])
                //                            {
                //                                if([[dictionaryPushOutSymbol objectForKey:kName] isEqualToString:@"push-symbols"]
                //                                   &&![[dictionaryPushOutSymbol objectForKey:kName] isEqualToString:@"information-flow"]
                //                                   &&![[dictionaryPushOutSymbol objectForKey:kName] isEqualToString:@"information-flow-2"])
                //                                {
                //                                symbol2 = (VSProcessSymbol*)[self getSymbolViewWithTag:subKeyName];
                //
                //                                arrow = [[VSPushArrowSymbol alloc] initWithName:@"push-symbols" withTag:tagPushSymbol];
                //
                //                                arrow.image = [UIImage imageNamed:[dictionaryPushOutSymbol objectForKey:kColorFileName]];
                //                                arrow.imageColorFileName = [dictionaryPushOutSymbol objectForKey:kColorFileName];
                //
                //                                materialSymbol = (VSMaterialSymbol*)[self getSymbolViewWithTag:[dictionaryPushOutSymbol objectForKey:kTagMaterialArrow]];
                //                                materialSymbol.image = [UIImage imageNamed:@"inventory"];
                //
                //                                    NSLog(@"testing");
                //
                //
                //
                //                              //  if([[metaData objectForKey:kType] doubleValue] == 2)
                //                               // {
                //                                //    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:symbol1 andSymbolView:symbol2 andPushSymbol:arrow andMaterialSymbol:materialSymbol andCustomerSupplierSymbol:YES];
                //                           //     }
                //
                //                              //  else
                //                              //  {
                //                                    [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:symbol1 andSymbolView:symbol2 andPushSymbol:arrow andMaterialSymbol:materialSymbol andCustomerSupplierSymbol:NO];
                //                              //  }
                //
                //
                //                                //                        symbol1.isFirstTouchOnSymbol = YES;
                //                                //                        symbol2.isFirstTouchOnSymbol = YES;
                //                                //                        [symbol1 moveSymbol:nil];
                //                                //                        [symbol2 moveSymbol:nil];
                //                                [arrow release];
                //                               isSkip = YES;
                //                               break;
                //                                }
                
                //   }
                
                // }
                
                //}
            }
            
            //                for(dictionaryPushOutSymbol in outGoingArray)
            //                {
            //                    if([tagPushSymbol isEqualToString:[dictionaryPushOutSymbol objectForKey:kTagArrow]])
            //                    {
            //                        symbol2 = (VSProcessSymbol*)[self getSymbolViewWithTag:subKeyName];
            //
            //                        arrow = [[VSPushArrowSymbol alloc] initWithName:@"push-arrow" withTag:tagPushSymbol];
            //
            //                        materialSymbol = (VSMaterialSymbol*)[self getSymbolViewWithTag:[dictionaryPushOutSymbol objectForKey:kTagMaterialArrow]];
            //                        materialSymbol.image = [UIImage imageNamed:@"inventory"];
            //
            //
            //                        [[VSDrawingManager sharedDrawingManager] addingArrowBetweenSymbolView:symbol1 andSymbolView:symbol2 andPushSymbol:arrow andMaterialSymbol:materialSymbol andCustomerSupplierSymbol:NO];
            //
            ////                        symbol1.isFirstTouchOnSymbol = YES;
            ////                        symbol2.isFirstTouchOnSymbol = YES;
            ////                        [symbol1 moveSymbol:nil];
            ////                        [symbol2 moveSymbol:nil];
            //                        [arrow release];
            //
            //                    }
            //                }
            //  }
        }
        
        
        
        
    }
    
}

-(NSDictionary*) getLatestPushSymbolDictionaryForArray:(NSArray*) array
{
    if(array == nil)
    {
        return nil;
    }
    NSDictionary *dictionaryPushOutSymbol;
    
    for(dictionaryPushOutSymbol in array)
    {
        if([[dictionaryPushOutSymbol objectForKey:kName] isEqualToString:@"push-symbols"])
        {
            return dictionaryPushOutSymbol;
        }
    }
    
    return nil;
}


-(NSDictionary*) getLatestPushSymbolDictionaryForArray:(NSArray*) array andTag:(NSString*)tag
{
    if(array == nil)
    {
        return nil;
    }
    NSDictionary *dictionaryPushOutSymbol;
    
    for(dictionaryPushOutSymbol in array)
    {
        if([[dictionaryPushOutSymbol objectForKey:kName] isEqualToString:@"push-symbols"]
           &&[[dictionaryPushOutSymbol objectForKey:kTagArrow] isEqualToString:tag])
        {
            return dictionaryPushOutSymbol;
        }
    }
    
    return nil;
}


- (VSSymbols*)getSymbolViewWithTag:(NSString*) tag{
    
    // Get the subviews of the view
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSArray *subviews = [appDelegate.detailViewController.detailItem subviews];
    
    NSString *tagSymbolFromView;
    
    //NSDictionary *metaData;
    
    // Return if there are no subviews
    if ([subviews count] == 0) return nil;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        
        
        
        if([subview isKindOfClass:[VSSymbols class]])
        {
            tagSymbolFromView = ((VSSymbols*)subview).tagSymbol;
            
            if([tagSymbolFromView isEqualToString:tag])
            {
                return (VSSymbols*)subview;
            }
        }
        
    }
    
    return nil;
}

#pragma mark Material Symbol

-(void) createMaterialSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSMaterialSymbol *material;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        
        material = [[VSMaterialSymbol alloc] initWithName:[dictionarySymbol objectForKey:kName] withTag:keyName];
        
        
        
        [appDelegate.detailViewController.detailItem addSubview:material];
        
        
        //material.lastScale=[[dictionarySymbol objectForKey:@"lastScale"] floatValue];
        
        
        /*
        [material setFrame:CGRectMake(
                                      [[dictionarySymbol objectForKey:@"x"] floatValue],
                                      [[dictionarySymbol objectForKey:@"y"] floatValue],
                                      [[dictionarySymbol objectForKey:@"W"] floatValue],
                                      [[dictionarySymbol objectForKey:@"H"] floatValue])
         ];
        */
        
 
        
        material.bounds=CGRectMake(
                                   [[dictionarySymbol objectForKey:@"x"] floatValue],
                                   [[dictionarySymbol objectForKey:@"y"] floatValue],
                                   [[dictionarySymbol objectForKey:@"W"] floatValue],
                                   [[dictionarySymbol objectForKey:@"H"] floatValue]);
        
        [material setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
        [material setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
   

//        material.transform=CGAffineTransformInvert(CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"]));

        
        
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        
        if(ID == 6)
        {
            [material addTextFieldToInventorySymbol];
            material.textField.text = [dictionarySymbol objectForKey:kTextField1];
        }
        metaData = [DataManager getDictionaryBasedOnID:ID];
        material.ID = [dictionarySymbol objectForKey:@"ID"];
        
        material.name = [dictionarySymbol objectForKey:kName];
        
        //material.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
        material.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];
        material.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
        
        material.isFirstTouchOnSymbol = NO;
        
        [material release];
        
    }
    
    
    // //VSProcessSymbol *symbol = [VSProcessSymbol alloc] initWithName:[dictionarySymbol objectForKey:kName] withTag:<#(NSString *)#>
}

#pragma mark General Symbol

-(void) createGeneralSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSGeneralSymbol *general;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        general = [[VSGeneralSymbol alloc] initWithName:[metaData objectForKey:kName] withTag:keyName andMetaDataID:[dictionarySymbol objectForKey:@"ID"]];
        [appDelegate.detailViewController.detailItem addSubview:general];
        
        
        general.bounds=CGRectMake(
                                  [[dictionarySymbol objectForKey:@"x"] floatValue],
                                  [[dictionarySymbol objectForKey:@"y"] floatValue],
                                  [[dictionarySymbol objectForKey:@"W"] floatValue],
                                  [[dictionarySymbol objectForKey:@"H"] floatValue]);
        
        [general setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
        [general setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
        
        //general.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
        general.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];
        general.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
        
        if(general.ID.integerValue == 27 || general.ID.integerValue == 28)
        {
            general.textField1.text=[dictionarySymbol objectForKey:kTextField1];
        }
        
        else if(general.ID.integerValue == 41)
        {
            general.textField1.text=[dictionarySymbol objectForKey:kTextField1];
            general.textField2.text=[dictionarySymbol objectForKey:kTextField2];
        }
        
        else if(general.ID.integerValue == 29 || general.ID.integerValue == 40)
        {
            
            [general.buttonForTimeLinePopUp setTitle:[NSString stringWithFormat:@"%@",[dictionarySymbol objectForKey:kTimeLineLabelHours]] forState:UIControlStateNormal];


            //general.isNonValueAddedTimeLine=[[dictionarySymbol objectForKey:kisNonValueBool] boolValue];
            if([[dictionarySymbol objectForKey:kisNonValueBool] boolValue] == YES)
            {
                general.buttonForTimeLinePopUp.frame=CGRectMake(17, 0, 70, kDefaultHeightOfTexField);

            }
            
            else
            {
                general.buttonForTimeLinePopUp.frame=CGRectMake(17, 60, 70, kDefaultHeightOfTexField);

            }
            
           // general.buttonForTimeLinePopUp.titleLabel.text=[dictionarySymbol objectForKey:kTimeLineLabelHours];


        }
        
        general.isFirstTouchOnSymbol = NO;
        
        [general release];
    }
    
}

#pragma mark Info Symbol

-(void) createInfoSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSInfoSymbol *info;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        info = [[VSInfoSymbol alloc] initWithName:[metaData objectForKey:kName] withTag:keyName andMetaDataID:[dictionarySymbol objectForKey:@"ID"]];
        [appDelegate.detailViewController.detailItem addSubview:info];
        
        
        info.bounds=CGRectMake(
                                  [[dictionarySymbol objectForKey:@"x"] floatValue],
                                  [[dictionarySymbol objectForKey:@"y"] floatValue],
                                  [[dictionarySymbol objectForKey:@"W"] floatValue],
                                  [[dictionarySymbol objectForKey:@"H"] floatValue]);
        
        [info setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
        [info setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
        info.textField1.text=[dictionarySymbol objectForKey:kTextField1];
        
        // info.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
        info.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];
        info.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
        
        info.isFirstTouchOnSymbol = NO;
        
        if([VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference == nil && [dictionarySymbol objectForKey:kIsFirstProduction])
        {
            //[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isAutomation"];
            //[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isSupplierAdded"];
            //[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isCustomerAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
             [VSDrawingManager sharedDrawingManager].isParsingInfo = YES;
            
            
            [[VSDrawingManager sharedDrawingManager] addArrowsBetweenInfoSymbol:info];
            [VSDrawingManager sharedDrawingManager].isParsingInfo = NO;
        }
        
        [info release];
        
    }
    
}

-(BOOL) isCustomerSymbolForTag:(NSString*)tag
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    for(keyName in self.dictionaryProcessSymbol)
    {
        dictionarySymbol = [self.dictionaryProcessSymbol objectForKey:keyName];
        
        if(([[dictionarySymbol objectForKey:@"ID"] integerValue] == 43 )&& [tag isEqualToString:keyName])
        {
            return YES;
        }
        
    }
    
    return NO;
    
}

-(NSString*) getColorForCustomerArrow:(BOOL) isCustomer andForTag:(NSString*)tag
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    NSDictionary *dictionaryArrows;
    
    NSArray *array;
    for(keyName in self.dictionaryProcessSymbol)
    {
        if([tag isEqualToString:keyName])
        {
            
        dictionarySymbol = [self.dictionaryProcessSymbol objectForKey:keyName];
        
        if([[dictionarySymbol objectForKey:@"ID"] integerValue] == 43)
        {
            array = [dictionarySymbol objectForKey:kOutgoingArrows];
        }
        
        else
        {
            array = [dictionarySymbol objectForKey:kIncomingArrows];
        }
        
        
        
        for(dictionaryArrows in array)
        {
            if([[dictionaryArrows objectForKey:@"tagOwnership"] isEqualToString:tag])
            {
                if([[dictionaryArrows objectForKey:@"name"] isEqualToString:@"information-flow"] ||[[dictionaryArrows objectForKey:@"name"] isEqualToString:@"information-flow-2"] )
                {
                    return [dictionaryArrows objectForKey:kColorFileName];
                    
                }
            }
                

        }
            
        }
        
    }
    
    return nil;
}

#pragma mark Extended Symbol

-(void) createExtendedSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSExtendedSymbol *extended;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        extended = [[VSExtendedSymbol alloc] initWithName:[metaData objectForKey:kName] withTag:keyName andMetaDataID:[dictionarySymbol objectForKey:@"ID"]];
        [appDelegate.detailViewController.detailItem addSubview:extended];
        
        
        extended.bounds=CGRectMake(
                                  [[dictionarySymbol objectForKey:@"x"] floatValue],
                                  [[dictionarySymbol objectForKey:@"y"] floatValue],
                                  [[dictionarySymbol objectForKey:@"W"] floatValue],
                                  [[dictionarySymbol objectForKey:@"H"] floatValue]);
        
        [extended setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
        [extended setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
        
        
        // extended.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
        extended.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];
        extended.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
        
        extended.isFirstTouchOnSymbol = NO;
        
        [extended release];
        
    }
    
}


#pragma mark Custom Symbol

-(void) createCustomSymbolsWithDictionary:(NSDictionary*) dictionarySymbols
{
    NSString *keyName;
    
    NSDictionary *dictionarySymbol;
    
    VSCustomImageSymbol *custom;
    
    VSMAPPAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *metaData;
    
    double ID;
    
    NSArray *allKeys =  [dictionarySymbols allKeys];
    
    for(keyName in allKeys)
    {
        dictionarySymbol = [dictionarySymbols objectForKey:keyName];
        ID = [[dictionarySymbol objectForKey:@"ID"] doubleValue];
        metaData = [DataManager getDictionaryBasedOnID:ID];
        
        custom = [[VSCustomImageSymbol alloc] initWithName:[metaData objectForKey:kName] withTag:keyName];
        [appDelegate.detailViewController.detailItem addSubview:custom];
        
        
        custom.bounds=CGRectMake(
                                  [[dictionarySymbol objectForKey:@"x"] floatValue],
                                  [[dictionarySymbol objectForKey:@"y"] floatValue],
                                  [[dictionarySymbol objectForKey:@"W"] floatValue],
                                  [[dictionarySymbol objectForKey:@"H"] floatValue]);
        
        [custom setCenter:CGPointFromString([dictionarySymbol objectForKey:@"center"])];
        [custom setTransform:CGAffineTransformFromString([dictionarySymbol objectForKey:@"T"])];
        
        
        // extended.image = [UIImage imageNamed:[metaData objectForKey:@"path"]];
        custom.image = [VSUtilities getImageForString:[dictionarySymbol objectForKey:kCustomImage]];
       // custom.image = [UIImage imageNamed:[dictionarySymbol objectForKey:kColorFileName]];
        custom.imageColorFileName = [dictionarySymbol objectForKey:kColorFileName];
        
        custom.isFirstTouchOnSymbol = NO;
        
        [custom release];
        
    }
}


@end
