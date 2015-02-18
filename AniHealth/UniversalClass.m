//
//  ManagedObjectContectAll.m
//  AniHealth
//
//  Created by Admin on 16.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "UniversalClass.h"

@implementation UniversalClass

- (void)getAppDelegateMOC
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
}

- (NSMutableArray *)SelectAll:(NSString *)entity
{
    [self getAppDelegateMOC];

    NSLog(@"------%@", entity);
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSMutableArray *animals = [[self.managedObjectContextAll executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return animals;
}

- (void)DeleteForIndexPath: (NSIndexPath *)indexPath Array: (NSMutableArray *)array
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
    
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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
    
    NSError * error = nil;
    if (segmentIndex == 0)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                inManagedObjectContext:self.managedObjectContextAll];
        [object setValue:nameEvent forKey:@"name"];
        [object setValue:comment forKey:@"comment"];
        [object setValue:selectedDate forKey:@"date"];
        [object setValue:animalID forKey:@"animalID"];
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
            [object setValue:nameEvent forKey:@"name"];
            [object setValue:comment forKey:@"comment"];
            int daysToAdd = (-1)*forI;
            NSDate *newDate = [selectedDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            [object setValue:newDate forKey:@"date"];
            [object setValue:animalID forKey:@"animalID"];
            if (![self.managedObjectContextAll save:&error])
            {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
        }
    }
}

- (void) SaveAddAnimalName:(NSString *)animalName
           AnimalBirthdate:(NSDate *)animalBirthdate
                  IconName:(NSString *)animalIcon
           AnimalRegistrID:(NSNumber *)animalID
            SelectiontMale:(NSInteger )selectiontMale
{
    [self getAppDelegateMOC];
    
    NSError * error = nil;
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Animals" inManagedObjectContext:self.managedObjectContextAll];
    [object setValue:animalName forKey:@"animalName"];
    [object setValue:animalBirthdate forKey:@"animalBirthdate"];
    [object setValue:animalIcon forKey:@"animalIcon"];
    [object setValue:animalID forKey:@"animalID"];
    if (selectiontMale == 0)
    {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"animalMale"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"animalMale"];
    }
    NSLog(@"Животное: Имя-%@ Дата-%@ Иконка-%@ ID-%@ Пол-%li",animalName,animalBirthdate,animalIcon,animalID,(long)selectiontMale);
    if (![self.managedObjectContextAll save:&error])
    {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }

}

- (void) SaveEditAnimalName:(NSString *)animalName AnimalBirthdate:(NSDate *)animalBirthdate IconName:(NSString *)animalIcon SelectiontMale:(NSInteger )selectiontMale AnimalID:(NSInteger)animalID
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
    
    NSMutableArray *animal = [self GetAnimalForEditToID:animalID];
    NSManagedObject *note = [animal objectAtIndex:0];
    [note setValue:animalName forKey:@"animalName"];
    [note setValue:animalIcon forKey:@"animalIcon"];
    [note setValue:animalBirthdate forKey:@"animalBirthdate"];
    if (selectiontMale == 0)
    {
        [note setValue:[NSNumber numberWithBool:YES] forKey:@"animalMale"];
    }
    else
    {
        [note setValue:[NSNumber numberWithBool:NO] forKey:@"animalMale"];
    }

}

- (NSMutableArray *)GetAnimalForEditToID:(NSInteger )animalID
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequestEditAnimal = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Animals"
                                              inManagedObjectContext:self.managedObjectContextAll];
    [fetchRequestEditAnimal setEntity:entity];
    [fetchRequestEditAnimal setResultType:NSDictionaryResultType];
    NSPredicate *predicateAllEvents = [NSPredicate predicateWithFormat:@"animalID == %i", animalID];
    [fetchRequestEditAnimal setPredicate:predicateAllEvents];
    NSMutableArray *animal = [[self.managedObjectContextAll executeFetchRequest:fetchRequestEditAnimal error:nil] mutableCopy];
    
    return animal;
}

-(void)DeleteAnimalToID:(NSInteger)animalID
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContextAll = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequestAnimal = [[NSFetchRequest alloc] init];
    [fetchRequestAnimal setEntity:[NSEntityDescription entityForName:@"Animals" inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequestAnimal setPredicate:[NSPredicate predicateWithFormat:@"animalID == %i", animalID]];
    NSArray* resultsAnimal = [self.managedObjectContextAll executeFetchRequest:fetchRequestAnimal error:nil];
    for (NSManagedObject * currentObj in resultsAnimal)
    {
        [self.managedObjectContextAll deleteObject:currentObj];
    }
    NSFetchRequest *fetchRequestEvent = [[NSFetchRequest alloc] init];
    [fetchRequestEvent setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequestEvent setPredicate:[NSPredicate predicateWithFormat:@"animalID == %i", animalID]];
    NSArray* resultsEvents = [self.managedObjectContextAll executeFetchRequest:fetchRequestEvent error:nil];
    for (NSManagedObject * currentObj in resultsEvents)
    {
        [self.managedObjectContextAll deleteObject:currentObj];
    }
    NSError* error = nil;
    [self.managedObjectContextAll save:&error];
}

@end
