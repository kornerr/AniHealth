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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.historyArray = [[NSMutableArray alloc] init];

        self.navigationItem.title = @"History"; //Заголовок NC
        UIBarButtonItem *delHystory = [[UIBarButtonItem alloc] initWithTitle:@"Delete" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openActionSheetDeleteHistory)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:delHystory, nil]; //Присвоение двух кнопок к левой стороне NC
    }
    return self;
}

- (void) openActionSheetDeleteHistory
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Select time"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* all = [UIAlertAction
                         actionWithTitle:@"All events"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                         }];
    [view addAction:all];
    UIAlertAction* oneYear = [UIAlertAction
                             actionWithTitle:@"Older than one year"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:oneYear];
    UIAlertAction* sixMonths = [UIAlertAction
                              actionWithTitle:@"Older than six months"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                              }];
    [view addAction:sixMonths];
    UIAlertAction* oneMonth = [UIAlertAction
                              actionWithTitle:@"Older than one month"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                              }];
    [view addAction:oneMonth];
    UIAlertAction* cancel = [UIAlertAction
                              actionWithTitle:@"Cancel"
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
    NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];//Сортировка по полю "dateEvent" по возрастанию "YES"
    NSArray *sortedHistoryArray = [self.historyArray sortedArrayUsingDescriptors:descriptor]; //Создание сортированного массива из массива events по сортировке descriptor
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
