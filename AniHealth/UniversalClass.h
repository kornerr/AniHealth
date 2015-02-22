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
// REVIEW Зачем?

@interface UniversalClass : NSObject
// REVIEW Переименовать в название, соответствующее назначению:
// REVIEW класс для работы с БД. Никакой это не универсальный
// REVIEW класс. Он ведь работает лишь с БД (CoreData).

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContextAll;
@property (nonatomic) id                                target;
@property (nonatomic) SEL                               action;
@property (nonatomic, retain) AppDelegate               *appDelegate;

- (void) CreatedLastID;
// REVIEW Почему прошедшее время?
// REVIEW Лишний пробел.
// REVIEW Здесь и ниже все методы должны начинаться с маленькой буквы (camelCase).
// REVIEW Здесь и ниже лишние пустые строки между методами.
// REVIEW Этому методу не место в этом классе. Все остальные методы
// REVIEW фактически являются абстракцией для работы с CoreData. Этот нет.

- (NSMutableArray *)SelectAll:(NSString *)entity;
// REVIEW Имя метода абсолютно не говорит о том, что возвращается.
// REVIEW С тем же успехом можно поменять на get/select/do. Переименовать.

- (NSMutableArray *)GetAnimalForEditToID:(NSInteger )animalID;
// REVIEW Зачем уточнять цель получения животного (ForEdit)? Это ведь
// REVIEW деталь реализации.
// REVIEW Во-вторых, ByID, а не ToID.
// REVIEW В-третьих, лишний пробел.
// REVIEW В-четвёртых, не припомню использование методов get в iOS.

-(void)DeleteAnimalToID:(NSInteger)animalID;
// REVIEW ByID.

- (NSMutableArray *)DeleteForIndexPath: (NSIndexPath *)indexPath
                     Array: (NSMutableArray *)array;
// REVIEW Опять же не ясно, что за метод.
// REVIEW Здесь и ниже все параметры методов тоже начинаться должны с маленькой.
// REVIEW Нет никакого смысла передавать NSIndexPath, если внутри идёт
// REVIEW работа лишь с NSIndexPath.row, ведь для этого метода
// REVIEW не существует понятия NSIndexPath, для него существует лишь ID записи.

- (void)SaveAddEvent_SegmentIndex:(NSInteger)segmentIndex
                         AnimalID:(NSNumber *)animalID
                        NameEvent:(NSString *)nameEvent
                          Comment:(NSString *)comment
                             Date:(NSDate *)selectedDate;
// REVIEW В именах методах не должно быть подчёркиваний.
// REVIEW В каждом методе тут везде Save. Зачем?

- (void) SaveAddAnimalName:(NSString *)animalName
           AnimalBirthdate:(NSDate *)animalBirthdate
                  IconName:(NSString *)animalIcon
           AnimalRegistrID:(NSNumber *)animalID
            SelectiontMale:(NSInteger )selectiontMale;
// REVIEW В каждом методе тут везде Save. Зачем?

- (void) SaveEditAnimalName:(NSString *)animalName
            AnimalBirthdate:(NSDate *)animalBirthdate
                   IconName:(NSString *)animalIcon
             SelectiontMale:(NSInteger)selectiontMale
                   AnimalID:(NSInteger)animalID;
// REVIEW В каждом методе тут везде Save. Зачем?

- (void) SaveEditEventName:(NSString *)name
                 DateEvent:(NSDate *)date
                   Comment:(NSString *)comment
                     Event:(NSManagedObject *)event;
// REVIEW В каждом методе тут везде Save. Зачем?

@end
