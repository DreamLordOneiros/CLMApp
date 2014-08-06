//
//  MoneyVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 06/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "moneyTVCell.h"
#import "PopOverVC.h"

@interface MoneyVC : UIViewController<UITableViewDataSource, UITableViewDelegate, addMovementDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedButton;
@property (nonatomic) int counter;
@property (strong, nonatomic) NSArray * itemsArray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@property (nonatomic, strong) UIPopoverController * popOver;

@property (strong, nonatomic) IBOutlet UIProgressView *progressEarnings;
@property (strong, nonatomic) IBOutlet UIProgressView *progressExpenses;

@property (strong, nonatomic) IBOutlet UILabel *amountEarnings;
@property (strong, nonatomic) IBOutlet UILabel *amountExpenses;
@property (strong, nonatomic) IBOutlet UILabel *amountDebts;
@property (strong, nonatomic) IBOutlet UILabel *amountLoans;
@property (strong, nonatomic) IBOutlet UILabel *percentageEarnings;
@property (strong, nonatomic) IBOutlet UILabel *percentageExpenses;

-(IBAction)popAddMovement:(id)sender;
@end
