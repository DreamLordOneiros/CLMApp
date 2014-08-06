//
//  MainViewController.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 04/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize sidebarButton, buttonAddressBook, buttonCalculator, buttonCalendar, buttonContacts, buttonCurrency, buttonLocation, buttonMoney, dbAdmin;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbAdmin = [[DBAdmin alloc] init];
    
    [dbAdmin prepareDBPath];
    [dbAdmin checkForDB];
    
    // Change button color
    sidebarButton.tintColor = [UIColor blackColor];//[UIColor colorWithWhite:0.96f alpha:1.0f];
    
    /*[self setStyles:buttonAddressBook];
    [self setStyles:buttonCalculator];
    [self setStyles:buttonCalendar];
    [self setStyles:buttonContacts];
    [self setStyles:buttonCurrency];
    [self setStyles:buttonLocation];
    [self setStyles:buttonMoney];*/
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gray.jpg"]];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) setStyles:(UIButton*) button
{
    button.layer.cornerRadius = 20.0;
    //button.layer.borderWidth = 4;
    button.layer.backgroundColor = [[UIColor colorWithRed:230.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0] CGColor];//[[UIColor grayColor] CGColor];
    //button.layer.borderColor = [[UIColor colorWithRed:250.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0] CGColor];
    button.layer.masksToBounds = YES;
}

- (IBAction)actionContacts:(id)sender
{
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue * rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController * rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        id destination;
        
        if ([segue.identifier isEqualToString:@"buttonSegueContacts"])
            destination = [[ContactsTV alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueLocations"])
            destination = [[LocationTV alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueMoney"])
            destination = [[MoneyVC alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueCalculator"])
            destination = [[CalculatorVC alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueCurrency"])
            destination = [[CurrencyVC alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueAddressBook"])
            destination = [[AddressBook alloc] init];
        
        if ([segue.identifier isEqualToString:@"buttonSegueCalendar"])
            destination = [[CalendarVC alloc] init];
        
        destination = [segue destinationViewController];
        [destination setDbAdmin:dbAdmin];
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController * svc, UIViewController * dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}
@end

