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

@interface MainTableViewController : UITableViewController


@property (retain, nonatomic)   HistoryTableViewController    *historyForm;
@property (retain, nonatomic)   AddEventViewController    *addEventForm;
@property (retain, nonatomic)   AddAnimalViewController    *addAnimalForm;




@end
