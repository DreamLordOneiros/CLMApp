//
//  CalculatorVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import "CalculatorCell.h"

@interface CalculatorVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (strong, nonatomic) IBOutlet UITextField *calcDisplay;
@property (strong, nonatomic) UILabel * opperator;
@property (strong, nonatomic) NSString * mrString;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray * operationsArray;
@property (nonatomic, weak) UIPopoverController *myPopoverController;

- (IBAction)calcZero:(id)sender;
- (IBAction)calcOne:(id)sender;
- (IBAction)calcTwo:(id)sender;
- (IBAction)calcThree:(id)sender;
- (IBAction)calcFour:(id)sender;
- (IBAction)calcFive:(id)sender;
- (IBAction)calcSix:(id)sender;
- (IBAction)calcSeven:(id)sender;
- (IBAction)calcEight:(id)sender;
- (IBAction)calcNine:(id)sender;
- (IBAction)calcDot:(id)sender;

- (IBAction)calcEquals:(id)sender;
- (IBAction)calcAdd:(id)sender;
- (IBAction)calcSubstract:(id)sender;
- (IBAction)calcMulti:(id)sender;
- (IBAction)calcDivision:(id)sender;
- (IBAction)calcSign:(id)sender;
- (IBAction)calcClear:(id)sender;
- (IBAction)calcXDivision:(id)sender;
- (IBAction)calcPow:(id)sender;
- (IBAction)calcSQRT:(id)sender;

- (IBAction)calcMR:(id)sender;
- (IBAction)calcMC:(id)sender;
- (IBAction)calcRemove:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *clRemove;
@property (strong, nonatomic) IBOutlet UIButton *clMC;
@property (strong, nonatomic) IBOutlet UIButton *clMR;
@property (strong, nonatomic) IBOutlet UIButton *clSign;
@property (strong, nonatomic) IBOutlet UIButton *clSQRT;
@property (strong, nonatomic) IBOutlet UIButton *clPow;
@property (strong, nonatomic) IBOutlet UIButton *clxDivision;
@property (strong, nonatomic) IBOutlet UIButton *clClear;
@property (strong, nonatomic) IBOutlet UIButton *clDivision;
@property (strong, nonatomic) IBOutlet UIButton *clMulti;
@property (strong, nonatomic) IBOutlet UIButton *clMinus;
@property (strong, nonatomic) IBOutlet UIButton *clAdd;
@property (strong, nonatomic) IBOutlet UIButton *clZero;
@property (strong, nonatomic) IBOutlet UIButton *clDot;
@property (strong, nonatomic) IBOutlet UIButton *clEquals;
@property (strong, nonatomic) IBOutlet UIButton *clOne;
@property (strong, nonatomic) IBOutlet UIButton *clTwo;
@property (strong, nonatomic) IBOutlet UIButton *clThree;
@property (strong, nonatomic) IBOutlet UIButton *clFour;
@property (strong, nonatomic) IBOutlet UIButton *clFive;
@property (strong, nonatomic) IBOutlet UIButton *clSix;
@property (strong, nonatomic) IBOutlet UIButton *clSeven;
@property (strong, nonatomic) IBOutlet UIButton *clEight;
@property (strong, nonatomic) IBOutlet UIButton *clNine;

@end
