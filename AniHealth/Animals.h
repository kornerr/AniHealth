//
//  Animals.h
//  AniHealth
//
//  Created by Admin on 19.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Animals : NSManagedObject

@property (nonatomic, retain) NSString * nameAnimal;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * iconAnimal;
@property (nonatomic, retain) NSNumber * male;
@property (nonatomic, retain) NSSet *events;
@end

@interface Animals (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
