//
//  LoginView.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface LoginView : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray * loginItems;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@end
