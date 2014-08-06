//
//  CalculatorVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "CalculatorVC.h"

@interface CalculatorVC ()
{
    NSString * stack;
    double result;
    int optype;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation CalculatorVC
@synthesize dbAdmin, calcDisplay, opperator, mrString, operationsArray, myTableView, clAdd, clClear, clDivision, clDot, clEight, clEquals, clFive, clFour, clMC, clMinus, clMR, clMulti, clNine, clOne, clPow, clRemove, clSeven, clSign, clSix, clSQRT, clThree, clTwo, clxDivision, clZero, myPopoverController;

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
    //self.view.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:156.0/255.0 blue:130.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor grayColor];

    [self setStyles:clOne];
    [self setStyles:clTwo];
    [self setStyles:clThree];
    [self setStyles:clFour];
    [self setStyles:clFive];
    [self setStyles:clSix];
    [self setStyles:clSeven];
    [self setStyles:clEight];
    [self setStyles:clNine];
    [self setStyles:clZero];
    [self setStyles:clDot];
    
    [self setStylesOp:clRemove];
    [self setStylesOp:clMR];
    [self setStylesOp:clMC];
    [self setStylesOp:clSign];
    [self setStylesOp:clSQRT];
    [self setStylesOp:clPow];
    [self setStylesOp:clxDivision];
    [self setStylesOp:clClear];
    [self setStylesOp:clMinus];
    [self setStylesOp:clMulti];
    [self setStylesOp:clDivision];
    [self setStylesOp:clAdd];
    [self setStylesOp:clEquals];
    
    operationsArray = [[NSMutableArray alloc] init];
    calcDisplay.text = @"0";
    stack = @"";
    mrString = @"";
    
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

- (IBAction)calcZero:(id)sender
{
    [self addnumber:0];
}

- (IBAction)calcOne:(id)sender
{
    [self addnumber:1];
}

- (IBAction)calcTwo:(id)sender
{
    [self addnumber:2];
}

- (IBAction)calcThree:(id)sender
{
    [self addnumber:3];
}

- (IBAction)calcFour:(id)sender
{
    [self addnumber:4];
}

- (IBAction)calcFive:(id)sender
{
    [self addnumber:5];
}

- (IBAction)calcSix:(id)sender
{
    [self addnumber:6];
}

- (IBAction)calcSeven:(id)sender
{
    [self addnumber:7];
}

- (IBAction)calcEight:(id)sender
{
    [self addnumber:8];
}

- (IBAction)calcNine:(id)sender
{
    [self addnumber:9];
}

- (IBAction)calcDot:(id)sender
{
    [self addPoint];
}

- (IBAction)calcEquals:(id)sender
{
    [self logic:0];
}

- (IBAction)calcAdd:(id)sender
{
    [self logic:1];
}

- (IBAction)calcSubstract:(id)sender
{
    [self logic:2];
}

- (IBAction)calcMulti:(id)sender
{
    [self logic:3];
}

- (IBAction)calcDivision:(id)sender
{
    [self logic:4];
}

- (IBAction)calcSign:(id)sender
{
}

- (IBAction)calcClear:(id)sender
{
    stack = @"0";
    result = 0.0;
    optype = -1;
    [calcDisplay setText:stack];
    [opperator setText:@""];
}

- (IBAction)calcXDivision:(id)sender
{
    [self logic:7];
}

- (IBAction)calcPow:(id)sender
{
    [self logic:5];
}

- (IBAction)calcSQRT:(id)sender
{
    [self logic:6];
}

- (IBAction)calcMR:(id)sender
{
    if ([mrString isEqualToString:@""])
        mrString = calcDisplay.text;
    else
    {
        calcDisplay.text  =  stack = mrString;
        [operationsArray addObject:[NSString stringWithFormat:@"State Saved: %@", mrString]];
    }
}

- (IBAction)calcMC:(id)sender
{
    mrString = @"";
    [operationsArray addObject:@"State Cleared"];
}

- (IBAction)calcRemove:(id)sender
{
    [self addnumber:-1];
}

-(void)addnumber:(int)number
{
    if(stack == NULL)
        stack = @"0";
    
    if ([stack isEqualToString: @"0"])
        stack = @"";
    
    if(number > -1)
        stack = [NSString stringWithFormat:@"%1$@%2$d", stack, number];
    else if([stack length] > 0)
        stack = [stack substringToIndex:[stack length] + number];
    
    if([stack length] <= 0)
        stack = @"0";
    [calcDisplay setText:stack];
}

-(void) addPoint
{
    stack = [NSString stringWithFormat:@"%1$@.", stack];
    [calcDisplay setText:stack];
}

-(void)logic:(int)type
{
    if(type == 0)
    {
        if(optype == 1)
        {
            stack = [NSString stringWithFormat:@"%.2f", [stack doubleValue] + result];
        }
        else if(optype == 2)
        {
            stack = [NSString stringWithFormat:@"%.2f", [stack doubleValue] - result];
        }
        else if(optype == 3)
        {
            stack = [NSString stringWithFormat:@"%.2f", [stack doubleValue] * result];
        }
        else if(optype == 4)
        {
            stack = [NSString stringWithFormat:@"%.2f", result / [stack doubleValue]];
        }
        [operationsArray addObject:calcDisplay.text];
        [operationsArray addObject:[NSString stringWithFormat:@"Result: %@", stack]];
        [calcDisplay setText:stack];
        [opperator setText:@"="];
    }
    else if(type == 5)
    {
        [operationsArray addObject:stack];
        [operationsArray addObject:@"x²"];
        stack = [NSString stringWithFormat:@"%.2f", pow([stack doubleValue], 2)];
        [operationsArray addObject:stack];
        [self logic:0];
    }
    else if(type == 6)
    {
        [operationsArray addObject:stack];
        [operationsArray addObject:@"√"];
        stack = [NSString stringWithFormat:@"%.2f", sqrt([stack doubleValue])];
        [operationsArray addObject:stack];
        [self logic:0];
    }
    else if(type == 7)
    {
        if ([stack isEqualToString:@"0"] || [stack isEqualToString:@""])
            NSLog(@"");
        else
            stack = [NSString stringWithFormat:@"%.2f", 1 / [stack doubleValue]];
        [self logic:0];
    }
    else
    {
        [operationsArray addObject:calcDisplay.text];
        if(type == 1)
        {
            [opperator setText:@"+"];
            [operationsArray addObject:@"+"];
        }
        else if(type == 2)
        {
            [opperator setText:@"-"];
            [operationsArray addObject:@"-"];
        }
        else if(type == 3)
        {
            [opperator setText:@"*"];
            [operationsArray addObject:@"*"];
        }
        else if(type == 4)
        {
            [opperator setText:@"/"];
            [operationsArray addObject:@"/"];
        }
        
        optype = type;
        result = [stack doubleValue];
        stack = @"0";
        [calcDisplay setText:stack];
    }
    [myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [operationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalculatorCell * cell = (CalculatorCell*)[tableView dequeueReusableCellWithIdentifier:@"calculatorCell" forIndexPath:indexPath];
    cell.labelOperation.text = [operationsArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Operations Stack";
}

-(void) setStyles:(UIButton*) button
{
    button.layer.cornerRadius = 15.0;
    button.layer.borderWidth = 2.5;
    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    button.layer.masksToBounds = YES;
}

-(void) setStylesOp:(UIButton*) button
{
    button.layer.cornerRadius = 10.0;
    button.layer.borderWidth = 2.5;
    button.layer.borderColor = [[UIColor grayColor] CGColor];
    button.layer.masksToBounds = YES;
}

@end
