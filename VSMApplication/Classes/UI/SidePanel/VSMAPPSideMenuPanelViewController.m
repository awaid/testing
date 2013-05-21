//
//  RootViewController.m
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import "VSMAPPSideMenuPanelViewController.h"
#import "DetailViewController.h"
#import "VSHomeScreenViewController.h"
#import "VSValueStreamViewController.h"
#import "VSImprovementsViewController.h"
#import "VSSymbolMenuCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "VSExistingProjectViewController.h"
#import "VSDrawingManager.h"
#import "VSProcessSymbol.h"
#import "VSDataBoxViewController.h"
#import "RadioButton.h"
#import "VSDataManager.h"



@interface VSMAPPSideMenuPanelViewController ()
{
    VSHomeScreenViewController *homeScreenController_;
    VSValueStreamViewController *valueStreamController_;
    VSImprovementsViewController *improvementViewController_;
    NSMutableDictionary* dictionarySymbolButtonStates_;
    UIView *greyTransparentView_;
    VSExistingProjectViewController *controller_;
    CGPoint location_;
    RadioButton *rb1_;
    RadioButton *rb2_;
    RadioButton *rb3_;
    RadioButton *rb4_;
    
    
    NSDictionary *dictionarySymbols_;
}

@property (nonatomic,retain) VSHomeScreenViewController *homeScreenController;
@property (nonatomic,retain) VSValueStreamViewController *valueStreamController;
@property (nonatomic,retain) VSImprovementsViewController *improvementViewController;
@property (nonatomic,retain) VSExistingProjectViewController *controller;
@property (nonatomic,retain) NSMutableDictionary* dictionarySymbolButtonStates;
@property (nonatomic,retain) UIView *greyTransparentView;
@property (nonatomic, readwrite) CGPoint location;
@property (nonatomic,retain) RadioButton *rb1;
@property (nonatomic,retain) RadioButton *rb2;
@property (nonatomic,retain) RadioButton *rb3;
@property (nonatomic,retain) RadioButton *rb4;

@property (nonatomic,retain) NSDictionary *dictionarySymbols;
@end

@implementation VSMAPPSideMenuPanelViewController

BOOL isSwipeDownGesture;
BOOL isBothSymbolTableViewVisible;


@synthesize detailViewController;
@synthesize homeScreenController=homeScreenController_;
@synthesize valueStreamController=valueStreamController_;
@synthesize improvementViewController=improvementViewController_;
@synthesize dictionarySymbolButtonStates = dictionarySymbolButtonStates_;
@synthesize symbolsTableView=symbolsTableView_;
@synthesize projectNameNotificationView=projectNameNotificationView_;
@synthesize greyTransparentView=greyTransparentView_;
@synthesize projectNameTextField=projectNameTextField_;
@synthesize controller=controller_;
@synthesize location=location_;
@synthesize rb1=rb1_;
@synthesize rb2=rb2_;
@synthesize rb3=rb3_;
@synthesize rb4=rb4_;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(347, 147);
    if(!dictionarySymbolButtonStates_)
    {
        dictionarySymbolButtonStates_ = [[NSMutableDictionary alloc] init];
        [self setInitialStatesOfSymbolMenus];
        [self rotateSymbolsTableview];
    }
    
    [self registerKeyboardChangeNotifications];
    [self.symbolsButton setSelected:YES];
    
    //[self settingUpLongPressGestureOnTableView];
    //[self.symbolsTableView setUserInteractionEnabled:YES];
    //[self.symbolsButton setEnabled:NO];
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.symbolsMenu.hidden = YES;
    
    [self.symbolsButton setUserInteractionEnabled:NO];
    
    [super viewWillAppear:animated];
    
    if(dictionarySymbols_ == nil)
    {
        dictionarySymbols_ = [[NSDictionary alloc] init];
    }
    
    self.dictionarySymbols = [DataManager getSymbolsDictionary];
    
    
    //    CALayer *sublayer = [CALayer layer];
    //    sublayer.contents=(id)[UIImage imageNamed:@"value-stream-slices_09.png"].CGImage;
    //    sublayer.frame = CGRectMake(317, 0, 4, 981);
    //    [self.view.layer addSublayer:sublayer];
    
    //    UISwipeGestureRecognizer *onFingerSwipeDownOnSymbolMenu = [[[UISwipeGestureRecognizer alloc]
    //                                                     initWithTarget:self
    //                                                     action:@selector(onFingerSwipeDownOnSymbolMenu)] autorelease];
    //    [onFingerSwipeDownOnSymbolMenu setDirection:UISwipeGestureRecognizerDirectionDown];
    //    [self.symbolsMenu addGestureRecognizer:onFingerSwipeDownOnSymbolMenu];
    //
    //    UISwipeGestureRecognizer *onFingerSwipeUpOnSymbolMenu = [[[UISwipeGestureRecognizer alloc]
    //                                                                initWithTarget:self
    //                                                                action:@selector(onFingerSwipeUpOnSymbolMenu)] autorelease];
    //    [onFingerSwipeUpOnSymbolMenu setDirection:UISwipeGestureRecognizerDirectionUp];
    //    [self.symbolsMenu addGestureRecognizer:onFingerSwipeUpOnSymbolMenu];
    
    isSwipeDownGesture = NO;
    
    //UISwipeGestureRecognizer *oneFingerSwipeRight = [[[UISwipeGestureRecognizer alloc]
    //initWithTarget:self
    //action:@selector(oneFingerSwipeRight:)] autorelease];
    //[oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //[[self view] addGestureRecognizer:oneFingerSwipeRight];
}


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.


