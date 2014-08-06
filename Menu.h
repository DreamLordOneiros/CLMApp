//
//  Menu.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "ContactsTV.h"
#import "LocationTV.h"
#import "MoneyVC.h"
#import "CalendarVC.h"
#import "CurrencyVC.h"
#import "CalculatorVC.h"
#import "AddressBook.h"
#import "CalendarVC.h"

@interface Menu : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray * menuItems;
@property (strong, nonatomic) DBAdmin * dbAdmin;
@property (nonatomic, strong) UIPopoverController * popOver;

@end
