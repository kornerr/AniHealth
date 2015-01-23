//
//  AddEventViewController.m
//  AniHealth
//
//  Created by Admin on 15.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContext;

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"AddEvent"; //Заголовок NC
        
        UIBarButtonItem *cancelAddEvent = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(cancelAddEventForm)];
        
        
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddEvent, nil]; //Присвоение двух кнопок к левой стороне NC
        
        UIBarButtonItem *saveEvent = [[UIBarButtonItem alloc] initWithTitle:@"Save" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(saveAddEvent)];
        
       
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveEvent, nil]; //Присвоение двух кнопок к левой стороне NC
        
        
    }
    return self;
}




- (void) cancelAddEventForm{
[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddEvent{
    
    NSError * error = nil;
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                            inManagedObjectContext:self.managedObjectContext];
    [object setValue:self.nameEvent.text forKey:@"nameEvent"];
    [object setValue:self.comment.text forKey:@"comment"];
    
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
