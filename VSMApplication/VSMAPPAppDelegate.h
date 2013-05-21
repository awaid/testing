//
//  MGSplitViewAppDelegate.h
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import <UIKit/UIKit.h>

@class VSMAPPSideMenuPanelViewController;
@class DetailViewController;
@class MGSplitViewController;

@interface VSMAPPAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
    MGSplitViewController *splitViewController_;
    VSMAPPSideMenuPanelViewController *rootViewController_;
    DetailViewController *detailViewController_;
    UINavigationController *sidePanelNavigationController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MGSplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet VSMAPPSideMenuPanelViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (retain, nonatomic) IBOutlet UINavigationController *sidePanelNavigationController;

+ (VSMAPPAppDelegate*)sharedAppDelegate;
@end
