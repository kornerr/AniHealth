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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.moca = [[UniversalClass alloc]init];
    }
    return self;
}

- (void) cancelAddEventForm
{
[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddEvent
{
    NSNumber *animalID = [NSNumber numberWithInt: (int)self.idSelectedAnimal];
    [self.moca SaveAddEvent_SegmentIndex:self.teamsEvent.selectedSegmentIndex AnimalID:animalID NameEvent:self.nameEvent.text Comment:self.comment.text Date:self.selectedDate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveEditEvent
{
    [self.moca SaveEditEventName:self.nameEvent.text DateEvent:self.selectedDate Comment:self.comment.text Event:self.selectedEvent];
//    [self.selectedEvent setValue:self.nameEvent.text forKey:@"name"];
//    [self.selectedEvent setValue:self.comment.text forKey:@"comment"];
//    [self.selectedEvent setValue:self.selectedDate forKey:@"date"];
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
        self.navigationItem.title = @"AddEvent"; //Заголовок NC
        UIBarButtonItem *cancelAddEvent = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddEventForm)];
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddEvent, nil]; //Присвоение двух кнопок к левой стороне NC
        
        UIBarButtonItem *saveEvent = [[UIBarButtonItem alloc] initWithTitle:@"Save" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(saveAddEvent)];
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveEvent, nil]; //Присвоение двух кнопок к левой стороне NC
    }
//    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    self.managedObjectContext = appDelegate.managedObjectContextEvent;
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
        [datePicker addTarget:self action:@selector(updateTextField:)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
