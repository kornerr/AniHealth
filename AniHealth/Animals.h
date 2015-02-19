//
//  Animals.h
//  AniHealth
//
//  Created by Admin on 19.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Animals : NSManagedObject

@property (nonatomic, retain) NSDate * animalBirthdate;
@property (nonatomic, retain) NSString * animalIcon;
@property (nonatomic, retain) NSNumber * animalID;
@property (nonatomic, retain) NSNumber * animalMale;
@property (nonatomic, retain) NSString * animalName;

@end
