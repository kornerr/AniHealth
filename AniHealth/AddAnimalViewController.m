//
//  AddAnimalViewController.m
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddAnimalViewController.h"
#import "MainTableViewController.h"
#import "AnimalsTableViewController.h"
#import "UniversalClass.h"
#import "AppDelegate.h"

@interface AddAnimalViewController ()


@property (nonatomic, retain) NSDate                        *selectedDate;
@property (nonatomic, retain) NSString                      *iconNameAnimal;
@property (nonatomic, retain) MainTableViewController       *mainTableView;
@property (nonatomic, retain) NSString                      *nameAnimalSave;
@property (nonatomic, retain) NSString                      *dateAnimalSave;
@property (nonatomic) NSInteger                             maleAnimalSave;
// REVIEW Что за Save везде?
@property (nonatomic, retain) AnimalsTableViewController    *animalTableView;

@end

@implementation AddAnimalViewController

#pragma mark - Private methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        self.mainTableView = [[MainTableViewController alloc]init];
        // REVIEW Что это? Ведь надо это присваивать в AppDelegate.
        self.moca = [[UniversalClass alloc] init];
        // REVIEW Что это? Ведь мы в AppDelegate присваиваем это.
    }
    return self;
}

- (void) cancelAddAnimalForm
// REVIEW Лишний пробел.
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddAnimal
// REVIEW Лишний пробел. Не хватает пробела.
// REVIEW Что за save?
{
    self.registNuberAnimal = self.registNuberAnimal + 1;
    NSNumber *animalRegistrID = [NSNumber numberWithInt: (int)[self registNuberAnimal]];
    [self.moca SaveAddAnimalName:self.addNameAnimal.text
                 AnimalBirthdate:self.selectedDate
                        IconName:self.iconNameAnimal
                 AnimalRegistrID:animalRegistrID
                  SelectiontMale:self.maleAnimal.selectedSegmentIndex];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveEditAnimal
// REVIEW Лишний пробел. Не хватает пробела.
// REVIEW Что за save?
{
    [self.moca SaveEditAnimalName:self.addNameAnimal.text
                  AnimalBirthdate:self.selectedDate
                         IconName:self.iconNameAnimal
                   SelectiontMale:self.maleAnimal.selectedSegmentIndex
                         AnimalID:self.idAnimal];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        // REVIEW Поменять на @[].
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(saveEditAnimal)];
        self.animals = [self.moca GetAnimalForEditToID:self.idAnimal];
        NSManagedObject *note = [self.animals objectAtIndex:0];
        self.addNameAnimal.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"animalName"]];
        self.nameAnimalSave = self.addNameAnimal.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // REVIEW Это не единственное место конвертации даты. Вынести в
        // REVIEW отдельную функцию в общедоступное место.
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        self.dateAnimal.text = [dateFormat stringFromDate:[note valueForKey:@"animalBirthdate"]];
        self.dateAnimalSave = self.dateAnimal.text;
        BOOL male = [[note valueForKey:@"animalMale"] boolValue];
        if (male)
            self.maleAnimal.selectedSegmentIndex = 0;
        else
            self.maleAnimal.selectedSegmentIndex = 1;
        // REVIEW Заменить на BOOL, если это BOOL. Не надо использовать integer.
        self.maleAnimalSave = self.maleAnimal.selectedSegmentIndex;
    }
    else
    {
        self.navigationItem.title = @"AddAnimal";
        UIBarButtonItem *cancelAddAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelAddAnimalForm)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddAnimal, nil];
        // REVIEW Зачем?
        UIBarButtonItem *saveAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(saveAddAnimal)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveAnimal, nil]; 
        // REVIEW Зачем?
    }
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
    [self.moca DeleteAnimalToID:self.idAnimal];
    [self.sideMenuViewController hideMenuViewController];
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:self.mainTableView];
    self.sideMenuViewController.contentViewController = mtvc_nc;
    [self.mainTableView.tableView reloadData];
    [self.animalTableView.tableView reloadData];
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
        // REVIEW Нельзя ли сразу присовить inputView?
        // REVIEW Какой смысл каждый раз что-то проверять?
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self
                       action:@selector(updateTextField:)
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
    // REVIEW Опять же дата.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches
              withEvent:event];
    [self.view endEditing:YES];
    // REVIEW Заменить на использовать UITapGesture.
}

- (IBAction)clickButtonIcon1:(id)sender
// REVIEW Названия вообще ни о чём не говорят. Переименовать.
{
    self.iconNameAnimal = @"iconAnimal4.png";
}

- (IBAction)clickButtonIcon2:(id)sender
// REVIEW Названия вообще ни о чём не говорят. Переименовать.
{
    self.iconNameAnimal = @"iconAnimal3.png";
}

- (IBAction)clickButtonIcon3:(id)sender
// REVIEW Названия вообще ни о чём не говорят. Переименовать.
{
    self.iconNameAnimal = @"iconAnimal2.png";
}

- (IBAction)clickButtonIcon4:(id)sender
// REVIEW Названия вообще ни о чём не говорят. Переименовать.
{
    self.iconNameAnimal = @"iconAnimal1.png";
}

@end
