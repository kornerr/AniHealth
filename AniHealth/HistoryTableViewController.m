//
//  HistoryTableViewController.m
//  AniHealth
//
//  Created by Admin on 15.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "MainTableViewController.h"

@interface HistoryTableViewController ()

@property (retain, nonatomic) MainTableViewController *mainTableView;

@end

@implementation HistoryTableViewController

#pragma mark - Private methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        self.historyArray = [[NSMutableArray alloc] init];

        self.navigationItem.title = @"History";
        UIBarButtonItem *delHystory = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openActionSheetDeleteHistory)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:delHystory, nil];
    }
    return self;
}

- (void) openActionSheetDeleteHistory
{
    UIAlertController * view= [UIAlertController alertControllerWithTitle:@"Select time"
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* all = [UIAlertAction actionWithTitle:@"All events"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * action)
                                                {
                                                    [view dismissViewControllerAnimated:YES completion:nil];
                                                }];
    [view addAction:all];
    UIAlertAction* oneYear = [UIAlertAction actionWithTitle:@"Older than one year"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [view addAction:oneYear];
    UIAlertAction* sixMonths = [UIAlertAction actionWithTitle:@"Older than six months"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                    {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [view addAction:sixMonths];
    UIAlertAction* oneMonth = [UIAlertAction actionWithTitle:@"Older than one month"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                                                    {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [view addAction:oneMonth];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                                                    {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"MainTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSArray *sortedHistoryArray = [self.historyArray sortedArrayUsingDescriptors:descriptor];
    cell.name.text = [NSString stringWithFormat:@"%@", [[sortedHistoryArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM hh:mm"];
    cell.dateEvent.text = [dateFormat stringFromDate:[[sortedHistoryArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
