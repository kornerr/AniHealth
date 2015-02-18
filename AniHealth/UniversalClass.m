//
//  ManagedObjectContectAll.m
//  AniHealth
//
//  Created by Admin on 16.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "UniversalClass.h"

@implementation UniversalClass


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSMutableArray *)SelectAll:(NSString *)entity
{
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;

    NSLog(@"------%@", entity);
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSMutableArray *animals = [[self.managedObjectContextAll executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return animals;
}

- (void)DeleteForIndexPath: (NSIndexPath *)indexPath Array: (NSMutableArray *)array
{
    [self.managedObjectContextAll deleteObject:[array objectAtIndex:indexPath.row]];
    NSError *error = nil;
    if (![self.managedObjectContextAll save:&error])
    {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    [array removeObjectAtIndex:indexPath.row];

}

- (void)SaveAddEvent_SegmentIndex:(NSInteger)segmentIndex AnimalID:(NSNumber *)animalID NameEvent:(NSString *)nameEvent Comment:(NSString *)comment Date:(NSDate *)selectedDate
{
    NSError * error = nil;
    if (segmentIndex == 0)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                inManagedObjectContext:self.managedObjectContextAll];
        [object setValue:nameEvent forKey:@"nameEvent"];
        [object setValue:comment forKey:@"comment"];
        [object setValue:selectedDate forKey:@"dateEvent"];
        [object setValue:animalID forKey:@"idAnimal"];
        if (![self.managedObjectContextAll save:&error])
        {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
    else
    {
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSDayCalendarUnit;
        NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:selectedDate options:0];
        NSInteger days = [components day];
        for (int forI=0; forI<=days; forI++)
        {
            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                    inManagedObjectContext:self.managedObjectContextAll];
            [object setValue:nameEvent forKey:@"nameEvent"];
            [object setValue:comment forKey:@"comment"];
            int daysToAdd = (-1)*forI;
            NSDate *newDate = [selectedDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            [object setValue:newDate forKey:@"dateEvent"];
            [object setValue:animalID forKey:@"idAnimal"];
            if (![self.managedObjectContextAll save:&error])
            {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
        }
    }
}

@end
