//
//  MenuView.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import "ContactsTableView.h"

@interface MenuView : UIViewController

@property (strong, nonatomic) ContactsTableView * contactsTableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//- (IBAction)actionContacts:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *iconContacts;
@property (strong, nonatomic) IBOutlet UIView *viewContacts;
- (IBAction)toContacts:(id)sender;

//- (IBAction)actionMoney:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *iconMoney;
@property (strong, nonatomic) IBOutlet UIView *viewMoney;

//- (IBAction)actionSavings:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *iconSavings;
@property (strong, nonatomic) IBOutlet UIView *viewSavings;


//- (IBAction)actionDirections:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *iconDirections;
@property (strong, nonatomic) IBOutlet UIView *viewDirections;
@end
