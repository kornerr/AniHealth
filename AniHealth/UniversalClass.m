//
//  ManagedObjectContectAll.m
//  AniHealth
//
//  Created by Admin on 16.02.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "UniversalClass.h"

@implementation UniversalClass

#pragma mark - Public methods

- (void) CreatedLastID
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"System"
                                                            inManagedObjectContext:self.managedObjectContextAll];
    [object setValue:0
              forKey:@"lastID"];
    [object setValue:[NSNumber numberWithBool:YES]
              forKey:@"firstLaunch"];
    NSError * error = nil;
    // REVIEW Лишний пробел.
    if (![self.managedObjectContextAll save:&error])
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
}

- (NSMutableArray *)SelectAll:(NSString *)entity
{
    [self getAppDelegateMOC];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity
                                        inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSMutableArray *array = [[self.managedObjectContextAll executeFetchRequest:fetchRequest
                                                                         error:nil] mutableCopy];
    // REVIEW Почему нет обработки ошибок?
    return array;
}

- (NSMutableArray *)DeleteForIndexPath: (NSIndexPath *)indexPath Array: (NSMutableArray *)array
{
    [self getAppDelegateMOC];
    NSManagedObject *nout = [array objectAtIndex:indexPath.row];
    NSInteger delID = [[NSString stringWithFormat:@"%@", [nout valueForKey:@"eventID"]] integerValue];
    // REVIEW У нас ведь в [nout valueForKey:] уже NSString. Зачем ещё stringWithFormat?
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:self.managedObjectContextAll]];
    NSMutableArray *events = [[self.managedObjectContextAll executeFetchRequest:fetchRequest
                                                                         error:nil] mutableCopy];
    // REVIEW Почему не используется SelectAll?
    for (NSManagedObject *object in events )
    {
        if ([[object valueForKey:@"eventID"] integerValue] == delID)
        {
            [self.managedObjectContextAll deleteObject:object];
            NSError *error = nil;
            if (![self.managedObjectContextAll save:&error])
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            // REVIEW Зачем продолжать что-то делать, если ошибка произошла?
            // REVIEW Ведь не будет полного удаления. Где-то что-то останется.
            [array removeObjectAtIndex:indexPath.row];
            [self DeletedNotifications:object];
        }
    }
    return array;
    // REVIEW Зачем?
}


- (void)SaveAddEvent_SegmentIndex:(NSInteger)segmentIndex AnimalID:(NSNumber *)animalID NameEvent:(NSString *)nameEvent Comment:(NSString *)comment Date:(NSDate *)selectedDate
// REVIEW Разбить по строкам.
{
    [self getAppDelegateMOC];
    NSError * error = nil;
    if (segmentIndex == 0)
        // REVIEW segmentIndex выполняет роль BOOL. Тогда надо просто использовать BOOL.
        // REVIEW Либо разделить на 2 разные функции.
    {
        NSMutableArray *system = [self SelectAll:@"System"];
        NSManagedObject *note = [system objectAtIndex:0];
        NSInteger lastID = [[NSString stringWithFormat:@"%@", [note valueForKey:@"lastID"]] integerValue]+1;
        NSNumber *newID = [NSNumber numberWithInt: (int)lastID];
        [self UpdatingLastID:lastID];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                inManagedObjectContext:self.managedObjectContextAll];
        [object setValue:nameEvent
                  forKey:@"name"];
        [object setValue:comment
                  forKey:@"comment"];
        [object setValue:selectedDate
                  forKey:@"date"];
        [object setValue:animalID
                  forKey:@"animalID"];
        [object setValue:newID
                  forKey:@"eventID"];
        if (![self.managedObjectContextAll save:&error])
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        [self NotificationForEvent:nameEvent Date:selectedDate];
    }
    else
    {
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSDayCalendarUnit;
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:today
                                                      toDate:selectedDate
                                                     options:0];
        NSInteger days = [components day];
        for (int forI=0; forI<=days; forI++)
        {
            NSMutableArray *system = [self SelectAll:@"System"];
            NSManagedObject *note = [system objectAtIndex:0];
            NSInteger lastID = [[NSString stringWithFormat:@"%@", [note valueForKey:@"lastID"]] integerValue]+1;
            NSNumber *newID = [NSNumber numberWithInt: (int)lastID];
            [self UpdatingLastID:lastID];
            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                    inManagedObjectContext:self.managedObjectContextAll];
            [object setValue:nameEvent
                      forKey:@"name"];
            [object setValue:comment
                      forKey:@"comment"];
            int daysToAdd = (-1)*forI;
            NSDate *newDate = [selectedDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            [object setValue:newDate
                      forKey:@"date"];
            [object setValue:animalID
                      forKey:@"animalID"];
            [object setValue:newID
                      forKey:@"eventID"];
            if (![self.managedObjectContextAll save:&error])
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            [self NotificationForEvent:nameEvent Date:selectedDate];
        }
    }
}