- (void)selectFirstRow
{
	/*if ([self.tableView numberOfSections] > 0 && [self.tableView numberOfRowsInSection:0] > 0) {
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
     [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
     }
     */
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // Return the number of sections.
    NSArray *keys = [self.dictionarySymbols allKeys];
    return [keys count];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    float count;
    switch (section) {
        case 0:
            count = [[self.dictionarySymbols objectForKey:kProcessKey] count];
            return count;
            break;
        case 1:
            count = [[self.dictionarySymbols objectForKey:kMaterialKey] count];
            return count;
            break;
        case 2:
            count = [[self.dictionarySymbols objectForKey:kInfoKey] count];
            return count;
            break;
        case 3:
            count = [[self.dictionarySymbols objectForKey:kGeneralKey] count];
            return count;
            break;
        case 4:
            count = [[self.dictionarySymbols objectForKey:kExtendedKey] count];
            return count;
            break;
        default:
            return 0;
            break;
            
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return self.containerViewForSymbolTableview.frame.size.width;
    return 100;
}

////#pragma mark - Drag and Drop Delegate
////-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidBegin:(UIGestureRecognizer *)gesture forCell:(VSSymbolMenuCustomCell *)cell;
////{
////    
////    NSIndexPath *indexPath = [self.symbolsTableView indexPathForCell:cell];
////    self.selectedChoice =[self.choices objectAtIndex:indexPath.row];
////    
////    [self.choices removeObjectAtIndex:[self.choices indexOfObject:self.selectedChoice]];
////    
////    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
////    
////}
////
////
////
////-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureWillBegin:(UIGestureRecognizer *)gesture forCell:(UITableViewCell *)cell{
////    
////    UIGraphicsBeginImageContext(cell.contentView.bounds.size);
////    [cell.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
////    self.dragAndDropView = [[UIView alloc]initWithFrame:iv.frame];
////    [self.dragAndDropView addSubview:iv];
////    [self.dragAndDropView setBackgroundColor:[UIColor blueColor]];
////    [self.dragAndDropView setCenter:[gesture locationInView:self.view.superview]];
////    
////    [self.view.superview addSubview:self.dragAndDropView];
////}
////
////-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidMove:(UIGestureRecognizer *)gesture{
////    [self.dragAndDropView setCenter:[gesture locationInView:self.view.superview]];
////}
////
////
////-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidEnd:(UIGestureRecognizer *)gesture{
////    
////    [self.dragAndDropView removeFromSuperview];
////    self.dragAndDropView = nil;
////}
////
////
////-(UIView *)dragAndDropTableViewControllerView:(DragAndDropTableViewController *)ddtvc{
////    return self.dragAndDropView;
////}
//
//#pragma mark - Gesture Recogniser
//
//
//-(void)longGestureAction:(UILongPressGestureRecognizer *)gesture{
//    VSSymbolMenuCustomCell *cell= (VSSymbolMenuCustomCell *)[gesture view];
//    
//    
//    switch ([gesture state]) {
//        case UIGestureRecognizerStateBegan:{
//            
//            NSIndexPath *ip = [self.symbolsTableView indexPathForCell:cell];
//            [self.symbolsTableView setScrollEnabled:NO];
//            if(ip!=nil){
//                
//                [cell dragAndDropTableViewController:self  draggingGestureWillBegin:gesture forCell:cell];
//                
//                UIView *draggedView = [self.draggableDelegate dragAndDropTableViewControllerView:self ];
//                //switch the view the gesture is associated with this will allow the dragged view to continue on where the cell leaves off from
//                [draggedView addGestureRecognizer:[[cell gestureRecognizers]objectAtIndex:0]];
//                
//                [self.draggableDelegate dragAndDropTableViewController:self draggingGestureDidBegin:gesture forCell:cell];
//            }
//        }
//            break;
//        case UIGestureRecognizerStateChanged:{
//            [self.draggableDelegate dragAndDropTableViewController:self draggingGestureDidMove:gesture];
//        }
//            break;
//        case UIGestureRecognizerStateEnded:{
//            UIView *draggedView = [self.draggableDelegate dragAndDropTableViewControllerView:self];
//            
//            
//            if(draggedView==nil)
//                return;
//            
//            //might not be right to have both here but you need two different delegates so different controllers can controll different things
//            [self.draggableDelegate dragAndDropTableViewController:self draggingGestureDidEnd:gesture];
//            [self.dropableDelegate dragAndDropTableViewController:self droppedGesture:gesture];
//            
//            [self.tableView setScrollEnabled:YES];
//            [self.tableView reloadData];
//        }
//            break;
//            
//            //        case UIGestureRecognizerStateCancelled:
//            //        case UIGestureRecognizerStateFailed:
//            //        case UIGestureRecognizerStatePossible:
//            //            [self.dragAndDropDelegate dragAndDropTableViewController:self draggingGesture:gesture endedForItem:nil];
//            break;
//        default:
//            break;
//    }
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
//        [gestureRecognizer addTarget:self action:@selector(longGestureAction:)];
//    }
//    
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    
//    return YES;
//}
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    VSSymbolMenuCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VSSymbolMenuCustomCell alloc] initWithStyle:normal reuseIdentifier:CellIdentifier];
    }
    
    cell.buttonLeftSymbol.imageView.image = nil;
    cell.buttonRightSymbol.imageView.image = nil;
    cell.symbols = nil;
    
    [cell setGestureMethodsForButtons];
    

    
    NSArray *symbolsArray;
    
    switch (indexPath.section) {
        case 0:
            symbolsArray = [[self.dictionarySymbols objectForKey:kProcessKey] objectAtIndex:indexPath.row];
            [self setSymbolTableCellsWithCell:cell withArray:symbolsArray];
            break;
        case 1:
            symbolsArray = [[self.dictionarySymbols objectForKey:kMaterialKey] objectAtIndex:indexPath.row];
            [self setSymbolTableCellsWithCell:cell withArray:symbolsArray];
            break;
        case 2:
            symbolsArray = [[self.dictionarySymbols objectForKey:kInfoKey] objectAtIndex:indexPath.row];
            [self setSymbolTableCellsWithCell:cell withArray:symbolsArray];
            break;
        case 3:
            symbolsArray = [[self.dictionarySymbols objectForKey:kGeneralKey] objectAtIndex:indexPath.row];
            [self setSymbolTableCellsWithCell:cell withArray:symbolsArray];
            break;
        case 4:
            symbolsArray = [[self.dictionarySymbols objectForKey:kExtendedKey] objectAtIndex:indexPath.row];
            [self setSymbolTableCellsWithCell:cell withArray:symbolsArray];
            break;
        default:
            return 0;
            break;
            
    }
    

    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    
    return cell;
}

