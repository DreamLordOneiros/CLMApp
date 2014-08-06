//
//  LoginView.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 03/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation LoginView
@synthesize loginItems, userTextField, passTextField;

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
    loginItems = [[NSArray alloc] initWithObjects:@"userCell", @"passCell", nil];
        
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [loginItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [self.loginItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)loginAction:(id)sender
{
    if ([userTextField.text isEqualToString:@"DreamLord"] && [passTextField.text isEqualToString:@"asdasd"])
        [self performSegueWithIdentifier:@"toMainView" sender:self];
}
@end
