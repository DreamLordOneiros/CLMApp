//
//  ContactPicker.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 12/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPicker : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, retain) id delegate;
@property (nonatomic, strong) NSArray * contacts;
@property (nonatomic, weak) UIPopoverController *myPopoverController;
@property (nonatomic, strong) NSArray * contact;

@end

@protocol contactPickerDelegate <NSObject>

-(BOOL) chooseContact:(ContactPicker*) contact;

@end