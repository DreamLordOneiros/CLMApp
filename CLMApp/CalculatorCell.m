//
//  CalculatorCell.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 09/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "CalculatorCell.h"

@implementation CalculatorCell
@synthesize labelOperation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