-(void) setSymbolTableCellsWithCell:(VSSymbolMenuCustomCell*) cell withArray:(NSArray*)symbolsArray
{
    
    NSDictionary *symbol1;
    NSDictionary *symbol2;
    
    symbol1 = [symbolsArray objectAtIndex:0];
    
    @try {
        symbol2 = [symbolsArray objectAtIndex:1];
    }
    @catch (NSException *exception) {
        symbol2 = nil;
    }
    
    [cell setCellSymbolsWithFirstSymbol:symbol1 andSecondSymbol:symbol2];
}


#pragma mark Table view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //_draggingView = NO;
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if(isBothSymbolTableViewVisible == NO)
    {
        if(bottomEdge >= scrollView.contentSize.height) {
            // we are at the end
            //[self onFingerSwipeDownOnSymbolMenu];
            [self scrollTableViewToHalf];
        }
    }
    
    else
    {
        if(bottomEdge >= scrollView.contentSize.height/2) {
            // we are at the end
            //[self onFingerSwipeDownOnSymbolMenu];
            [self closeFirstTableViewOnHalfScroll];
        }
    }
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
    //detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    
//    if(indexPath.section == 0)
//    {
//        if(indexPath.row == 0)
//        {
//            NSString *name = @"process-name.png";
//            NSString *dataBoxName = @"process-name.png";
//            VSProcessSymbol* process = [[VSDrawingManager sharedDrawingManager]  createProcessSymbolWithName:name];
//            
//            VSDataBoxViewController *dataBoxController=[[VSDrawingManager sharedDrawingManager] createDataBoxSymbol:dataBoxName];
//            
//            
//            process.image =  [UIImage imageNamed:name];
//            process.alpha=0.0;
//            
//            dataBoxController.view.alpha=0.0;
//            
//            [detailViewController.detailItem addSubview:(UIView*)process];
//            [detailViewController.detailItem addSubview:dataBoxController.view];
//            
//            [process setFrame:CGRectMake(detailViewController.view.frame.size.width/2,self.location.y, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
//            [dataBoxController.view setFrame:CGRectMake(detailViewController.view.frame.size.width/2,CGRectGetMinY(process.frame), kWidthOfProcessSymbol, 122)];
//            
//            
//            [UIView animateWithDuration:1.5
//                             animations:^{
//                                 [process setFrame:CGRectMake(detailViewController.view.frame.size.height/2,detailViewController.view.frame.size.width/2-kOffsetProcessInitialSymbolPositionY, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
//                                 
//                                 [dataBoxController.view setFrame:CGRectMake(detailViewController.view.frame.size.height/2,detailViewController.view.frame.size.width/2+kOffsetProcessInitialSymbolPositionY, kWidthOfProcessSymbol, 122)];
//                                 process.alpha=1.0;
//                                 dataBoxController.view.alpha=1.0;
//                             }
//                             completion:^(BOOL finished){
//                                 
//                             }
//             ];
//            
//
//            
//            
//            //[[[UIApplication sharedApplication] keyWindow] addSubview:process];
//            
//        }
//        
//        else
//        {
//            NSString *name = @"Process-Box-with-Information-Technology.png";
//            VSProcessSymbol* process = [[VSDrawingManager sharedDrawingManager]  createProcessSymbolWithName:name];
//            process.image =  [UIImage imageNamed:name];
//            process.alpha=0.0;
//            [detailViewController.detailItem addSubview:(UIView*)process];
//            [process setFrame:CGRectMake(detailViewController.view.frame.size.width/2,self.location.y, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
//            
//            
//            [UIView animateWithDuration:1.5
//                             animations:^{
//                                 [process setFrame:CGRectMake(detailViewController.view.frame.size.height/2,detailViewController.view.frame.size.width/2-kOffsetProcessInitialSymbolPositionY, kWidthOfProcessSymbol, kHeightOfProcessSymbol)];
//                                 process.alpha=1.0;
//                             }
//                             completion:^(BOOL finished){
//                                 
//                             }
//             ];
//        }
//        
//    }
//    
//    
//    else if(indexPath.section == 1)
//    {
//        if(indexPath.row == 0)
//        {
//            
//        }
//        
//    }
}


#pragma mark -
#pragma mark Memory management


