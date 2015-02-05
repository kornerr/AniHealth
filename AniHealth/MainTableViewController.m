#import "MainTableViewController.h"
#import <RESideMenu.h>
#import "Event.h"
#import "Animals.h"

@interface MainTableViewController ()

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

- (void)openAnimalInfo // процедура перехода на другую форму с "Back"
{
    self.addAnimalForm = [[AddAnimalViewController alloc] init]; // Инициализация псивдонима и формы
    self.addAnimalForm.title = @"EditInfo"; //Заголовок формы-назначения
    self.addAnimalForm.edit = (BOOL*)YES;
    [self.navigationController pushViewController:self.addAnimalForm animated:YES]; // способ перехода "puch"
}

- (void)openHistory
{
    self.historyForm = [[HistoryTableViewController alloc] init];
//    [self.historyForm.historyArray addObjectsFromArray:self.pastEvents];
    self.historyForm.historyArray = self.pastEvents;
    [self.navigationController pushViewController:self.historyForm animated:YES];
}

- (void)openAddEvent // процедура перехода на другую форму с "Cancel"
{
    self.addEventForm = [[AddEventViewController alloc] init]; // Инициализация псивдонима и формы
    UINavigationController *aef_nc = [[UINavigationController alloc] initWithRootViewController:self.addEventForm]; // Объявление псевдонима для перехода
    self.addEventForm.idSelectedAnimal = self.selectedAnimal;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.futureEvents = [[NSMutableArray alloc] init];
    self.events = [[NSMutableArray alloc] init];
    self.pastEvents = [[NSMutableArray alloc] init];
    self.allEvents = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequestAllEvents = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequestAllEvents setEntity:entity];
    [fetchRequestAllEvents setResultType:NSDictionaryResultType];
        NSPredicate *predicateAllEvents = [NSPredicate predicateWithFormat:@"idAnimal == %i", self.selectedAnimal];
    [fetchRequestAllEvents setPredicate:predicateAllEvents];
    self.allEvents = [[managedObjectContext executeFetchRequest:fetchRequestAllEvents error:nil] mutableCopy];
    [self.tableView reloadData];
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *stringToday = [dateFormat stringFromDate:today];
    NSDate *currDate = [dateFormat dateFromString:stringToday];
    NSLog(@"Всего записей: %lu и текущая дата: %@", (unsigned long)self.allEvents.count, stringToday);

    if (self.allEvents.count <1)
    {
        self.events = self.allEvents;
    }
    else
    {
        for (int I=0; I<=(self.allEvents.count - 1); I++)
        {
            NSDate *activDate = [dateFormat dateFromString: [dateFormat stringFromDate:[[self.allEvents objectAtIndex:I] objectForKey:@"dateEvent"]]];
            NSDateComponents *components = [gregorian components:unitFlags fromDate:currDate toDate:activDate options:0];
            NSInteger days = [components day];
            NSLog(@"День: %i", days);
            if (days == 0)
            {
                [self.events addObject:[self.allEvents objectAtIndex:I]];
                NSLog(@"Строк в текущем: %i", self.events.count);
            }
            else if (days >0)
            {
                [self.futureEvents addObject:[self.allEvents objectAtIndex:I]];
                NSLog(@"Строк в будущем:%i", self.futureEvents.count);
            }
            else
            {
                [self.pastEvents addObject:[self.allEvents objectAtIndex:I]];
                NSLog(@"Строк в прошлом: %i", self.pastEvents.count);
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)gettingDataFromAnimalList: (NSInteger)number
{
    self.selectedAnimal = number;
    [self.tableView reloadData];
    NSLog(@"Работа getting: %i", self.selectedAnimal);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateEvent" ascending:YES]];//Сортировка по полю "dateEvent" по возрастанию "YES"
    NSArray *sortedTodayArray = [self.events sortedArrayUsingDescriptors:descriptor]; //Создание сортированного массива из массива events по сортировке descriptor
    NSArray *sortedFutureArray = [self.futureEvents sortedArrayUsingDescriptors:descriptor];
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(@"MainTableViewCell") forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
    NSManagedObject *note = [sortedTodayArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"nameEvent"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM hh:mm"];
        cell.dateEvent.text = [dateFormat stringFromDate:[note valueForKey:@"dateEvent"]];
        cell.animalNum.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"idAnimal"]];
    }
    else
    {
        NSManagedObject *note = [sortedFutureArray objectAtIndex:indexPath.row];
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
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.events objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.events removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self saveContext];
        [tableView reloadData]; // tell table to refresh now
    }
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

@end
