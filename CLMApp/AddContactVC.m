//
//  AddContactVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "AddContactVC.h"

@interface AddContactVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) NSArray * fieldsArray;
@end

@implementation AddContactVC
@synthesize dbAdmin, pickerView, contactAccount, contactANumber, contactEmail, contactFName, contactLName, contactPNumber, contactRole, contactAddress, delegate, myPopoverController, accounts, roles, myTableView;

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
    contactPNumber = contactLName = contactFName = contactEmail = contactANumber = contactAddress = @"hola";
    contactAccount = contactRole = 1;
    
    myTableView.layer.cornerRadius = 20.0;
    myTableView.layer.borderWidth = 2.5;
    myTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    myTableView.layer.masksToBounds = YES;
    
    pickerView.layer.cornerRadius = 20.0;
    pickerView.layer.borderWidth = 2.5;
    pickerView.layer.borderColor = [[UIColor grayColor] CGColor];
    pickerView.layer.masksToBounds = YES;
    
    accounts = [[NSArray alloc] initWithObjects:@"USAA",@"GE", @"Morgan Stanley", @"BOA", nil];
    roles = [[NSArray alloc] initWithObjects:@"Trainee", @"Junior", @"Project Leader", @"HR", nil];
    self.fieldsArray = [[NSArray alloc] initWithObjects:@"fnameCell", @"lnameCell", @"emailCell", @"anumberCell", @"pnumberCell", @"addressCell", nil];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [accounts count];
    else
        return [roles count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return [accounts objectAtIndex:row];
    else
        return [roles objectAtIndex:row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fieldsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString * cellIdentifier;

    cellIdentifier = [self.fieldsArray objectAtIndex:indexPath.row];
    
    ContactDataCell *cell = (ContactDataCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

-(void)textFieldDidChange:(UITextField*) textField
{
    NSLog(@"Cosa: %@", textField.text);
    
    if (textField.tag == 0)
        contactFName = textField.text;
    else if (textField.tag == 1)
        contactLName = textField.text;
    else if (textField.tag == 2)
        contactEmail = textField.text;
    else if (textField.tag == 3)
        contactANumber = textField.text;
    else if (textField.tag == 4)
        contactPNumber = textField.text;
    else if (textField.tag == 5)
        contactAddress = textField.text;
}

- (IBAction)insertContact:(id)sender
{
    if (contactFName && contactLName && contactEmail && contactANumber && contactPNumber)
    {
        if([delegate insertContactIntoDB:self])
        {
            [myPopoverController dismissPopoverAnimated:YES];
            [self alertConfirmation:sender];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
        contactAccount = row + 1;
    else
        contactRole = row + 1;
}

-(void) alertConfirmation:(id) sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation!" message:@"Contact added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
}

@end
