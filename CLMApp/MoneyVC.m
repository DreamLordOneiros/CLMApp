//
//  MoneyVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 06/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "MoneyVC.h"

@interface MoneyVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation MoneyVC
@synthesize segmentedButton, itemsArray, dbAdmin, myTableView, counter, popOver,addBarButton, amountDebts, amountEarnings, amountExpenses, amountLoans, progressEarnings, progressExpenses, percentageEarnings, percentageExpenses;

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
    counter = 1;
    
    myTableView.layer.cornerRadius = 20.0;
    myTableView.layer.borderWidth = 2.5;
    myTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    myTableView.layer.masksToBounds = YES;
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gray.jpg"]];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];

    [segmentedButton addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self updateProgressBars];
}

-(void) popOverMethod
{
    Class popoverClass = NSClassFromString(@"UIPopoverController");
    if (popoverClass != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        PopOverVC *content = [[PopOverVC alloc] initWithNibName:nil bundle:nil];
        popOver = [[UIPopoverController alloc] initWithContentViewController:content];
        
        content.myPopoverController = self.popOver;
        addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(performAddWithPopover:)];
    }
    
    [self.navigationItem setRightBarButtonItem:addBarButton animated:YES];
}

-(void) updateProgressBars
{
    amountDebts.text = amountEarnings.text = amountExpenses.text = amountLoans.text = @"$0";
    NSArray * movements = [dbAdmin getMovementsAmmounts];
    
    double earn = 0.0, loan = 0.0, expe = 0.0, debt = 0.0;
    
    for (NSArray * array in movements)
    {
        for (NSArray * ammount in array)
        {
            if ([[ammount objectAtIndex:3] isEqualToString:@"1"])
            {
                earn += [[ammount objectAtIndex:2] doubleValue];
                amountEarnings.text = [NSString stringWithFormat:@"%.2f", earn];
            }
            if ([[ammount objectAtIndex:3] isEqualToString:@"2"])
            {
                expe += [[ammount objectAtIndex:2] doubleValue];
                amountExpenses.text = [NSString stringWithFormat:@"%.2f", expe];
            }
            if ([[ammount objectAtIndex:3] isEqualToString:@"3"])
            {
                debt += [[ammount objectAtIndex:2] doubleValue];
                amountDebts.text = [NSString stringWithFormat:@"%.2f", debt];
            }
            if ([[ammount objectAtIndex:3] isEqualToString:@"4"])
            {
                loan += [[ammount objectAtIndex:2] doubleValue];
                amountLoans.text = [NSString stringWithFormat:@"%.2f", loan];
            }
        }
    }
    
    NSLog(@"Earnings: %.2f", (earn/(debt+ earn)));
    NSLog(@"Expenses: %.2f", (loan/(expe+ loan)));
    
    percentageEarnings.text = [NSString stringWithFormat:@"%.0f%@ / %.0f%@",(earn/(debt+ earn) * 100), @"%", (debt/(debt+ earn) * 100), @"%"];
    percentageExpenses.text = [NSString stringWithFormat:@"%.0f%@ / %.0f%@",(expe/(expe+ loan) * 100), @"%", (loan/(loan+ expe) * 100), @"%"];

    [progressEarnings setTintColor:[UIColor blueColor]];
    [progressExpenses setTintColor:[UIColor redColor]];
    
    [progressEarnings setProgress:(earn/(debt+ earn)) animated:YES];
    [progressExpenses setProgress:(expe/(expe+ loan)) animated:YES];
}

- (void) performAddWithPopover:(id)paramSender
{
    [self.popOver presentPopoverFromBarButtonItem:addBarButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateArray:counter];
    NSLog(@"%i", counter);
    return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"moneyCell";
    
    moneyTVCell *cell = (moneyTVCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.moneyAmmount.text = [[itemsArray objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.moneyDetail.text = [[itemsArray objectAtIndex:indexPath.row] objectAtIndex:2];
    
    return cell;
}

-(void) pickOne:(id)sender
{
    UISegmentedControl * segmentedControl = (UISegmentedControl *)sender;
    
    NSLog(@"%@", itemsArray);
    
    counter = [segmentedControl selectedSegmentIndex] + 1;
    itemsArray = [dbAdmin getMovements:[NSString stringWithFormat:@"%i", counter]];
    
    [myTableView reloadData];
}

-(void)updateArray:(NSInteger) count
{
    itemsArray = [dbAdmin getMovements:[NSString stringWithFormat:@"%i", counter]];
}

-(IBAction)popAddMovement:(id)sender
{
    if ([popOver isPopoverVisible])
        [popOver dismissPopoverAnimated:YES];
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
        PopOverVC *popOverVC = [storyboard instantiateViewControllerWithIdentifier:@"popOverVC"];
        
        popOver = [[UIPopoverController alloc] initWithContentViewController:popOverVC];
        popOverVC.delegate = self;
        popOverVC.myPopoverController = popOver;
        
        [popOver setPopoverContentSize:CGSizeMake(120.0f, 110.0f)];
        
        [popOver setContentViewController:popOverVC];
        [popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(BOOL) addMovement:(PopOverVC *)sender
{
    PopOverVC * data = sender;
    if([dbAdmin insertNewMovement:data.movementDetail.text :data.movementAmmount.text :[ NSString stringWithFormat:@"%i",counter]])
    {
        [self.myTableView reloadData];
        [self updateProgressBars];
        return YES;
    }
    return NO;
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
        NSArray * movement;
        
        movement = [dbAdmin getMovements:[NSString stringWithFormat:@"%i", counter]];
        if([dbAdmin deleteMovementByID:[[movement objectAtIndex:indexPath.row] objectAtIndex:0]])
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateProgressBars];
    }
}

@end
