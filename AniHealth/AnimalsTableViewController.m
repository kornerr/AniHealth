//
//  AnimalsTableViewController.m
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AnimalsTableViewController.h"
#import "Animals.h"
#import "MainTableViewController.h"

@interface AnimalsTableViewController ()
@property (retain,nonatomic) NSMutableArray         *animals;
@property (retain, nonatomic)   NSManagedObjectID   *managedObjectID;
@property (retain, nonatomic)   AddAnimalViewController *addAnimal;

@end

@implementation AnimalsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Animals"; //Заголовок NC
        
        UIBarButtonItem *addAninLefBut = [[UIBarButtonItem alloc] initWithTitle:@"AddAnimal" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openAddAnimalForm)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:addAninLefBut, nil]; //Присвоение кнопок к левой стороне NC
    }
    return self;
}

- (void) openAddAnimalForm
{
    self.addAnimal = [[AddAnimalViewController alloc] init];
    UINavigationController *aaf_nc = [[UINavigationController alloc] initWithRootViewController:self.addAnimal];

    self.addAnimal.registNuberAnimal = [self.animals count];
    NSLog(@"aninum: %i", self.addAnimal.registNuberAnimal);

    [self presentViewController:aaf_nc
                       animated:YES
                     completion:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnimalTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"AnimalTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext1 = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Animals"];
    self.animals = [[managedObjectContext1 executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.animals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimalTableViewCell" forIndexPath:indexPath];
    NSManagedObject *note = [self.animals objectAtIndex:indexPath.row];
    cell.nameAnimal.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameAnimal"]];
    cell.iconAnimalCell.image = [UIImage imageNamed: [note valueForKey:@"iconAnimal"]];
    cell.idAnimal.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"idAni"]];
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
*/
/*
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
