//
//  AddContactVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "ContactDataCell.h"

@interface AddContactVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) id delegate;
@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (nonatomic, weak) UIPopoverController *myPopoverController;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray * accounts;
@property (strong, nonatomic) NSArray * roles;
- (IBAction)insertContact:(id)sender;

@property (strong, nonatomic) NSString * contactFName;
@property (strong, nonatomic) NSString * contactLName;
@property (strong, nonatomic) NSString * contactEmail;
@property (strong, nonatomic) NSString * contactANumber;
@property (strong, nonatomic) NSString * contactPNumber;
@property (strong, nonatomic) NSString * contactAddress;
@property (nonatomic) NSInteger contactAccount;
@property (nonatomic) NSInteger contactRole;

@end

@protocol addContactDelegate <NSObject>

-(BOOL) insertContactIntoDB:(AddContactVC*) sender;

@end