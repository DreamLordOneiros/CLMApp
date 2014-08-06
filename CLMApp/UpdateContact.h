//
//  UpdateContact.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateContact : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) id delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, weak) UIPopoverController *myPopoverController;

@property (nonatomic) int account;
@property (nonatomic) int role;
@property (nonatomic, strong) NSArray * accounts;
@property (nonatomic, strong) NSArray * roles;
- (IBAction)updateContact:(id)sender;

@end

@protocol updateContactProtocol <NSObject>

-(BOOL) updateContactData:(UpdateContact*) sender;

@end