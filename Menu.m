//
//  Menu.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "Menu.h"

@interface Menu ()

@end

@implementation Menu
@synthesize menuItems, dbAdmin, popOver;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dbAdmin = [[DBAdmin alloc] init];
    
    [dbAdmin prepareDBPath];
    [dbAdmin checkForDB];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    menuItems = [[NSArray alloc] initWithObjects:@"menuCell", @"contactsCell", @"moneyCell", @"calculatorCell", @"directionsCell", @"currencyCell", @"addressBookCell", @"calendarCell", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // configure the segue.
    if ( ([segue isKindOfClass: [SWRevealViewControllerSegue class]] ))
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
        
        //if ([segue.identifier isEqualToString:@"buttonSegueCurrency"])
          //  destination = [[CurrencyVC alloc] init];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 3) || (indexPath.row == 5))
    {
        if ([popOver isPopoverVisible])
            [popOver dismissPopoverAnimated:YES];
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
            
            id poObject;
            
            if (indexPath.row == 3)
                poObject = (CalculatorVC*)[storyboard instantiateViewControllerWithIdentifier:@"calculatorPO"];
            else
                poObject = (CurrencyVC*)[storyboard instantiateViewControllerWithIdentifier:@"currencyPO"];
        
            popOver = [[UIPopoverController alloc] initWithContentViewController:poObject];
            [poObject setMyPopoverController: popOver];
        
            [popOver setContentViewController:poObject];
            ContactCell *cell = (ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
                
            CGRect rect = CGRectMake(cell.bounds.origin.x+100, cell.bounds.origin.y+10, 50, 30);
            [popOver presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
}

@end
