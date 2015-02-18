//
//  ManagedObjectContectAll.h
//  AniHealth
//
//  Created by Admin on 16.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface UniversalClass : NSObject

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContextAll;
@property (nonatomic) id                                target;
@property (nonatomic) SEL                               action;
@property (nonatomic, retain) AppDelegate               *appDelegate;

- (NSMutableArray *)SelectAll:(NSString *)entity;

- (void)DeleteForIndexPath: (NSIndexPath *)indexPath
                     Array: (NSMutableArray *)array;

- (void)SaveAddEvent_SegmentIndex:(NSInteger)segmentIndex
                         AnimalID:(NSNumber *)animalID
                        NameEvent:(NSString *)nameEvent
                          Comment:(NSString *)comment
                             Date:(NSDate *)selectedDate;
@end
