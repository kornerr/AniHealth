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
@property (nonatomic, retain) AppDelegate               *appDelegate;

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.appDelegate = [[AppDelegate alloc] init];
        
    }
    return self;
}

- (void) cancelAddEventForm
{
[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddEvent
{
    NSError * error = nil;
    NSNumber *animalID = [NSNumber numberWithInt: (int)self.idSelectedAnimal];
    if (self.teamsEvent.selectedSegmentIndex == 0)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                inManagedObjectContext:self.appDelegate.managedObjectContextEvent]; // Инициализируем object после IF по причине, описанной ниже
        [object setValue:self.nameEvent.text forKey:@"nameEvent"];
        [object setValue:self.comment.text forKey:@"comment"];
        [object setValue:self.selectedDate forKey:@"dateEvent"];
        [object setValue:animalID forKey:@"idAnimal"];
        if (![self.appDelegate.managedObjectContextEvent save:&error])
        {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
    else
    {
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSDayCalendarUnit;
        NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:self.selectedDate options:0];
        NSInteger days = [components day];
        for (int forI=0; forI<=days; forI++)
        {
            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                    inManagedObjectContext:self.appDelegate.managedObjectContextEvent]; // Инициализация object реализованва в цикле по причине того, что запись его содержимого в базу происходит (предположительно) после завершения куска кода, в которой он инициализируется, иначе будет записан только последний прогон цикла
            [object setValue:self.nameEvent.text forKey:@"nameEvent"];
            [object setValue:self.comment.text forKey:@"comment"];
            int daysToAdd = (-1)*forI;
            NSDate *newDate = [self.selectedDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            [object setValue:newDate forKey:@"dateEvent"];
            [object setValue:animalID forKey:@"idAnimal"];
            if (![self.appDelegate.managedObjectContextEvent save:&error])
            {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveEditEvent
{
    [self.selectedEvent setValue:self.nameEvent.text forKey:@"nameEvent"];
    [self.selectedEvent setValue:self.comment.text forKey:@"comment"];
    [self.selectedEvent setValue:self.selectedDate forKey:@"dateEvent"];
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
        self.nameEvent.text = [NSString stringWithFormat:@"%@", [self.selectedEvent valueForKey:@"nameEvent"]];
        self.nameEventSave = self.nameEvent.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        self.dateEvent.text = [dateFormat stringFromDate:[self.selectedEvent valueForKey:@"dateEvent"]];
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
