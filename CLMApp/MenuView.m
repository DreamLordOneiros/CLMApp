//
//  MenuView.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()

@end

@implementation MenuView
@synthesize viewContacts, viewDirections, viewMoney, viewSavings, iconContacts, iconDirections, iconMoney, iconSavings, sidebarButton, contactsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    viewContacts.layer.cornerRadius = 60.0;
    viewContacts.layer.borderWidth = 6.0;
    viewContacts.layer.borderColor = [[UIColor grayColor] CGColor];
    viewContacts.layer.masksToBounds = YES;
    
    viewMoney.layer.cornerRadius = 60.0;
    viewMoney.layer.borderWidth = 6.0;
    viewMoney.layer.borderColor = [[UIColor blackColor] CGColor];
    viewMoney.layer.masksToBounds = YES;
    
    viewSavings.layer.cornerRadius = 60.0;
    viewSavings.layer.borderWidth = 6.0;
    viewSavings.layer.borderColor = [[UIColor blackColor] CGColor];
    viewSavings.layer.masksToBounds = YES;
    
    viewDirections.layer.cornerRadius = 60.0;
    viewDirections.layer.borderWidth = 6.0;
    viewDirections.layer.borderColor = [[UIColor grayColor] CGColor];
    viewDirections.layer.masksToBounds = YES;
    
    /*iconImage.layer.cornerRadius = 60.0;
    iconImage.layer.borderWidth = 3.0;
    iconImage.layer.borderColor = [[UIColor blueColor] CGColor];
    iconImage.layer.masksToBounds = YES;*/
    
    // Change button color
    sidebarButton.tintColor = [UIColor blackColor];//[UIColor colorWithWhite:0.96f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toContacts:(id)sender
{
    NSLog(@"Hey");
}
@end
