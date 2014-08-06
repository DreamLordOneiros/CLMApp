//
//  AddressBook.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 10/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import <AddressBook/AddressBook.h>
#import "Person.h"

@interface AddressBook : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSInteger counter;
@property (nonatomic) NSInteger sectionCounter;
@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *contactsArray;
@property (nonatomic, strong) Person * person;
@property (nonatomic) ABAddressBookRef addressBook;

@property (strong, nonatomic) NSArray * index;
@property (strong, nonatomic) NSString * letters;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic) BOOL searchFlag;
@property (nonatomic, strong) NSString * searchName;

@property (strong, nonatomic) IBOutlet UITextField * contactTextField;
@end
