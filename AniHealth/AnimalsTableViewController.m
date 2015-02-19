//
//  AnimalsTableViewController.m
//  AniHealth
//
//  Created by Admin on 14.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AnimalsTableViewController.h"

@interface AnimalsTableViewController ()
@property (retain,nonatomic) NSMutableArray             *animals;
@property (retain, nonatomic) AddAnimalViewController   *addAnimal;
@property (retain, nonatomic) MainTableViewController   *mainTableView;

@end

@implementation AnimalsTableViewController

#pragma mark - Private methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        self.mainTableView = [[MainTableViewController alloc] init];
        self.navigationItem.title = @"Animals"; 
        
        UIBarButtonItem *addAninLefBut = [[UIBarButtonItem alloc] initWithTitle:@"AddAnimal"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openAddAnimalForm)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:addAninLefBut, nil];
    }
    return self;
}

- (void) openAddAnimalForm
{
    self.addAnimal = [[AddAnimalViewController alloc] init];
    UINavigationController *aaf_nc = [[UINavigationController alloc] initWithRootViewController:self.addAnimal];
    int animalCoutn = (int)[self.mainTableView.animals count];
    if (animalCoutn ==0)
        self.addAnimal.registNuberAnimal = 0;
    else
    {
        animalCoutn = animalCoutn-1;
        NSManagedObject *note = [self.mainTableView.animals objectAtIndex:animalCoutn];
        self.addAnimal.registNuberAnimal = [[note valueForKey:@"animalID"] integerValue];
    }
    self.addAnimal.edit = NO;
    [self presentViewController:aaf_nc
                       animated:YES
                     completion:nil];
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
    self.animals = [self.moca SelectAll:@"Animals"];
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
    AnimalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimalTableViewCell"
                                                                forIndexPath:indexPath];
    NSManagedObject *note = [self.animals objectAtIndex:indexPath.row];
    cell.nameAnimal.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"animalName"]];
    cell.iconAnimalCell.image = [UIImage imageNamed: [note valueForKey:@"animalIcon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *note = [self.animals objectAtIndex:indexPath.row];
    self.mainTableView.selectedAnimal = [[NSString stringWithFormat:@"%@", [note valueForKey:@"animalID"]] integerValue];
    [self.sideMenuViewController hideMenuViewController];
    UINavigationController *mtvc_nc = [[UINavigationController alloc] initWithRootViewController:self.mainTableView];
    self.sideMenuViewController.contentViewController = mtvc_nc;
    [self.mainTableView gettingDataFromAnimalList:[[NSString stringWithFormat:@"%@", [note valueForKey:@"animalID"]] integerValue]];
    [self.mainTableView.tableView reloadData];
}

@end