- (void) SaveAddAnimalName:(NSString *)animalName AnimalBirthdate:(NSDate *)animalBirthdate IconName:(NSString *)animalIcon AnimalRegistrID:(NSNumber *)animalID SelectiontMale:(NSInteger )selectiontMale
{
    [self getAppDelegateMOC];
    NSError * error = nil;
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Animals"
                                                            inManagedObjectContext:self.managedObjectContextAll];
    [object setValue:animalName
              forKey:@"animalName"];
    [object setValue:animalBirthdate
              forKey:@"animalBirthdate"];
    [object setValue:animalIcon
              forKey:@"animalIcon"];
    [object setValue:animalID
              forKey:@"animalID"];
    if (selectiontMale == 0)
        [object setValue:[NSNumber numberWithBool:YES]
                  forKey:@"animalMale"];
    else
        [object setValue:[NSNumber numberWithBool:NO]
                  forKey:@"animalMale"];
    if (![self.managedObjectContextAll save:&error])
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    // REVIEW Надо сообщать пользователю об ошибке тоже.
}

- (void) SaveEditAnimalName:(NSString *)animalName AnimalBirthdate:(NSDate *)animalBirthdate IconName:(NSString *)animalIcon SelectiontMale:(NSInteger )selectiontMale AnimalID:(NSInteger)animalID
{
    NSMutableArray *animal = [self GetAnimalForEditToID:animalID];
    NSManagedObject *note = [animal objectAtIndex:0];
    [note setValue:animalName
            forKey:@"animalName"];
    [note setValue:animalIcon
            forKey:@"animalIcon"];
    [note setValue:animalBirthdate
            forKey:@"animalBirthdate"];
    if (selectiontMale == 0)
        [note setValue:[NSNumber numberWithBool:YES]
                forKey:@"animalMale"];
    else
        [note setValue:[NSNumber numberWithBool:NO]
                forKey:@"animalMale"];
    NSError *error;
    [self.managedObjectContextAll save:&error];
    // REVIEW Нет проверки на ошибки.
}

- (void) SaveEditEventName:(NSString *)name DateEvent:(NSDate *)date Comment:(NSString *)comment Event:(NSManagedObject *)event
{
    [self getAppDelegateMOC];
    [self DeletedNotifications:event];
    NSInteger delID = [[NSString stringWithFormat:@"%@", [event valueForKey:@"eventID"]] integerValue];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:self.managedObjectContextAll]];
    NSMutableArray *events = [[self.managedObjectContextAll executeFetchRequest:fetchRequest
                                                                          error:nil] mutableCopy];
    for (NSManagedObject *object in events )
    {
        if ([[object valueForKey:@"eventID"] integerValue] == delID)
        {
            [object setValue:name
                     forKey:@"name"];
            [object setValue:comment
                     forKey:@"comment"];
            if (date !=nil)
                [object setValue:date
                          forKey:@"date"];
            NSError *error;
            [self.managedObjectContextAll save:&error];
        }
    }
    [self NotificationForEvent:name Date:date];
}

- (NSMutableArray *)GetAnimalForEditToID:(NSInteger )animalID
{
    [self getAppDelegateMOC];
    NSFetchRequest *fetchRequestEditAnimal = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Animals"
                                              inManagedObjectContext:self.managedObjectContextAll];
    [fetchRequestEditAnimal setEntity:entity];
    NSPredicate *predicateAllEvents = [NSPredicate predicateWithFormat:@"animalID == %i", animalID];
    [fetchRequestEditAnimal setPredicate:predicateAllEvents];
    NSMutableArray *animal = [[self.managedObjectContextAll executeFetchRequest:fetchRequestEditAnimal error:nil] mutableCopy];
    
    return animal;
}

