#import "MainTableViewController.h"
#import <RESideMenu.h>

@interface MainTableViewController ()

@property (retain, nonatomic) AnimalsTableViewController *animalTableView;

@end

@implementation MainTableViewController

#pragma mark - Private methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.moca = [[UniversalClass alloc] init];
        self.navigationItem.title = @"Main";
        UIBarButtonItem *aniLeftBut = [[UIBarButtonItem alloc] initWithTitle:@"Animals"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openLeftMenu)];
        UIBarButtonItem *infLeftBut = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openAnimalInfo)];
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:aniLeftBut, infLeftBut, nil];
        UIBarButtonItem *hisRigBut = [[UIBarButtonItem alloc] initWithTitle:@"History"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openHistory)];
        UIBarButtonItem *addRigBut = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openAddEvent)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addRigBut, hisRigBut, nil];
    }
    return self;
}

- (void)openAnimalInfo
{
    self.addAnimalForm = [[AddAnimalViewController alloc] init];
    self.addAnimalForm.edit = YES;
    self.addAnimalForm.idAnimal = self.selectedAnimal;
    [self.navigationController pushViewController:self.addAnimalForm animated:YES];
}

- (void)openHistory
{
    self.historyForm = [[HistoryTableViewController alloc] init];
    self.historyForm.historyArray = self.pastEvents;
    [self.navigationController pushViewController:self.historyForm animated:YES];
}

- (void)openAddEvent
{
    self.addEventForm = [[AddEventViewController alloc] init];
    UINavigationController *aef_nc = [[UINavigationController alloc] initWithRootViewController:self.addEventForm];
    self.addEventForm.idSelectedAnimal = self.selectedAnimal;
    self.addEventForm.edit = NO;
    [self presentViewController:aef_nc
                       animated:YES
                     completion:nil];
}

- (void)openLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"MainTableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableArray *allAnimal = [self.moca SelectAll:@"Animals"];
    NSMutableArray *sis = [self.moca SelectAll:@"System"];
    if (sis.count == 0)
    {
        [self.moca CreatedLastID];
    }    
    if (allAnimal.count == 0)
    {
        self.addAnimalForm = [[AddAnimalViewController alloc] init];
        UINavigationController *aaf_nc = [[UINavigationController alloc] initWithRootViewController:self.addAnimalForm];
        self.addAnimalForm.registNuberAnimal = 0;
        self.addAnimalForm.edit = NO;
        [self presentViewController:aaf_nc
                           animated:YES
                         completion:nil];
    }
    else
    {
        self.futureEvents = [[NSMutableArray alloc] init];
        self.events = [[NSMutableArray alloc] init];
        self.pastEvents = [[NSMutableArray alloc] init];
        self.allEvents = [[NSMutableArray alloc] init];
        NSMutableArray *presAllEvents = [self.moca SelectAll:@"Event"];
                
        if (self.selectedAnimal == 0)
        {
            [self.sideMenuViewController presentLeftMenuViewController];
        }
        else
        {
            if (presAllEvents.count == 0)
            {
                [self openAddEvent];
            }
            else
            {
                for (int Y=0; Y<=(presAllEvents.count - 1); Y++)
                {
                    if ([[[presAllEvents objectAtIndex:Y] objectForKey:@"animalID"] integerValue] == self.selectedAnimal)
                    {
                        [self.allEvents addObject:[presAllEvents objectAtIndex:Y]];
                    }
                }
                NSDate *today = [NSDate date];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSUInteger unitFlags = NSDayCalendarUnit;
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd MMM yyyy"];
                NSString *stringToday = [dateFormat stringFromDate:today];
                NSDate *currDate = [dateFormat dateFromString:stringToday];
                for (int I=0; I<=(self.allEvents.count - 1); I++)
                {
                    NSDate *activDate = [dateFormat dateFromString: [dateFormat stringFromDate:[[self.allEvents objectAtIndex:I] objectForKey:@"date"]]];
                    NSDateComponents *components = [gregorian components:unitFlags fromDate:currDate toDate:activDate options:0];
                    NSInteger days = [components day];
                    if (days == 0)
                    {
                        [self.events addObject:[self.allEvents objectAtIndex:I]];
                    }
                    else if (days >0)
                    {
                        [self.futureEvents addObject:[self.allEvents objectAtIndex:I]];
                    }
                    else
                    {
                        [self.pastEvents addObject:[self.allEvents objectAtIndex:I]];
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)gettingDataFromAnimalList: (NSInteger)number
{
    self.selectedAnimal = number;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.events count];
    else
        return [self.futureEvents count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Сегодня:";
    else
        return @"Грядущие:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    self.sortedTodayArray = [[self.events sortedArrayUsingDescriptors:@[sort]] mutableCopy];
    self.sortedFutureArray = [[self.futureEvents sortedArrayUsingDescriptors:@[sort]] mutableCopy];

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(@"MainTableViewCell") forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        NSManagedObject *note = [self.sortedTodayArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"name"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm"];
        cell.dateEvent.text = [dateFormat stringFromDate:[note valueForKey:@"date"]];
        cell.animalNum.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"animalID"]];
    }
    else
    {
        NSManagedObject *note = [self.sortedFutureArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"name"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM hh:mm"];
        cell.dateEvent.text = [dateFormat stringFromDate:[note valueForKey:@"date"]];
        cell.animalNum.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"animalID"]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath: %@", indexPath);
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == 0)
            self.sortedTodayArray = [self.moca DeleteForIndexPath:indexPath Array:self.sortedTodayArray];
        else
            self.sortedFutureArray = [self.moca DeleteForIndexPath:indexPath Array:self.sortedFutureArray];
        [tableView reloadData];
        [self viewWillAppear:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addEventForm = [[AddEventViewController alloc] init];
    if (indexPath.section ==0)
        self.addEventForm.selectedEvent = [self.sortedTodayArray objectAtIndex:indexPath.row];
    else
        self.addEventForm.selectedEvent = [self.sortedFutureArray objectAtIndex:indexPath.row];
    self.addEventForm.edit = YES;
    [self.navigationController pushViewController:self.addEventForm animated:YES];
}

@end
