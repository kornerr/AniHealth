//
//  MainTableViewController.h
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HistoryTableViewController.h"
#import "AddEventViewController.h"
#import "MainTableViewCell.h"
#import "AddAnimalViewController.h"
#import "AnimalsTableViewController.h"
#import "UniversalClass.h"
#import <CoreData/CoreData.h>

@interface MainTableViewController : UITableViewController


@property (retain, nonatomic) HistoryTableViewController        *historyForm;
@property (retain, nonatomic) AddEventViewController            *addEventForm;
@property (retain, nonatomic) AddAnimalViewController           *addAnimalForm;
@property (nonatomic, strong) NSFetchedResultsController        *fetchedResultsController;
@property (retain, nonatomic) NSMutableArray                    *allEvents;
@property (retain, nonatomic) NSMutableArray                    *futureEvents;
@property (retain, nonatomic) NSMutableArray                    *events;
@property (retain, nonatomic) NSMutableArray                    *pastEvents;
@property (nonatomic) NSInteger                                 selectedAnimal;
@property (nonatomic, retain) NSMutableArray                    *sortedTodayArray;
@property (nonatomic, retain) NSMutableArray                    *sortedFutureArray;
@property (retain, nonatomic) NSArray                           *animals;
@property (retain, nonatomic) UniversalClass                    *moca;


-(IBAction)gettingDataFromAnimalList: (NSInteger)number;

@end
