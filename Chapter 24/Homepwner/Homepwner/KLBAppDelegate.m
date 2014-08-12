//
//  KLBAppDelegate.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAppDelegate.h"
#import "KLBItemsViewController.h"
#import "KLBItemStore.h"

@interface KLBAppDelegate ()
@property (nonatomic) KLBItemsViewController *ivc;
@end

@implementation KLBAppDelegate
@synthesize ivc;

//method gets called BEFORE state restoration starts
- (BOOL)application:(UIApplication *)application
willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //we set up the view hierarchy if state restoration doesn't kick in
    if (!self.window.rootViewController)
    {
        NSLog(@"State restoration failed - manually initializing view hierarchy!");
        
        // Override point for customization after application launch.
        ivc = [[KLBItemsViewController alloc]init];
    
        [[ivc tableView] setRowHeight:60];
    
        UINavigationController *unc = [[UINavigationController alloc]initWithRootViewController:ivc];
    
        // Give the navigation controller a restoration identifier that is
        // the same name as the class
        unc.restorationIdentifier = NSStringFromClass([unc class]);
    
        self.window.rootViewController = unc;
    }
    
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL success = [[KLBItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the KLBItems");
    }
    else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [ivc addRandomItem];
//    [(UITableView *)ivc.view reloadData];
//}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application
viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder
{
    // Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    if ([identifierComponents count] == 1) {
        // If there is only 1 identifier component, then
        // this is the root view controller
        self.window.rootViewController = vc;
    }
    else {
        // Else, it is the navigation controller for a new item,
        // so you need to set its modal presentation style
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return vc;
}
@end
