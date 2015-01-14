//
//  AppDelegate.m
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; //Обозначаем область действия на всю площать экрана
    MainTableViewController *mtvc = [[MainTableViewController alloc]init]; //Объявление формы и присваевание ей псевдонима (хлеб)
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:mtvc]; //Наложение NC поверх формы
    
    AnimalsTableViewController *atvc = [[AnimalsTableViewController alloc]init]; //(колбаска)
    UINavigationController *atvc_nc = [[UINavigationController alloc] initWithRootViewController:atvc];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mtvc_nc
                                                                    leftMenuViewController:atvc_nc
                                                                   rightMenuViewController:nil];
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