- (void)dealloc
{
    //    [detailViewController release];
    //    [homeScreenController_ release];
    //    [valueStreamController_ release];
    //    [improvementViewController_ release];
    [controller_ release];
    [greyTransparentView_ release];
    [_symbolsMenu release];
    [_symbolsButton release];
    [_processSymbolButton release];
    [_materialSymbolButton release];
    [_informationSymbolButton release];
    [_generalSymbolButton release];
    [_extendedSymbolButton release];
    [_containerViewForSymbolTableview release];
    self.dictionarySymbolButtonStates = nil;
    [symbolsTableView_ release];
    [_containerViewForSymbolTableView2 release];
    [projectNameNotificationView_ release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [projectNameTextField_ release];
    [super dealloc];
}
#pragma mark - Custom Method

//following adds Radio Buttons to the Project Notification Idea

-(void) setUpDrawingPadForProject
{
    //Following 3 lines remove the Grey Transparent View from Window
    [self.greyTransparentView removeFromSuperview];
    [VSUtilities removeGreyTransparentViewFromWindow];
    [self.projectNameNotificationView removeFromSuperview];
    
    [[VSDrawingManager sharedDrawingManager] destroyDrawManager];
    
    
    
    //Presenting view on the right Detail View controller
    [((UIView*)detailViewController.detailItem).subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    detailViewController.detailItem = nil;
    [valueStreamController_ release];
    valueStreamController_=[[VSValueStreamViewController alloc] init];
    detailViewController.detailItem=valueStreamController_.view;
    
    [self.symbolsButton setUserInteractionEnabled:YES];

//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isAutomation"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
//    //Setting the NSUserDefaults that need to be set to NO
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimeLineHeadAdded"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

-(void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

-(void)addingRadioButtonsToProjectNotificationView
{
    if(rb1_ == nil)
    rb1_ = [[RadioButton alloc] initWithGroupId:@"first group" index:0];
    
    if(rb2_ == nil)
    {
        rb2_ = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
        [RadioButton addObserverForGroupId:@"first group" observer:self];

    }
    
    if(rb3_ == nil)
    rb3_ = [[RadioButton alloc] initWithGroupId:@"second group" index:0];
    
    if(rb4_ == nil)
    {
        rb4_ = [[RadioButton alloc] initWithGroupId:@"second group" index:1];
        [RadioButton addObserverForGroupId:@"second group" observer:self];

    }
    
    rb1_.frame = CGRectMake(25,138,22,22);
    rb2_.frame = CGRectMake(334,138,22,22);
    
    rb3_.frame = CGRectMake(215,167,22,22);
    rb4_.frame = CGRectMake(215,213,22,22);
    
    [self.projectNameNotificationView addSubview:rb1_];
    [self.projectNameNotificationView addSubview:rb2_];
    
    [self.projectNameNotificationView addSubview:rb3_];
    [self.projectNameNotificationView addSubview:rb4_];
    
  
    


}
//Following sets the Delegate for tap Gesture on Symbols Table View
-(void)settingUpLongPressGestureOnTableView
{
    UILongPressGestureRecognizer *longPressRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)] autorelease];
    [longPressRecognizer setDelegate:self];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self.symbolsTableView addGestureRecognizer:longPressRecognizer];
}
//following hanldes the long press gesture on the Symbols table View
- (void)handleLongGesture:(UILongPressGestureRecognizer *)sender
{
    self.location = [sender locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (CGRectContainsPoint([self.view convertRect:self.symbolsTableView.frame fromView:self.symbolsTableView.superview], self.location))
    {
        CGPoint locationInTableview = [self.symbolsTableView convertPoint:self.location fromView:self.view];
        NSIndexPath *indexPath = [self.symbolsTableView indexPathForRowAtPoint:locationInTableview];
        if (indexPath)
            [self tableView:self.symbolsTableView didSelectRowAtIndexPath:indexPath];
        
        return;
    }
}
//following method animates the Symbol View onto the drawing pad
-(void)animateSymbolToLocation
{
    
}
-(void)settingHeadersButton:(UIButton*)headerBtn
{
    [headerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"value-stream-slices_72.png"] forState:UIControlStateNormal];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    headerBtn.tag = 0;
    headerBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [headerBtn setFrame:CGRectMake(self.symbolsMenu.frame.origin.x-kOffsetHeadersButtonOriginX, headerBtn.frame.origin.y-2, self.symbolsMenu.frame.size.width+2, headerBtn.frame.size.height+4)];
}
//the following method rotates the Table View for horizontal scrolling
-(void)rotateSymbolsTableview
{
    self.symbolsTableView.showsVerticalScrollIndicator = NO;
    self.symbolsTableView.showsHorizontalScrollIndicator = NO;
    //self.symbolsTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    //[self.symbolsTableView setFrame:CGRectMake(self.containerViewForSymbolTableview.frame.origin.y, self.containerViewForSymbolTableview.frame.origin.x,self.containerViewForSymbolTableview.frame.size.width,self.containerViewForSymbolTableview.frame.size.height )];
    
    self.symbolsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.symbolsTableView.separatorColor = [UIColor clearColor];
}
//The following method determines whether the child View already exists in the detail view controller(or is already displayed in the Right Side-detailView).
-(BOOL)viewExistsOrNot:(UIView*)childView
{
    int viewDetectCounter=0;
    BOOL viewExists;
    for (UIView * view in [detailViewController.view subviews])
    {
        if(view == childView)
            viewDetectCounter=1;
        
        
    }
    
    if(viewDetectCounter == 1)
        viewExists=YES;
    
    else
    {
        viewExists=NO;
    }
    
    return viewExists;
}
#pragma mark - Keyboard Methods
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    self.projectNameNotificationView.frame=CGRectMake(self.projectNameNotificationView.frame.origin.x-150, self.projectNameNotificationView.frame.origin.y, self.projectNameNotificationView.frame.size.width, self.projectNameNotificationView.frame.size.height);
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.projectNameNotificationView.frame=CGRectMake(self.projectNameNotificationView.frame.origin.x+150, self.projectNameNotificationView.frame.origin.y, self.projectNameNotificationView.frame.size.width, self.projectNameNotificationView.frame.size.height);
}
#pragma mark - Button Methods
-(void)closeExistingProjectsAndOpenNewProject
{
    [self closeExistingProjectsButton];
    [self startNewProjectButton:self];
}
-(void)closeExistingProjectsButton
{
    //Since we retained the class property,removing to make sure no instance is in memory
    [self.greyTransparentView removeFromSuperview];
    [VSUtilities removeGreyTransparentViewFromWindow];
    [controller_.view removeFromSuperview];
    
}
- (IBAction)openExistingProjectsButton:(id)sender {
    controller_=[[VSExistingProjectViewController alloc] initWithNibName:@"VSExistingProjectViewController" bundle:nil];
    controller_.view.alpha=0.0;
    controller_.delegate=self;
    
    
    self.greyTransparentView=[VSUtilities addGreyBackgroundViewToWindow];
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    //Rotating the Project View for Main Window
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    controller_.view.transform= CGAffineTransformRotate(rotationTransform,DEGREES_TO_RADIANS(-90));
    [frontWindow addSubview:controller_.view];
    
    [UIView animateWithDuration:0.2
                     animations:^
     {
         
         controller_.view.center=CGPointMake(frontWindow.center.x, frontWindow.center.y);
         self.greyTransparentView.alpha=1.0;
         
     }
     
                     completion:^(BOOL finished)
     {
         self.greyTransparentView.alpha=0.5;
         controller_.view.alpha=1.0;
     }];
    
}


