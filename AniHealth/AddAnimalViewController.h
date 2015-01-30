//
//  AddAnimalViewController.h
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Animals.h"

@interface AddAnimalViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl   *maleAnimal;
@property (strong, nonatomic) IBOutlet UITextField          *addNameAnimal;
@property (strong, nonatomic) IBOutlet UITextField          *dateAnimal;
@property (strong, nonatomic) IBOutlet UIButton             *iconButton1;
@property (strong, nonatomic) IBOutlet UIButton             *iconButton2;
@property (strong, nonatomic) IBOutlet UIButton             *iconButton3;
@property (strong, nonatomic) IBOutlet UIButton             *iconButton4;

@property (nonatomic) NSInteger registNuberAnimal;

@end
