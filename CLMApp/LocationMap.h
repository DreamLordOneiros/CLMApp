//
//  LocationMap.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DBAdmin.h"
#import <MapKit/MapKit.h>
#import "ContactPicker.h"

@interface LocationMap : UIViewController<MKMapViewDelegate, UIPopoverControllerDelegate, contactPickerDelegate>
@property (nonatomic, strong) DBAdmin * dbAdmin;
@property (nonatomic, strong) NSArray * contactData;
- (IBAction)changeMapType:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *contactMapLocation;
@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UIImageView *contactAccountImage;

@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UILabel *contactAddress;
@property (strong, nonatomic) IBOutlet UILabel *contactAccount;
@property (strong, nonatomic) IBOutlet UILabel *contactRole;
@property (strong, nonatomic) IBOutlet UILabel *contactANumber;
@property (strong, nonatomic) IBOutlet UILabel *contactPNumber;
@property (strong, nonatomic) IBOutlet UILabel *contactEMail;

@property (strong, nonatomic) MKMapItem *destination;
@property (strong, nonatomic) IBOutlet UIView *mapView;

- (IBAction)findPopOver:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@property (nonatomic, strong) UIPopoverController * popOver;

@end
