//
//  LocationTV.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "LocationCell.h"
#import "LocationMap.h"

@interface LocationTV : UIViewController
@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end
