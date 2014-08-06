//
//  ContactsTV.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 04/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "ContactCell.h"
#import "AddContactVC.h"
#import "UpdateContact.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactsTV : UIViewController<UITableViewDataSource, UITableViewDelegate, addContactDelegate, updateContactProtocol>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) DBAdmin * dbAdmin;
@property (nonatomic) int contactID;
- (IBAction)addContact:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@property (nonatomic, strong) UIPopoverController * popOver;

@end
