//
//  AnimalInfoViewController.m
//  AniHealth
//
//  Created by Admin on 15.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AnimalInfoViewController.h"

@interface AnimalInfoViewController ()

@end

@implementation AnimalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //Процедура, реализуемая в самом начале работы "Вперёд батьки"
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"AnimalInfo"; //Заголовок NC
        
        
        UIBarButtonItem *retAniInfo = [[UIBarButtonItem alloc] initWithTitle:@"Return" //Создание первой кнопки для NC и присвоение ей псевдонима
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(returnAnimalInfo)];
        
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:retAniInfo, nil]; //Присвоение двух кнопок к левой стороне NC
        
        
    }
    return self;
}

-(void) returnAnimalInfo{

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