-(void)DeleteAnimalToID:(NSInteger)animalID
{
    [self getAppDelegateMOC];
    NSFetchRequest *fetchRequestAnimal = [[NSFetchRequest alloc] init];
    [fetchRequestAnimal setEntity:[NSEntityDescription entityForName:@"Animals"
                                              inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequestAnimal setPredicate:[NSPredicate predicateWithFormat:@"animalID == %i", animalID]];
    NSArray* resultsAnimal = [self.managedObjectContextAll executeFetchRequest:fetchRequestAnimal error:nil];
    for (NSManagedObject * currentObj in resultsAnimal)
    {
        [self.managedObjectContextAll deleteObject:currentObj];
    }
    NSFetchRequest *fetchRequestEvent = [[NSFetchRequest alloc] init];
    [fetchRequestEvent setEntity:[NSEntityDescription entityForName:@"Event"
                                             inManagedObjectContext:self.managedObjectContextAll]];
    [fetchRequestEvent setPredicate:[NSPredicate predicateWithFormat:@"animalID == %i", animalID]];
    NSArray* resultsEvents = [self.managedObjectContextAll executeFetchRequest:fetchRequestEvent error:nil];
    for (NSManagedObject * currentObj in resultsEvents)
    {
        [self.managedObjectContextAll deleteObject:currentObj];
    }
    NSError* error = nil;
    [self.managedObjectContextAll save:&error];
}

#pragma mark - Private methods

- (void)getAppDelegateMOC
// REVIEW Некорректное название метода. Это же get, а возвращаемый тип void.
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // REVIEW Ни в коем случае нельзя неявно использовать Application.
    // REVIEW Заменить на присвоение контекста сразу в AppDelegate
    // REVIEW этому классу.
    self.managedObjectContextAll = appDelegate.managedObjectContext;
}

-(void) NotificationForEvent:(NSString *)nameEvent Date:(NSDate *)dateEvent
{
    // REVIEW Работу с уведомлениями вынести. Возможно, в отдельный класс.
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateEvent;
    localNotification.alertBody = nameEvent;
    localNotification.alertAction = @"More info";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void) UpdatingLastID: (NSInteger)lastID
{
    [self getAppDelegateMOC];
    NSFetchRequest *allIDs = [[NSFetchRequest alloc] init];
    [allIDs setEntity:[NSEntityDescription entityForName:@"System"
                                  inManagedObjectContext:self.managedObjectContextAll]];
    [allIDs setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * colors = [self.managedObjectContextAll executeFetchRequest:allIDs
                                                                   error:&error];
    for (NSManagedObject * color in colors)
    {
        [self.managedObjectContextAll deleteObject:color];
    }
    NSError *saveError = nil;
    [self.managedObjectContextAll save:&saveError];
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"System"
                                                            inManagedObjectContext:self.managedObjectContextAll];
    [object setValue:[NSNumber numberWithInt:(int)lastID]
              forKey:@"lastID"];
    [object setValue:[NSNumber numberWithBool:YES]
              forKey:@"firstLaunch"];
    if (![self.managedObjectContextAll save:&error])
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
}

-(void)DeletedNotifications:(NSManagedObject *)object
// REVIEW Почему прошедшее время?
// REVIEW Передавать конечную дату. Нет никакого смысла в NSManagedObject тут.
{
    NSArray *localNotifications = [[UIApplication sharedApplication]  scheduledLocalNotifications];
    // REVIEW Нельзя использовать НЕЯВНО Application.
    // REVIEW Application использовать лишь в AppDelegate.
    // REVIEW Тут нужен протокол для работы с уведомлениями, который реализует
    // REVIEW AppDelegate.
    for(UILocalNotification *localNotification in localNotifications)
    {
        if ([localNotification.fireDate isEqualToDate:[object valueForKey:@"date"]])
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    }

}

@end
