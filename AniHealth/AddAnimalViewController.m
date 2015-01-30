//
//  AddAnimalViewController.m
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddAnimalViewController.h"




@interface AddAnimalViewController ()

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContext;
@property (nonatomic, retain) NSDate                    *selectedDate;
@property (nonatomic, retain) NSString                  *iconNameAnimal;
@end

@implementation AddAnimalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
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
    NSNumber *registrNumberNewAnimal = [NSNumber numberWithInt: [self registNuberAnimal]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.iconNameAnimal = @"iconAnimal3.png";
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
