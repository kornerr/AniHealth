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
@property (strong, nonatomic) IBOutlet UISegmentedControl *maleAnimal;
@property (strong, nonatomic) IBOutlet UITextField *addNameAnimal;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage1;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage2;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage3;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage4;
@property (strong, nonatomic) IBOutlet UITextField *dateAnimal;


@end
