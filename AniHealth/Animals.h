//
//  Animals.h
//  AniHealth
//
//  Created by Admin on 02.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Animals : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * iconAnimal;
@property (nonatomic, retain) NSNumber * idAni;
@property (nonatomic, retain) NSNumber * male;
@property (nonatomic, retain) NSString * nameAnimal;
@property (nonatomic, retain) NSSet *events;
@end

@interface Animals (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
