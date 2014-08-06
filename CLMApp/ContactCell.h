//
//  ContactCell.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *contactFName;
@property (strong, nonatomic) IBOutlet UILabel *contactLName;
@property (strong, nonatomic) IBOutlet UILabel *contactRole;
@property (strong, nonatomic) IBOutlet UILabel *contactAddress;
@property (strong, nonatomic) IBOutlet UILabel *contactID;

@end
