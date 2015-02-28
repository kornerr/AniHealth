//
//  AppDelegate.m
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "AnimalsTableViewController.h"
#import "HistoryTableViewController.h"
#import "UniversalClass.h"

@interface AppDelegate () <RESideMenuDelegate>

@property (nonatomic, retain) UniversalClass *universalClass;
// REVIEW Почему retain? В чём разница от strong?
// REVIEW Что нужно тут ставить на самом деле? Почему?

@end

@implementation AppDelegate

@synthesize managedObjectContext        = _managedObjectContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    self.universalClass = [[UniversalClass alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    AddAnimalViewController *aavc = [[AddAnimalViewController alloc] init];
    aavc.moca = self.universalClass;
    
    AddEventViewController *aevc = [[AddEventViewController alloc] init];
    aevc.moca = self.universalClass;
    
    MainTableViewController *mtvc = [[MainTableViewController alloc]init];
    // REVIEW Пропущен пробел.
    mtvc.moca = self.universalClass;
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:mtvc];
    // REVIEW Нужно использовать camelCase, подчёркивания не используются.
    
    AnimalsTableViewController *atvc = [[AnimalsTableViewController alloc]init];
    // REVIEW Пропущен пробел.
    atvc.moca = self.universalClass;
    UINavigationController *atvc_nc = [[UINavigationController alloc] initWithRootViewController:atvc];
    // REVIEW Нужно использовать camelCase, подчёркивания не используются.
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mtvc_nc
                                                                    leftMenuViewController:atvc_nc
                                                                   rightMenuViewController:nil];
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind:", nil)
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:)
                    withObject:nil
                    afterDelay:5.0];
        [alert show];
        // REVIEW Заменить на Toast.
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    // REVIEW Что это? Где это используется? Зачем?
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AnimalsDB" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AnimalsDB.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
