//
//  AddAnimalViewController.m
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddAnimalViewController.h"

@interface AddAnimalViewController ()

@end

@implementation AddAnimalViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"AddAnimal"; //Заголовок NC
        
        UIBarButtonItem *cancelAddAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelAddAnimalForm)];
        
        
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:cancelAddAnimal, nil]; //Присвоение двух кнопок к левой стороне NC
        
        UIBarButtonItem *saveAnimal = [[UIBarButtonItem alloc] initWithTitle:@"Save" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(saveAddAnimal)];
        
        
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveAnimal, nil]; //Присвоение двух кнопок к левой стороне NC
        
        
    }
    return self;
}

- (void) cancelAddAnimalForm{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveAddAnimal{
    [self dismissViewControllerAnimated:YES completion:nil];
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
