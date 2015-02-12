//
//  AddEventViewController.h
//  AniHealth
//
//  Created by Admin on 15.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "AppDelegate.h"




@interface AddEventViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UITextField          *nameEvent;
@property (strong, nonatomic) IBOutlet UITextView           *comment;
@property (strong, nonatomic) IBOutlet UITextField          *dateEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl   *teamsEvent;
@property (nonatomic) NSInteger                             idSelectedAnimal;
@property (nonatomic) BOOL                                  edit;
@property (retain, nonatomic) NSObject                      *selectedEvent;
//@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;


@end
