//
//  MGSplitViewAppDelegate.m
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import "VSMAPPAppDelegate.h"
#import "VSMAPPSideMenuPanelViewController.h"
#import "DetailViewController.h"
#import "MGSplitViewController.h"
#import "VSDataManager.h"
#import "VSContants.h"
#import "OBDragDropManager.h"
#import "VSMapPopulationManager.h"

@implementation VSMAPPAppDelegate


@synthesize window=window_;
@synthesize splitViewController=splitViewController_;
@synthesize rootViewController=rootViewController_;
@synthesize detailViewController=detailViewController_;
@synthesize sidePanelNavigationController=sidePanelNavigationController_;


+ (VSMAPPAppDelegate*)sharedAppDelegate{
	return [UIApplication sharedApplication].delegate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(NSDictionary*)convertingDataIntoDictionary:(NSMutableData*)data
{
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSDictionary *myDictionary = [[unarchiver decodeObject] retain];
//    [unarchiver finishDecoding];
//    [unarchiver release];
//    [data release];

    NSError* error;

    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    return json;

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL response;
    
  


    if ([url isFileURL])
    {
        NSLog(@"YES");
        NSMutableData *zippedData = [[NSMutableData alloc] initWithContentsOfURL:url];
        
        [[VSMapPopulationManager sharedPopulationManager] openProjectWithDictionary:[self convertingDataIntoDictionary:zippedData]];
        response=YES;
    }
    
    else
    {
        NSLog(@"NO");
        response=NO;
    }
    
    return response;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        //Do what you want in Landscape Left
    }
    else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //Do what you want in Landscape Right
    }
    else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    {
        //Do what you want in Portrait
    }
    else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //Do what you want in Portrait Upside Down
    }
    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
   // [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if ([url isFileURL])
    {
        NSLog(@"YES I am here");
    }
    
    else
    {
        NSLog(@"NO");

    }

    [DataManager loadAppState];
    [DataManager loadMetaData];
    
    // Add the split view controller's view to the window and display.
    [window_ setRootViewController:splitViewController_]; //addSubview:splitViewController_.view];
    [window_ makeKeyAndVisible];
	
	[rootViewController_ performSelector:@selector(selectFirstRow) withObject:nil afterDelay:0];
	[detailViewController_ performSelector:@selector(configureView) withObject:nil afterDelay:0];
	
    //So that the side Panel is open by default when the view appears
    [splitViewController_ toggleMasterView:self];
    
    [splitViewController_ setHidesBottomBarWhenPushed:YES];
	if (NO) { // whether to allow dragging the divider to move the split.
		splitViewController_.splitWidth = 15.0; // make it wide enough to actually drag!
		splitViewController_.allowsDraggingDivider = YES;
	}

    [self.sidePanelNavigationController setNavigationBarHidden:YES];

    OBDragDropManager *manager = [OBDragDropManager sharedManager];
    [manager prepareOverlayWindowUsingMainWindow:self.window];

    //When the app starts these need to be set to NO
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isAutomation"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isSupplierAdded"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCustomerAdded"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProductionControlAdded"];

    return YES;
}



- (void)dealloc
{
    
    [splitViewController_ release];
    [window_ release];
    [sidePanelNavigationController_ release];
    [super dealloc];
}


@end

