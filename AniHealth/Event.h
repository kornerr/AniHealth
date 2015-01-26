//
//  Event.h
//  AniHealth
//
//  Created by Admin on 19.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Animals;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * nameEvent;
@property (nonatomic, retain) NSDate * dateEvent;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * history;
@property (nonatomic, retain) Animals *animal;

@end