//following method is for the Continue Button on the Project Name Notification View
- (IBAction)continueProjectNotifcationButton:(id)sender {
    
    [self.symbolsButton setUserInteractionEnabled:NO];
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];

    //Following IF Checks for appropriate selections is made from the radio buttons in order to proceed further
    if((rb1_.button.isSelected || rb2_.button.isSelected) && (rb3_.button.isSelected || rb4_.button.isSelected))
    {

    
    
    //to check whether the text field is empty or not
    if([self.projectNameTextField.text isEqual:@""])
    {
        UIColor *color = [UIColor redColor];
        self.projectNameTextField.attributedPlaceholder = [[[NSAttributedString alloc] initWithString:self.projectNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}] autorelease];
    }
        
    else if([VSUtilities isProjectNameValid:self.projectNameTextField.text] == NO)
    {
        self.projectNameTextField.text = @"";
        self.projectNameTextField.placeholder = @"Invalid Name";
        
        
        UIColor *color = [UIColor redColor];
        self.projectNameTextField.attributedPlaceholder = [[[NSAttributedString alloc] initWithString:self.projectNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}] autorelease];
        
        
    }
        
    else if ([[self.projectNameTextField.text stringByTrimmingCharactersInSet: set] length] == 0)
    {
        self.projectNameTextField.text = @"";
        self.projectNameTextField.placeholder = @"Invalid Name";        
        
        UIColor *color = [UIColor redColor];
        self.projectNameTextField.attributedPlaceholder = [[[NSAttributedString alloc] initWithString:self.projectNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}] autorelease];
    }
        

        
    else if([DataManager isProjectNameExists:self.projectNameTextField.text] == YES)
    {
        self.projectNameTextField.text = @"";
        self.projectNameTextField.placeholder = @"Project Name Already Exists";
        
        UIColor *color = [UIColor redColor];
        self.projectNameTextField.attributedPlaceholder = [[[NSAttributedString alloc] initWithString:self.projectNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}] autorelease];
    }
    
    //to handle scenario where Everything wents fine and user has entered each information rightly
    else
    {        
        BOOL isTemplate = NO;

       
        //Meaning "With Automation has been selected"
        BOOL isAuto = NO;
        
        if(rb1_.button.isSelected)
        {
            isTemplate = NO;
        }
        
        if(rb1_.button.isSelected)
        {
            isTemplate = YES;
        }
        
        if(rb3_.button.isSelected)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isAutomation"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
            //Setting the NSUserDefaults that need to be set to NO
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimeLineHeadAdded"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToCustomer=NO;
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToSupplier=NO;
            
            //if([VSDrawingManager sharedDrawingManager])
              // [[VSDrawingManager sharedDrawingManager] destroyDrawManager];
            
            isAuto = YES;
        }
        
        //Meaning "Without Automation has been selected
        else if(rb4_.button.isSelected)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isAutomation"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];
            //Setting the NSUserDefaults that need to be set to NO
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimeLineHeadAdded"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [VSDrawingManager sharedDrawingManager].firstCustomerSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].firstProductionCenterSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].firstSupplierSymbolReference=nil;
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToCustomer=NO;
            [VSDrawingManager sharedDrawingManager].isProductionControlConnectedToSupplier=NO;

        }
        
        [self setUpDrawingPadForProject];

        NSString *projectName = [VSUtilities removeSpacesFromProjectNameIfExists:self.projectNameTextField.text];
        [DataManager createProjectWithName:projectName andAutomation:isAuto andTemplate:isTemplate];
        
        
        
        //[self.symbolsButton setEnabled:YES];
        
    }
}
    
    else
    {
        if([self.projectNameTextField.text isEqual:@""])
        {
            UIColor *color = [UIColor redColor];
            self.projectNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.projectNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        }
    
    //Condition when none of the button is selected
    if(!rb1_.button.isSelected && !rb2_.button.isSelected && !rb3_.button.isSelected && !rb4_.button.isSelected)
    {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                              message:@"Kindly select the Template Type and Automation method."
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles: nil];
            [message show];
            [message release];
    }
    
    //condition where only button1 or button2 for template selections are not selected at all
    else if(!rb1_.button.isSelected && !rb2_.button.isSelected)
    { UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                      message:@"Kindly select the Template Type."
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles: nil];
    [message show];
    [message release];
    }
    
    //condition where only button3 and button4 for automation mehtod are not selected at all
    else if(!rb3_.button.isSelected && !rb4_.button.isSelected)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                           message:@"Kindly select the Automation method."
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles: nil];
        [message show];
        [message release];
    }

    
    }

}

//following method is for the Cancel Button on the Project Name Notification View
- (IBAction)cancelProjectNotifcationButton:(id)sender {
        
    //Since we retained the class property,removing to make sure no instance is in memory
    [self.greyTransparentView removeFromSuperview];
    [VSUtilities removeGreyTransparentViewFromWindow];
    [self.projectNameNotificationView removeFromSuperview];
    

}

- (IBAction)startNewProjectButton:(id)sender {
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    
    self.greyTransparentView=[VSUtilities addGreyBackgroundViewToWindow];
    
    //Rotating the Project View for Main Window
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    self.projectNameNotificationView.transform= CGAffineTransformRotate(rotationTransform,DEGREES_TO_RADIANS(-90));
    
    [frontWindow addSubview:self.projectNameNotificationView];


    [VSUtilities addAndAnimateGreyBackground:self.greyTransparentView withView:self.projectNameNotificationView];
    
    [self addingRadioButtonsToProjectNotificationView];

    
    
}

