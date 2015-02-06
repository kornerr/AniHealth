//
//  AddAnimalViewController.m
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddAnimalViewController.h"
#import "MainTableViewController.h"

@interface AddAnimalViewController ()

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContext;
@property (nonatomic, retain) NSDate                    *selectedDate;
@property (nonatomic, retain) NSString                  *iconNameAnimal;
@property (nonatomic, retain) MainTableViewController   *mainTableView;
@property (nonatomic, retain) NSString                  *nameAnimalSave;
@property (nonatomic, retain) NSString                  *dateAnimalSave;
@property (nonatomic) NSInteger                         maleAnimalSave;


@end

@implementation AddAnimalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void) cancelAddAnimalForm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddAnimal
{
    NSError * error = nil;
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Animals" inManagedObjectContext:self.managedObjectContext];
    self.registNuberAnimal = self.registNuberAnimal + 1;
    NSNumber *registrNumberNewAnimal = [NSNumber numberWithInt: (int)[self registNuberAnimal]];
    [object setValue:self.addNameAnimal.text forKey:@"nameAnimal"];
    [object setValue:self.selectedDate forKey:@"date"];
    [object setValue:self.iconNameAnimal forKey:@"iconAnimal"];
    [object setValue:registrNumberNewAnimal forKey:@"idAni"];
    if (self.maleAnimal.selectedSegmentIndex == 0)
    {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"male"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"male"];
    }
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.edit)
    {
        self.navigationItem.title = @"EditAnimal";
        UIBarButtonItem *reset = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(resetAnimalInfo)];
        UIBarButtonItem *deleteAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(daleteAnimal)];
        self.navigationItem.RightBarButtonItems = [[NSArray alloc] initWithObjects:reset, deleteAnimal, nil];
        self.mainTableView = [[MainTableViewController alloc]init];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequestEditAnimal = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Animals"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequestEditAnimal setEntity:entity];
        [fetchRequestEditAnimal setResultType:NSDictionaryResultType];
        NSPredicate *predicateAllEvents = [NSPredicate predicateWithFormat:@"idAni == %i", self.idAnimal];
        [fetchRequestEditAnimal setPredicate:predicateAllEvents];
        self.animals = [[managedObjectContext executeFetchRequest:fetchRequestEditAnimal error:nil] mutableCopy];
        NSManagedObject *note = [self.animals objectAtIndex:0];
        self.addNameAnimal.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameAnimal"]];
        self.nameAnimalSave = self.addNameAnimal.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        self.dateAnimal.text = [dateFormat stringFromDate:[note valueForKey:@"date"]];
        self.dateAnimalSave = self.dateAnimal.text;
        BOOL male = [[note valueForKey:@"male"] boolValue];
        if (male)
        {
            self.maleAnimal.selectedSegmentIndex = 0;
        }
        else
        {
            self.maleAnimal.selectedSegmentIndex = 1;
        }
        self.maleAnimalSave = self.maleAnimal.selectedSegmentIndex;
    }
    else
    {
        self.navigationItem.title = @"AddAnimal"; //Заголовок NC
        UIBarButtonItem *cancelAddAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelAddAnimalForm)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddAnimal, nil]; //Присвоение двух кнопок к левой стороне NC
        UIBarButtonItem *saveAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Save" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(saveAddAnimal)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveAnimal, nil]; //Присвоение двух кнопок к левой стороне NC
    }
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.iconNameAnimal = @"iconAnimal3.png";
}

-(void)resetAnimalInfo
{
    self.addNameAnimal.text = self.nameAnimalSave;
    self.dateAnimal.text = self.dateAnimalSave;
    self.maleAnimal.selectedSegmentIndex = self.maleAnimalSave;
}

-(void)daleteAnimal
{
    NSManagedObjectContext *contextAni = [self managedObjectContext];
    NSFetchRequest *fetchRequestAnimal = [[NSFetchRequest alloc] init];
    [fetchRequestAnimal setEntity:[NSEntityDescription entityForName:@"Animals" inManagedObjectContext:contextAni]];
    [fetchRequestAnimal setPredicate:[NSPredicate predicateWithFormat:@"idAni == %i", self.idAnimal]];
    NSArray* resultsAnimals = [contextAni executeFetchRequest:fetchRequestAnimal error:nil];
    for (NSManagedObject * currentObj in resultsAnimals)
    {
        [contextAni deleteObject:currentObj];
    }
    NSManagedObjectContext *contextEvent = [self managedObjectContext];
    NSFetchRequest *fetchRequestEvent = [[NSFetchRequest alloc] init];
    [fetchRequestEvent setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:contextEvent]];
    [fetchRequestEvent setPredicate:[NSPredicate predicateWithFormat:@"idAnimal == %i", self.idAnimal]];
    NSArray* resultsEvents = [contextEvent executeFetchRequest:fetchRequestEvent error:nil];
    for (NSManagedObject * currentObj in resultsEvents)
    {
        [contextEvent deleteObject:currentObj];
    }
    NSError* error = nil;
    [contextAni save:&error];
    [contextEvent save:&error];
    [self.sideMenuViewController hideMenuViewController];
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:self.mainTableView];
    self.sideMenuViewController.contentViewController = mtvc_nc;
    [self.mainTableView.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)someTextFieldYouch:(UITextField *)sender
{
    if (self.dateAnimal.inputView == nil)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [self.dateAnimal setInputView:datePicker];
    }
}

-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    self.dateAnimal.text = [dateFormat stringFromDate:sender.date];
    self.selectedDate = sender.date;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)clickButtonIcon1:(id)sender
{
    self.iconNameAnimal = @"iconAnimal4.png";
}

- (IBAction)clickButtonIcon2:(id)sender
{
    self.iconNameAnimal = @"iconAnimal3.png";
}

- (IBAction)clickButtonIcon3:(id)sender
{
    self.iconNameAnimal = @"iconAnimal2.png";
}

- (IBAction)clickButtonIcon4:(id)sender
{
    self.iconNameAnimal = @"iconAnimal1.png";
}

@end
