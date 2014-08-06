//
//  PopOverVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 06/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverVC : UIViewController
@property (nonatomic, retain) id delegate;

-(IBAction)buttonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *movementAmmount;
@property (strong, nonatomic) IBOutlet UITextField *movementDetail;
@property (nonatomic, weak) UIPopoverController *myPopoverController;
@end

@protocol addMovementDelegate <NSObject>

-(BOOL) addMovement:(PopOverVC*) sender;

@end