- (IBAction)buttonHomeScreen:(UIButton *)sender {
    
    //following IF makes sure that Home Screen view is already displayed or not
    if(![self viewExistsOrNot:homeScreenController_.view])
    {
        [self hideSymbolsMenu];
        [homeScreenController_ release];
        homeScreenController_ = [[VSHomeScreenViewController alloc] init];
        detailViewController.detailItem = homeScreenController_.view;
    }
    
    //[homeScreen release];
}
- (IBAction)buttonCurrentValueStream:(id)sender {
    
    //following IF makes sure that Current Value Screen view is already displayed or not
    if(![self viewExistsOrNot:valueStreamController_.view])
    {
        [self hideSymbolsMenu];
        [valueStreamController_ release];
        valueStreamController_=[[VSValueStreamViewController alloc] init];
        detailViewController.detailItem=valueStreamController_.view;
        //[currentValueStream release];
    }
}

- (IBAction)buttonFutureValueStream:(id)sender {
    
    //following IF makes sure that Future Value Screen view is already displayed or not
    if(![self viewExistsOrNot:valueStreamController_.view])
    {
        [self hideSymbolsMenu];
        [valueStreamController_ release];
        valueStreamController_=[[VSValueStreamViewController alloc] init];
        detailViewController.detailItem=valueStreamController_.view;
        //[futureValueStream release];
    }
}
- (IBAction)buttonImprovementSteps:(id)sender {
    
    //following IF makes sure that Improvement Value Screen view is already displayed or not
    if(![self viewExistsOrNot:improvementViewController_.view])
    {
        [self hideSymbolsMenu];
        [improvementViewController_ release];
        improvementViewController_=[[VSImprovementsViewController alloc] init];
        
        detailViewController.detailItem=improvementViewController_.view;
        // [improvementSteps release];
    }
}

#pragma mark -
#pragma mark Symbols Menu
//The following functions hides the symbol menu from the Side Panel
-(void)hideSymbolsMenu
{
    if(!self.symbolsMenu.hidden)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.symbolsMenu.alpha=0.0;
        } completion:^(BOOL finished){
            
            self.symbolsMenu.hidden = YES;
            self.symbolsMenu.alpha=1.0;
            [self.symbolsMenu removeFromSuperview];
        }];
        
        
    }
    
}

// main symbol button tapped
- (IBAction)symbolButton:(UIButton *)sender {
    
    //the following check whether the Current or Future Value Stream is in Active in Detail View
    //if([self viewExistsOrNot:valueStreamController_.view])
    // {
    //self.containerViewForSymbolTableview.frame = CGRectMake(self.processSymbolButton.frame.origin.x,self.processSymbolButton.frame.origin.y+self.symbolsButton.frame.size.height,self.containerViewForSymbolTableview.frame.size.width,0);
    [self setFrameForSymbolViewMenu];
    //isBothSymbolTableViewVisible = NO;
    
    //[self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsProcessSymbolSelected];
    
    
    if(self.symbolsMenu.hidden)
    {
        [self.symbolsButton setSelected:NO];
        self.symbolsMenu.hidden = NO;
        [self.view addSubview:self.symbolsMenu];
        
        //Scenario where the Symbol Menu appears for the first time
        if(self.symbolsMenu.frame.size.width !=356)
        {
            [self.symbolsMenu setFrame:CGRectMake(self.symbolsButton.frame.origin.x-kOffsetSymbolsViewOriginX,self.symbolsButton.frame.origin.y+kOffsetSymbolsViewOriginY,self.symbolsMenu.frame.size.width,self.symbolsMenu.frame.size.height)];
            
            [self processSymbolButton:nil];
        }
        
        //Scenario where the Symbol Menu appears for the second time
        else
        {
            [self.symbolsMenu setFrame:CGRectMake(self.symbolsButton.frame.origin.x-kOffsetSymbolsViewOriginX,self.symbolsButton.frame.origin.y+kOffsetSymbolsViewOriginY,283,self.symbolsMenu.frame.size.height)];
            
            [self processSymbolButton:nil];
        }
        
    }
    
    else
    {
        self.symbolsMenu.hidden = YES;
        [self.symbolsButton setSelected:YES];
        [self.symbolsMenu removeFromSuperview];
    }
    
    [self reloadTableData];
   
    
    
    
}

//process button tapped
- (IBAction)processSymbolButton:(UIButton *)sender {
    
    
    
    
    [self.containerViewForSymbolTableview removeFromSuperview];
    
    [self setOriginalPositionOfSymbolMenuButtons];
    
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsProcessSymbolSelected] integerValue] == 0)
    {
        [self setInitialStatesOfSymbolMenus];
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsProcessSymbolSelected];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kSymbolAnimationInterval];
        
        [self setButtonFrameOnAnimation:self.materialSymbolButton];
        [self setButtonFrameOnAnimation:self.informationSymbolButton];
        [self setButtonFrameOnAnimation:self.generalSymbolButton];
        [self setButtonFrameOnAnimation:self.extendedSymbolButton];
        
        
        
        
        
        [UIView commitAnimations];
        [self performSelector:@selector(setFrameOfSymbolTableViewContainerWithY:) withObject:self.processSymbolButton afterDelay:kSymbolAnimationInterval];
    }
    
    else
    {
        //selectedSymbol = 1;
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsProcessSymbolSelected];
        [self setInitialStatesOfSymbolMenus];
        if(isSwipeDownGesture == YES && sender
           == nil)
        {
            isSwipeDownGesture = NO;
            [self materialSymbolButton:nil];
        }
        
    }
    
    [self.symbolsMenu bringSubviewToFront:self.containerViewForSymbolTableview];
}

