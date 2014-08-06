//
//  PopOverVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 06/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "PopOverVC.h"

@interface PopOverVC ()

@end

@implementation PopOverVC
@synthesize delegate, movementAmmount, movementDetail,myPopoverController;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonTapped:(id)sender
{
    if([delegate addMovement:self])
    {
        [myPopoverController dismissPopoverAnimated:YES];
    }
}
@end
