//
//  KLBAppDelegate.m
//  Hypnosister
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAppDelegate.h"
#import "KLBHypnosisView.h"

@implementation KLBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    CGRect firstViewFrame = CGRectMake(160, 200, 100, 150); //left, top, width, height
//    NSLog(@"Screen height in points: %f",[[UIScreen mainScreen] bounds].size.height);
//    NSLog(@"Screen scale is %f", [[UIScreen mainScreen] scale]);
    
    // create cgrects for frames
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    //bigRect.size.height *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = YES; //scrolling between two images will disallow "stopping" inbetween them
    [self.window addSubview:scrollView];
    
    KLBHypnosisView *normalView = [[KLBHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:normalView];
    screenRect.origin.x += screenRect.size.width;
    KLBHypnosisView *firstView = [[KLBHypnosisView alloc] initWithFrame:screenRect];
//    [firstView setBackgroundColor:[UIColor redColor]];
    
    [scrollView addSubview:firstView];
    [scrollView setContentSize:bigRect.size];
    
//    CGRect secondFrame = CGRectMake(20, 30, 50, 50);
//    KLBHypnosisView *secondView = [[KLBHypnosisView alloc] initWithFrame:secondFrame];
//    secondView.backgroundColor = [UIColor blueColor];
//    [self.window addSubview:secondView];
//    
//    //adding a view to the first view
//    CGRect thirdFrame = CGRectMake(20, 30, 50, 50);
//    KLBHypnosisView *thirdView = [[KLBHypnosisView alloc] initWithFrame:thirdFrame];
//    thirdView.backgroundColor = [UIColor blueColor];
//    [firstView addSubview:thirdView];
    
    self.window.backgroundColor = [UIColor whiteColor];
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

@end
