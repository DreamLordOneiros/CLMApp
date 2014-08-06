//
//  CurrencyVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "CurrencyVC.h"

@interface CurrencyVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation CurrencyVC
@synthesize currencyDestination, currencyFlag, currencyOrigin, myPickerView, continents, selected, alert, dbAdmin, myPopoverController;

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
    //self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor grayColor];


    alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Input valid data!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    continents = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"PickerData" ofType:@"plist"]];
    selected = 0;

    myPickerView.layer.cornerRadius = 20.0;
    myPickerView.layer.borderWidth = 2.5;
    myPickerView.layer.borderColor = [[UIColor grayColor] CGColor];
    myPickerView.layer.masksToBounds = YES;

    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [currencyOrigin resignFirstResponder];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [continents count];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [continents count];
    else
    {
        if (selected == 0)
            return [[continents valueForKey:[continents allKeys][0]] count];
        else
            return [[continents valueForKey:[continents allKeys][1]] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if ([pickerView isEqual:self.myPickerView])
    {
        if (component == 0)
            return [continents allKeys][row];
        else
            return [[continents valueForKey:[continents allKeys][(int)selected]]allKeys][row];
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        if (row == 0)
        {
            selected = 0;
            [myPickerView reloadComponent:1];
        }
        else
        {
            selected = 1;
            [myPickerView reloadComponent:1];
        }
    }
    else
    {
        if ([currencyOrigin.text isEqualToString:@""])
        {
            [alert show];
        }
        else
        {
            currencyDestination.text = [self convert:[currencyOrigin.text doubleValue] :[[[continents valueForKey:[continents allKeys][(int)selected]] valueForKey:[[continents valueForKey:[continents allKeys][(int)selected]]allKeys][row]] doubleValue]];
        }
        currencyFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [[continents valueForKey:[continents allKeys][(int)selected]]allKeys][row], @".png"]];
    }
}

-(NSString*) convert: (double) _origen : (double) _destino
{
    double resultado = _origen * _destino;
    NSString * result = [NSString stringWithFormat:@"%f", resultado];
    return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
    }
}

@end
