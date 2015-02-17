#import "MainTableViewController.h"
#import <RESideMenu.h>
#import "Event.h"
#import "Animals.h"


@interface MainTableViewController ()

//@property (nonatomic, retain) AppDelegate *appDelegate;

@property (retain, nonatomic) AnimalsTableViewController        *animalTableView;

@end

@implementation MainTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        self.appDelegate = [[AppDelegate alloc] init];
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

- (void)openAnimalInfo // процедура перехода на другую форму с "Back"
{
    self.addAnimalForm = [[AddAnimalViewController alloc] init]; // Инициализация псивдонима и формы
    self.addAnimalForm.edit = YES;
    self.addAnimalForm.idAnimal = self.selectedAnimal;
    [self.navigationController pushViewController:self.addAnimalForm animated:YES]; // способ перехода "puch"
}

- (void)openHistory
{
    self.historyForm = [[HistoryTableViewController alloc] init];
    self.historyForm.historyArray = self.pastEvents;
    [self.navigationController pushViewController:self.historyForm animated:YES];
}

- (void)openAddEvent // процедура перехода на другую форму с "Cancel"
{
    self.addEventForm = [[AddEventViewController alloc] init]; // Инициализация псивдонима и формы
    UINavigationController *aef_nc = [[UINavigationController alloc] initWithRootViewController:self.addEventForm]; // Объявление псевдонима для перехода
    self.addEventForm.idSelectedAnimal = self.selectedAnimal;
    self.addEventForm.edit = NO;
    [self presentViewController:aef_nc //реализация перехода на форму по заданным псевдонимом
                       animated:YES
                     completion:nil];
}

- (void)openLeftMenu // процедура, вызываемая нажатием кнопки на NC
{
    [self.sideMenuViewController presentLeftMenuViewController]; //вызов бокового меню, реализованного в библиотеки RESideMenu
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
//    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    self.managedObjectContextAll = appDelegate.managedObjectContext;

    NSMutableArray *allAnimal = [self.moca SelectAll:@"Animals"];
    
    
//    NSFetchRequest *fetchRequestAnimal = [[NSFetchRequest alloc] init];
//    [fetchRequestAnimal setEntity:[NSEntityDescription entityForName:@"Animals" inManagedObjectContext:self.managedObjectContextAll]];
//    self.animals = [self.managedObjectContextAll executeFetchRequest:fetchRequestAnimal error:nil];
    if (allAnimal.count == 0)
    {
        self.addAnimalForm = [[AddAnimalViewController alloc] init];
        UINavigationController *aaf_nc = [[UINavigationController alloc] initWithRootViewController:self.addAnimalForm];
//        self.addAnimalForm.managedObjectContext = self.managedObjectContextAll;
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
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
//        [fetchRequest setResultType:NSDictionaryResultType];
        NSMutableArray *presAllEvents = [self.moca SelectAll:@"Event"];
        
        NSLog(@"----%@",self.allEvents);
        
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
                if ([[[presAllEvents objectAtIndex:Y] objectForKey:@"idAnimal"] integerValue] == self.selectedAnimal)
                {
                    [self.allEvents addObject:[presAllEvents objectAtIndex:Y]];
                    NSLog(@"----%@",self.allEvents);
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
                NSDate *activDate = [dateFormat dateFromString: [dateFormat stringFromDate:[[self.allEvents objectAtIndex:I] objectForKey:@"dateEvent"]]];
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
    {
        return [self.events count];
    }
    else
    {
        return [self.futureEvents count];
    }
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dateEvent" ascending:YES];
    self.sortedTodayArray = [[self.events sortedArrayUsingDescriptors:@[sort]] mutableCopy]; //Создание сортированного массива из массива events по сортировке descriptor
    self.sortedFutureArray = [[self.futureEvents sortedArrayUsingDescriptors:@[sort]] mutableCopy];

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(@"MainTableViewCell") forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
    NSManagedObject *note = [self.sortedTodayArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameEvent"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm"];
        cell.dateEvent.text = [dateFormat stringFromDate:[note valueForKey:@"dateEvent"]];
        cell.animalNum.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"idAnimal"]];
    }
    else
    {
        NSManagedObject *note = [self.sortedFutureArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameEvent"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM hh:mm"];
        cell.dateEvent.text = [dateFormat stringFromDate:[note valueForKey:@"dateEvent"]];
        cell.animalNum.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"idAnimal"]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSManagedObjectContext *context = [self managedObjectContext];
    NSLog(@"indexPath: %@", indexPath);
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == 0)
        {
            
            [self.moca DeleteForIndexPath:indexPath Array:self.sortedTodayArray];
//            [self.managedObjectContextAll deleteObject:[self.sortedTodayArray objectAtIndex:indexPath.row]];
//            NSError *error = nil;
//            if (![self.managedObjectContextAll save:&error])
//            {
//                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
//                return;
//            }
//            [self.sortedTodayArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self.moca DeleteForIndexPath:indexPath Array:self.sortedFutureArray];
//            NSManagedObject *test = [self.sortedFutureArray objectAtIndex:indexPath.row];
//            
//            NSManagedObjectID *oid = [self.sortedFutureArray valueForKey:@"idAnimal"];
//            NSManagedObject *o = [self.managedObjectContextAll objectWithID:oid];
//                                                                                                                         
//            NSLog(@"Объект на удаление: %@", test);
////            [self.appDelegate.managedObjectContextEvent deleteObject:test];
//            [self.managedObjectContextAll deleteObject:o];
//
//            NSError *error = nil;
//            if (![self.managedObjectContextAll save:&error])
//            {
//                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
//                return;
//            }
//            [self.sortedFutureArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView reloadData];  //tell table to refresh now
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addEventForm = [[AddEventViewController alloc] init];
    if (indexPath.section ==0)
    {
        self.addEventForm.selectedEvent = [self.sortedTodayArray objectAtIndex:indexPath.row];
    }
    else
    {
        self.addEventForm.selectedEvent = [self.sortedFutureArray objectAtIndex:indexPath.row];
    }
    self.addEventForm.edit = YES;
    [self.navigationController pushViewController:self.addEventForm animated:YES];
}

@end
