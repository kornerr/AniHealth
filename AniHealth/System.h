//
//  System.h
//  AniHealth
//
//  Created by Admin on 19.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface System : NSManagedObject

@property (nonatomic, retain) NSNumber * firstLaunch;
@property (nonatomic, retain) NSNumber * lastID;

@end
