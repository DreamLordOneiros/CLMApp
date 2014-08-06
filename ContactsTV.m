//
//  ContactsTV.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 04/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "ContactsTV.h"

@interface ContactsTV ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) NSArray * cellArrays;
@end

@implementation ContactsTV
@synthesize dbAdmin, myTableView, popOver, addBarButton, contactID;

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

    self.cellArrays = [[NSArray alloc] initWithObjects:@"onesCell", @"evenCell", nil];
    
    [self refreshTableView];
    
    myTableView.layer.cornerRadius = 20.0;
    myTableView.layer.borderWidth = 2.5;
    myTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    myTableView.layer.masksToBounds = YES;
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

-(void) refreshTableView
{
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Accounts: %lu", (unsigned long)[[dbAdmin getAccountsList] count]);
    return [[dbAdmin getAccountsList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Account: %@, Ammount: %lu", [[dbAdmin getAccountsList] objectAtIndex:section] ,(unsigned long)[[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:section]] count]);
    return [[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString * cellIdentifier;
    NSArray * contacts = [[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if ((indexPath.section % 2) != 0)
        cellIdentifier = [self.cellArrays objectAtIndex:0];
    else
        cellIdentifier = [self.cellArrays objectAtIndex:1];
    
    ContactCell *cell = (ContactCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.contactID.text = [contacts objectAtIndex:0];
    cell.contactFName.text = [contacts objectAtIndex:1];
    cell.contactLName.text = [contacts objectAtIndex:2];
    cell.contactRole.text = [contacts objectAtIndex:6];
    cell.contactAddress.text = [contacts objectAtIndex:8];
    cell.contactImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [contacts objectAtIndex:0]]];
    
    cell.contactImage.layer.cornerRadius = 20.0;
    cell.contactImage.layer.borderWidth = 2.5;
    cell.contactImage.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.contactImage.layer.masksToBounds = YES;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return [[dbAdmin getAccountsList] objectAtIndex:section];
}

- (IBAction)addContact:(id)sender
{
    if ([popOver isPopoverVisible])
        [popOver dismissPopoverAnimated:YES];
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
        AddContactVC * addpopover = [storyboard instantiateViewControllerWithIdentifier:@"AddContactVC"];
        
        popOver = [[UIPopoverController alloc] initWithContentViewController:addpopover];
        addpopover.delegate = self;
        addpopover.myPopoverController = popOver;
        
        [popOver setContentViewController:addpopover];
        [popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue * rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController * rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        if ([segue.identifier isEqualToString:@"addNewContact"])
        {
            AddContactVC * addContactVC = [segue destinationViewController];
            [addContactVC setDbAdmin:dbAdmin];
        }
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController * svc, UIViewController * dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    
    if ([tableView isEqual:self.myTableView])
        result = UITableViewCellEditingStyleDelete;
    
    return result;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.myTableView setEditing:editing animated:animated];
}

- (void)  tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray * contact = [[dbAdmin getAccountByName:[[dbAdmin getAccountsList] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        if([dbAdmin deleteContactByID:[contact objectAtIndex:0]])
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([popOver isPopoverVisible])
        [popOver dismissPopoverAnimated:YES];
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
        AddContactVC * addpopover = [storyboard instantiateViewControllerWithIdentifier:@"updateView"];
        
        popOver = [[UIPopoverController alloc] initWithContentViewController:addpopover];
        addpopover.delegate = self;
        addpopover.myPopoverController = popOver;
        
        [popOver setContentViewController:addpopover];
        ContactCell *cell = (ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    
        contactID = [cell.contactID.text integerValue];
        
        CGRect rect = CGRectMake(cell.bounds.origin.x+600, cell.bounds.origin.y+10, 50, 30);
        [popOver presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(BOOL) insertContactIntoDB:(AddContactVC*) sender
{
    AddContactVC * contact = sender;
    
    if ([dbAdmin insertNewContact:contact.contactFName :contact.contactLName :contact.contactEmail :contact.contactANumber :contact.contactPNumber :contact.contactAddress :contact.contactAccount :contact.contactRole])
    {
        [self.myTableView reloadData];
        return YES;
    }
    else
        return NO;
}

-(BOOL) updateContactData:(UpdateContact*) sender
{
    UpdateContact * update = sender;
    
    if ([dbAdmin updateContact:contactID :update.account :update.role])
    {
        [self.myTableView reloadData];
        return YES;
    }
    else
        return NO;
}

@end
