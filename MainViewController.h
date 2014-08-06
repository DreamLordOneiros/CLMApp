//
//  MainViewController.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 04/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTV.h"
#import "LocationTV.h"
#import "MoneyVC.h"
#import "CalendarVC.h"
#import "CurrencyVC.h"
#import "CalculatorVC.h"
#import "AddressBook.h"
#import "CalendarVC.h"

#import "SWRevealViewController.h"
#import "DBAdmin.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) DBAdmin * dbAdmin;

@property (strong, nonatomic) IBOutlet UIButton *buttonContacts;
@property (strong, nonatomic) IBOutlet UIButton *buttonMoney;
@property (strong, nonatomic) IBOutlet UIButton *buttonCalculator;
@property (strong, nonatomic) IBOutlet UIButton *buttonLocation;
@property (strong, nonatomic) IBOutlet UIButton *buttonCurrency;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddressBook;
@property (strong, nonatomic) IBOutlet UIButton *buttonCalendar;

- (IBAction)actionContacts:(id)sender;
@end
