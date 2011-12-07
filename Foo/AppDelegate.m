//
//  AppDelegate.m
//  Foo
//
//  Created by Muhammad Taufik on 11/22/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

#import <RestKit/RestKit.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // First created instance will be assigned as sharedManager 
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://api.twitter.com"];
    
    RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Foo.sqlite"];
    objectManager.objectStore = objectStore;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
        
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    //UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];

    UINavigationController *tweetNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    //self.tabBarController = [[UITabBarController alloc] init];
    //self.tabBarController.viewControllers = [NSArray arrayWithObjects:tweetNavigationController, viewController2, nil];
    self.window.rootViewController = tweetNavigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
/*
    NSData *requestBody = [response body];
    NSError *newError;
    NSJSONSerialization *JSONData = [NSJSONSerialization JSONObjectWithData:requestBody options:NSJSONReadingAllowFragments error:&newError];
    NSLog(@"The posts data is: %@", [JSONData valueForKey:@"posts"]);
//    NSLog(@"The posts data is: %@", [[JSONData valueForKey:@"posts"] valueForKey:@"description"]);
    
    if ([response isJSON]) {
        NSLog(@"Yes, it is.");
        NSLog(@"The MIME type: %@", [response MIMEType] );
        NSLog(@"The URL address is: %@", [response URL] );
        NSLog (@"All header fields is: %@", [[response allHeaderFields] valueForKey:@"Date"]);
    }
 */
}

@end
