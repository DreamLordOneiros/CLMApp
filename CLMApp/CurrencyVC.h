//
//  CurrencyVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"

@interface CurrencyVC : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *currencyFlag;
@property (strong, nonatomic) IBOutlet UITextField *currencyOrigin;
@property (strong, nonatomic) IBOutlet UITextField *currencyDestination;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (strong, nonatomic) DBAdmin * dbAdmin;
@property (nonatomic, weak) UIPopoverController *myPopoverController;

@property (strong, nonatomic) NSDictionary * continents;
@property (nonatomic) int selected;
@property (strong, nonatomic) UIAlertView * alert;

@end