- (IBAction)materialSymbolButton:(UIButton *)sender {
    
    [self setOriginalPositionOfSymbolMenuButtons];
    [self.containerViewForSymbolTableview removeFromSuperview];
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsMaterialSymbolSelected] integerValue] == 0)
    {
        [self setInitialStatesOfSymbolMenus];
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsMaterialSymbolSelected];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kSymbolAnimationInterval];
        
        [self setButtonFrameOnAnimation:self.informationSymbolButton];
        [self setButtonFrameOnAnimation:self.generalSymbolButton];
        [self setButtonFrameOnAnimation:self.extendedSymbolButton];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(setFrameOfSymbolTableViewContainerWithY:) withObject:self.materialSymbolButton afterDelay:kSymbolAnimationInterval];
        
    }
    
    else
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsMaterialSymbolSelected];
        [self setInitialStatesOfSymbolMenus];
        
        if(isSwipeDownGesture == YES && sender
           == nil)
        {
            isSwipeDownGesture = NO;
            [self informationSymbolButton:nil];
        }
    }
}

// info button tapped
- (IBAction)informationSymbolButton:(UIButton *)sender {
    
    [self setOriginalPositionOfSymbolMenuButtons];
    [self.containerViewForSymbolTableview removeFromSuperview];
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsInformationSymbolSelected] integerValue] == 0)
    {
        [self setInitialStatesOfSymbolMenus];
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsInformationSymbolSelected];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kSymbolAnimationInterval];
        
        [self setButtonFrameOnAnimation:self.generalSymbolButton];
        [self setButtonFrameOnAnimation:self.extendedSymbolButton];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(setFrameOfSymbolTableViewContainerWithY:) withObject:self.informationSymbolButton afterDelay:kSymbolAnimationInterval];
        
    }
    
    else
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsInformationSymbolSelected];
        [self setInitialStatesOfSymbolMenus];
        if(isSwipeDownGesture == YES && sender
           == nil)
        {
            isSwipeDownGesture = NO;
            [self generalSymbolButton:nil];
        }
    }
}


// general button tapped
- (IBAction)generalSymbolButton:(UIButton *)sender {
    
    [self setOriginalPositionOfSymbolMenuButtons];
    [self.containerViewForSymbolTableview removeFromSuperview];
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsGeneralSymbolSelected] integerValue] == 0)
    {
        [self setInitialStatesOfSymbolMenus];
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsGeneralSymbolSelected];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kSymbolAnimationInterval];
        
        [self setButtonFrameOnAnimation:self.extendedSymbolButton];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(setFrameOfSymbolTableViewContainerWithY:) withObject:self.generalSymbolButton afterDelay:kSymbolAnimationInterval];
        
    }
    
    else
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsGeneralSymbolSelected];
        [self setInitialStatesOfSymbolMenus];
        if(isSwipeDownGesture == YES && sender
           == nil)
        {
            isSwipeDownGesture = NO;
            [self extendedSymbolButton:nil];
        }
    }
}

// extended button tapped
- (IBAction)extendedSymbolButton:(UIButton *)sender {
    
    [self setOriginalPositionOfSymbolMenuButtons];
    [self.containerViewForSymbolTableview removeFromSuperview];
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsExtendedSymbolSelected] integerValue] == 0)
    {
        [self setInitialStatesOfSymbolMenus];
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsExtendedSymbolSelected];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kSymbolAnimationInterval];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(setFrameOfSymbolTableViewContainerWithY:) withObject:self.extendedSymbolButton afterDelay:kSymbolAnimationInterval];
        
    }
    
    else
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsExtendedSymbolSelected];
        [self setInitialStatesOfSymbolMenus];
        if(isSwipeDownGesture == YES && sender
           == nil)
        {
            isSwipeDownGesture = NO;
            [self extendedSymbolButton:nil];
        }
    }
}

// set original position of symbol menu buttons
-(void) setOriginalPositionOfSymbolMenuButtons
{
    float firstButtonFrameX = self.processSymbolButton.frame.origin.x;
    float firstButtonWidth = self.processSymbolButton.frame.size.width;
    float firstButtonHeight = self.processSymbolButton.frame.size.height;
    
    [self.materialSymbolButton setFrame:CGRectMake(firstButtonFrameX, firstButtonHeight+15, firstButtonWidth, firstButtonHeight)];
    [self.informationSymbolButton setFrame:CGRectMake(firstButtonFrameX, [self getButtonOriginY:self.materialSymbolButton]+20, firstButtonWidth, firstButtonHeight)];
    [self.generalSymbolButton setFrame:CGRectMake(firstButtonFrameX, [self getButtonOriginY:self.informationSymbolButton]+20, firstButtonWidth, firstButtonHeight)];
    [self.extendedSymbolButton setFrame:CGRectMake(firstButtonFrameX, [self getButtonOriginY:self.generalSymbolButton]+20, firstButtonWidth, firstButtonHeight)];
    
    
}

// get button origin y for a sender button
-(float) getButtonOriginY:(UIButton*) sender
{
    return sender.frame.origin.y + 20;
}

-(float) getButtonHeight:(UIButton*) sender
{
    return sender.frame.size.height;
}

-(void) setButtonFrameOnAnimation:(UIButton*)sender
{
    sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+175, sender.frame.size.width, sender.frame.size.height);
}

-(void) setFrameOfSymbolTableViewContainerWithY:(UIButton*)sender
{
    self.containerViewForSymbolTableview.frame = CGRectMake(sender.frame.origin.x,sender.frame.origin.y+37,self.containerViewForSymbolTableview.frame.size.width,kSymbolContainerlHeight);
    
    [self.symbolsMenu addSubview:self.containerViewForSymbolTableview];
    
    
    
    self.containerViewForSymbolTableview.alpha = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kSymbolAnimationInterval];
    
    
    self.containerViewForSymbolTableview.alpha = 1;
    [UIView commitAnimations];
    
    
}

-(void) setFrameForSymbolViewMenu
{
    self.symbolsMenu.frame = CGRectMake(self.symbolsMenu.frame.origin.x-50,self.symbolsMenu.frame.origin.y,kOffsetSymbolsViewFrameWidth,kSubMenuSymbolHeight);
}

