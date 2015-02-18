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

- (NSMutableArray *)GetAnimalForEditToID:(NSInteger )animalID;

-(void)DeleteAnimalToID:(NSInteger)animalID;

- (void)DeleteForIndexPath: (NSIndexPath *)indexPath
                     Array: (NSMutableArray *)array;

- (void)SaveAddEvent_SegmentIndex:(NSInteger)segmentIndex
                         AnimalID:(NSNumber *)animalID
                        NameEvent:(NSString *)nameEvent
                          Comment:(NSString *)comment
                             Date:(NSDate *)selectedDate;

- (void) SaveAddAnimalName:(NSString *)animalName
           AnimalBirthdate:(NSDate *)animalBirthdate
                  IconName:(NSString *)animalIcon
           AnimalRegistrID:(NSNumber *)animalID
            SelectiontMale:(NSInteger )selectiontMale;

- (void) SaveEditAnimalName:(NSString *)animalName
            AnimalBirthdate:(NSDate *)animalBirthdate
                   IconName:(NSString *)animalIcon
             SelectiontMale:(NSInteger)selectiontMale
                   AnimalID:(NSInteger)animalID;

@end
