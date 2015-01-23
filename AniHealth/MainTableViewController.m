//
//  MainTableViewController.m
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainTableViewController.h"
#import <RESideMenu.h>
#import "Event.h"


@interface MainTableViewController ()

@property (retain,nonatomic) NSMutableArray *events;

@end

@implementation MainTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Main"; //Заголовок NC
        
        UIBarButtonItem *aniLeftBut = [[UIBarButtonItem alloc] initWithTitle:@"Animals" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openLeftMenu)];
        
        UIBarButtonItem *infLeftBut = [[UIBarButtonItem alloc] initWithTitle:@"Info"//Создание второй кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openAnimalInfo)];
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:aniLeftBut, infLeftBut, nil]; //Присвоение двух кнопок к левой стороне NC
        
        UIBarButtonItem *hisRigBut = [[UIBarButtonItem alloc] initWithTitle:@"History" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openHistory)];
        
        UIBarButtonItem *addRigBut = [[UIBarButtonItem alloc] initWithTitle:@"Add"//Создание второй кнопки для NC и присвоение ей псевдонима
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openAddEvent)];
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addRigBut, hisRigBut, nil]; //Присвоение двух кнопок к левой стороне NC
        
        
    }
    return self;
}

- (void)openAnimalInfo{ // процедура перехода на другую форму с "Back"
    
    self.addAnimalForm = [[AddAnimalViewController alloc] init]; // Инициализация псивдонима и формы
    
    self.addAnimalForm.title = @"EditInfo"; //Заголовок формы-назначения
    [self.navigationController pushViewController:self.addAnimalForm animated:YES]; // способ перехода "puch"
    
}

- (void)openHistory{
    
    self.historyForm = [[HistoryTableViewController alloc] init];
    
    
    [self.navigationController pushViewController:self.historyForm animated:YES];
    
    
    
}

- (void)openAddEvent{ // процедура перехода на другую форму с "Cancel"
    
    self.addEventForm = [[AddEventViewController alloc] init]; // Инициализация псивдонима и формы
    UINavigationController *aef_nc = [[UINavigationController alloc] initWithRootViewController:self.addEventForm]; // Объявление псевдонима для перехода
    [self presentViewController:aef_nc //реализация перехода на форму по заданным псевдонимом
                       animated:YES
                     completion:nil];
}



- (void)openLeftMenu // процедура, вызываемая нажатием кнопки на NC
{
    [self.sideMenuViewController presentLeftMenuViewController]; //вызов бокового меню, реализованного в библиотеки RESideMenu
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"MainTableViewCell"];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    self.events = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
    return [self.events count];
    
    else
        return 1;
    
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(@"MainTableViewCell") forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
    NSManagedObject *note = [self.events objectAtIndex:indexPath.row];
    NSString *nameEve = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameEvent"]];
    
    cell.name.text = nameEve;
    }
    
    // Configure the cell...
    
    return cell;
        
    }



- (void)nameEvent:(NSString *)nameEvent dateEvent:(NSDate *)dateEvent comment:(NSString *)comment history:(NSNumber *)history{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    
    [newManagedObject setValue:nameEvent forKey:@"nameEvent"];
    [newManagedObject setValue:dateEvent forKey:@"dateEvent"];
    [newManagedObject setValue:comment forKey:@"comment"];
    [newManagedObject setValue:history forKey:@"history"];
    
    
    [self saveContext];
    
}

- (void)saveContext
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error = nil;
    
    if(![context save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self saveContext];
        //[tableView reloadData]; // tell table to refresh now
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
