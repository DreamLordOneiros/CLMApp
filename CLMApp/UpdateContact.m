//
//  UpdateContact.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "UpdateContact.h"

@interface UpdateContact ()

@end

@implementation UpdateContact
@synthesize myPickerView, account, role, accounts, roles, myPopoverController, delegate;

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
    
    myPickerView.layer.cornerRadius = 20.0;
    myPickerView.layer.borderWidth = 2.5;
    myPickerView.layer.borderColor = [[UIColor grayColor] CGColor];
    myPickerView.layer.masksToBounds = YES;
    
    accounts = [[NSArray alloc] initWithObjects:@"USAA",@"GE", @"Morgan Stanley", @"BOA", nil];
    roles = [[NSArray alloc] initWithObjects:@"Trainee", @"Junior", @"Project Leader", @"HR", nil];
    role = account = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateContact:(id)sender
{
    if([delegate updateContactData:self])
    {
        [myPopoverController dismissPopoverAnimated:YES];
        [self alertConfirmation:sender];
    }
}

-(void) alertConfirmation:(id) sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation!" message:@"Contact updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
        account = row + 1;
    else
        role = row + 1;
}
@end
