//
//  LocationTV.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "LocationTV.h"

@interface LocationTV ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation LocationTV
@synthesize dbAdmin, myTableView;

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
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gray.jpg"]];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];
    
    myTableView.layer.cornerRadius = 20.0;
    myTableView.layer.borderWidth = 2.5;
    myTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    myTableView.layer.masksToBounds = YES;
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if ([segue.identifier isEqualToString:@"segueToMapLocation"])
        {
            NSIndexPath * indexPath = [self.myTableView indexPathForSelectedRow];
            LocationMap * location = [segue destinationViewController];
            [location setContactData:[[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
            [location setDbAdmin:dbAdmin];
        }
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController * svc, UIViewController * dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Accounts: %i", [[dbAdmin getAccountsList] count]);
    return [[dbAdmin getAccountsList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Account: %@, Ammount: %i", [[dbAdmin getAccountsList] objectAtIndex:section] ,[[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:section]] count]);
    return [[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:section]] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"contactLocationCell";
    NSArray * contacts = [[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSLog(@"Contact: %@", contacts);
    
    LocationCell *cell = (LocationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.contactName.text = [NSString stringWithFormat:@"%@ %@",[contacts objectAtIndex:1], [contacts objectAtIndex:2]];
    cell.contactImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [contacts objectAtIndex:0]]];
    cell.contactAddress.text = [contacts objectAtIndex:8];
    cell.contactID.text = [contacts objectAtIndex:0];
    
    cell.contactImage.layer.cornerRadius = 20.0;
    cell.contactImage.layer.borderWidth = 2.5;
    cell.contactImage.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.contactImage.layer.masksToBounds = YES;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"Header: %@", [[dbAdmin getAccountsList] objectAtIndex:section]);
    return [[dbAdmin getAccountsList] objectAtIndex:section];
}

@end
