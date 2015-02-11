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

@interface AppDelegate () <RESideMenuDelegate>

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectContextEvent = _managedObjectContextEvent;
@synthesize managedObjectContextAnimal = _managedObjectContextAnimal;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; //Обозначаем область действия на всю площать экрана
    MainTableViewController *mtvc = [[MainTableViewController alloc]init]; //Объявление формы и присваевание ей псевдонима
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:mtvc]; //Наложение NC поверх формы
    AnimalsTableViewController *atvc = [[AnimalsTableViewController alloc]init];
    UINavigationController *atvc_nc = [[UINavigationController alloc] initWithRootViewController:atvc];
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
//Объявление базы - Начало
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DBAniHea" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DBAniHea.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
//Объявление базы - Конец

- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContextEvent
{
    if(_managedObjectContextEvent != nil)
    {
        return _managedObjectContextEvent;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil)
    {
        _managedObjectContextEvent = [[NSManagedObjectContext alloc] init];
        [_managedObjectContextEvent setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContextEvent;
}

- (NSManagedObjectContext *)managedObjectContextAnimal
{
    if(_managedObjectContextAnimal != nil)
    {
        return _managedObjectContextAnimal;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil)
    {
        _managedObjectContextAnimal = [[NSManagedObjectContext alloc] init];
        [_managedObjectContextAnimal setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContextAnimal;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if(managedObjectContext != nil)
    {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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

@end
