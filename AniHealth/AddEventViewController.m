//
//  AddEventViewController.m
//  AniHealth
//
//  Created by Admin on 15.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddEventViewController.h"
#import "MainTableViewController.h"

@interface AddEventViewController ()

@property (nonatomic, retain) NSDate                    *selectedDate;
@property (nonatomic, retain) NSString                  *nameEventSave;
@property (nonatomic, retain) NSString                  *dateEventSave;
@property (nonatomic, retain) NSString                  *commentSave;
@property (nonatomic, retain) MainTableViewController   *mainTableView;

@end

@implementation AddEventViewController

#pragma mark - Private methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.moca = [[UniversalClass alloc]init];
    
    return self;
}

- (void) cancelAddEventForm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddEvent
{
    NSNumber *animalID = [NSNumber numberWithInt: (int)self.idSelectedAnimal];
    [self.moca SaveAddEvent_SegmentIndex:self.teamsEvent.selectedSegmentIndex
                                AnimalID:animalID
                               NameEvent:self.nameEvent.text
                                 Comment:self.comment.text
                                    Date:self.selectedDate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveEditEvent
{
    [self.moca SaveEditEventName:self.nameEvent.text
                       DateEvent:self.selectedDate
                         Comment:self.comment.text
                           Event:self.selectedEvent];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.edit)
    {
        self.navigationItem.title = @"EditEvent";
        self.navigationItem.RightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(resetEvent)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(saveEditEvent)];
        self.nameEvent.text = [NSString stringWithFormat:@"%@", [self.selectedEvent valueForKey:@"name"]];
        self.nameEventSave = self.nameEvent.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        self.dateEvent.text = [dateFormat stringFromDate:[self.selectedEvent valueForKey:@"date"]];
        self.dateEventSave = self.dateEvent.text;
        self.comment.text = [NSString stringWithFormat:@"%@", [self.selectedEvent valueForKey:@"comment"]];
        self.commentSave = self.comment.text;
    }
    else
    {
        self.navigationItem.title = @"AddEvent";
        UIBarButtonItem *cancelAddEvent = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddEventForm)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddEvent, nil];
        UIBarButtonItem *saveEvent = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(saveAddEvent)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveEvent, nil];
    }
}

-(void)resetEvent
{
    self.nameEvent.text = self.nameEventSave;
    self.dateEvent.text = self.dateEventSave;
    self.comment.text = self.commentSave;
}

- (IBAction)selectTextFiledDate:(UITextField *)sender
{
    if (self.dateEvent.inputView == nil)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self
                       action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [self.dateEvent setInputView:datePicker];
    }
}

-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy hh mm"];
    self.dateEvent.text = [dateFormat stringFromDate:sender.date];
    self.selectedDate = sender.date;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