-(void) setInitialStatesOfSymbolMenus
{
    [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsProcessSymbolSelected];
    [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsMaterialSymbolSelected];
    [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsInformationSymbolSelected];
    [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsGeneralSymbolSelected];
    [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsExtendedSymbolSelected];
}

-(void) onFingerSwipeDownOnSymbolMenu
{
    isSwipeDownGesture = YES;
    
    if([[self.dictionarySymbolButtonStates objectForKey:kIsProcessSymbolSelected] integerValue] == 1)
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsProcessSymbolSelected];
        [self processSymbolButton:nil];
        return;
    }
    
    else if([[self.dictionarySymbolButtonStates objectForKey:kIsInformationSymbolSelected] integerValue] == 1)
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsInformationSymbolSelected];
        [self informationSymbolButton:nil];
        return;
    }
    
    else if([[self.dictionarySymbolButtonStates objectForKey:kIsMaterialSymbolSelected] integerValue] == 1)
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsMaterialSymbolSelected];
        [self materialSymbolButton:nil];
        return;
    }
    
    else if([[self.dictionarySymbolButtonStates objectForKey:kIsExtendedSymbolSelected] integerValue] == 1)
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:YES] forKey:kIsExtendedSymbolSelected];
        [self extendedSymbolButton:nil];
        return;
    }
    
    else if([[self.dictionarySymbolButtonStates objectForKey:kIsGeneralSymbolSelected] integerValue] == 1)
    {
        [self generalSymbolButton:nil];
        return;
    }
    
    else
    {
        [self.dictionarySymbolButtonStates setObject:[NSNumber numberWithBool:NO] forKey:kIsProcessSymbolSelected];
        [self processSymbolButton:nil];
    }
    
}

-(void) onFingerSwipeUpOnSymbolMenu
{
    [self setOriginalPositionOfSymbolMenuButtons];
    [self.containerViewForSymbolTableview removeFromSuperview];
    [self setInitialStatesOfSymbolMenus];
}

-(void) scrollTableViewToHalf
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kSymbolAnimationInterval];
    [self.containerViewForSymbolTableview setFrame:CGRectMake(self.containerViewForSymbolTableview.frame.origin.x, self.containerViewForSymbolTableview.frame.origin.y, self.containerViewForSymbolTableview.frame.size.width, self.containerViewForSymbolTableview.frame.size.height/4)];
    
    [self setButtonOnHalfFrameOnAnimation:self.materialSymbolButton forClosing:NO];
    
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(setSecondSymbolTableView) withObject:self.processSymbolButton afterDelay:kSymbolAnimationInterval];
}

-(void) setSecondSymbolTableView
{
    [self.symbolsMenu addSubview:self.containerViewForSymbolTableView2];
    [self.containerViewForSymbolTableView2 setFrame:self.containerViewForSymbolTableview.frame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kSymbolAnimationInterval];
    
    [self.containerViewForSymbolTableView2 setFrame:CGRectMake(self.containerViewForSymbolTableview.frame.origin.x, self.containerViewForSymbolTableview.frame.origin.y+130, self.containerViewForSymbolTableView2.frame.size.width, self.containerViewForSymbolTableView2.frame.size.height*1.5)];
    
    //[self setButtonOnHalfFrameOnAnimation:self.materialSymbolButton];
    
    
    [UIView commitAnimations];
    
    isBothSymbolTableViewVisible = YES;
    
    
}

-(void) closeFirstTableViewOnHalfScroll
{
    [self.containerViewForSymbolTableview removeFromSuperview];
    [self.containerViewForSymbolTableView2 removeFromSuperview];
    [self materialSymbolButton:nil];
    isBothSymbolTableViewVisible = NO;
}

-(void) setButtonOnHalfFrameOnAnimation:(UIButton*)sender forClosing:(BOOL) isClose
{
    if(isClose == NO)
    {
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y-80, sender.frame.size.width, sender.frame.size.height);
    }
    
    else
    {
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y-85, sender.frame.size.width, sender.frame.size.height);
    }
}

#pragma mark custom section tableview cell


- (void)reloadTableData {
    [self.symbolsTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  45;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self setSectionHeaderViewForIPadWithTableView:tableView andSection:section];
}

-(UIView*) setSectionHeaderViewForIPadWithTableView:(UITableView *)tableView andSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] autorelease];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    
    //    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 6, tableView.bounds.size.width - 5, 36)] autorelease];
    
    float buttonX = (tableView.bounds.size.width-220)/2;
    
    UIButton * headerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headerBtn setBackgroundColor:[UIColor whiteColor]];
    
    headerBtn.opaque = NO;
    headerBtn.frame = CGRectMake(buttonX, 2, 220, 36.0);
    
    [headerBtn addTarget:self action:@selector(sectionTapped:) forControlEvents:UIControlEventTouchDown];
    [headerView addSubview:headerBtn];
    
    switch (section) {
        case 0:
            [headerBtn setTitle:@"Process" forState:UIControlStateNormal];
            [self settingHeadersButton:headerBtn];
            break;
        case 1:
            [headerBtn setTitle:@"Material" forState:UIControlStateNormal];
            [self settingHeadersButton:headerBtn];
            headerBtn.tag = 1;
            break;
        case 2:
            [headerBtn setTitle:@"Information" forState:UIControlStateNormal];
            [self settingHeadersButton:headerBtn];
            headerBtn.tag = 2;
            break;
        case 3:
            [headerBtn setTitle:@"General" forState:UIControlStateNormal];
            [self settingHeadersButton:headerBtn];
            headerBtn.tag = 3;
            break;
        case 4:
            [headerBtn setTitle:@"Extended" forState:UIControlStateNormal];
            [self settingHeadersButton:headerBtn];
            headerBtn.tag = 4;
            break;
        default:
            return 0;
            break;
    }
    
    
    return headerView;
}

- (void)sectionTapped:(UIButton*)btn {
    [self.symbolsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:btn.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - Autorotation methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end
