//
//  AddAnimalViewController.h
//  AniHealth
//
//  Created by Admin on 16.01.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconViewController.h"

@interface AddAnimalViewController : UIViewController
@property (retain, nonatomic)   IconViewController    *iconForm;
@property (strong, nonatomic) IBOutlet UIButton *selectIcon;

@end
