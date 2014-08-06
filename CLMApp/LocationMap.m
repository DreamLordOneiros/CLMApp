//
//  LocationMap.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 05/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "LocationMap.h"

@interface LocationMap ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation LocationMap
@synthesize contactData, contactImage, contactName, contactAccount, contactAccountImage, contactAddress, contactANumber, contactMapLocation, contactPNumber, contactRole, contactEMail, destination, mapView, addBarButton, popOver, dbAdmin;

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
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];
    
    mapView.layer.cornerRadius = 20.0;
    mapView.layer.borderWidth = 2.5;
    mapView.layer.borderColor = [[UIColor grayColor] CGColor];
    mapView.layer.masksToBounds = YES;
    
    contactImage.layer.cornerRadius = 20.0;
    contactImage.layer.borderWidth = 4.5;
    contactImage.layer.borderColor = [[UIColor blackColor] CGColor];
    contactImage.layer.masksToBounds = YES;
    
    NSLog(@"Contact Data: %@", contactData);
    
    [self fillFields: contactData];
    [self placeLocation: contactData];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    contactMapLocation.showsUserLocation = YES;
    MKUserLocation *userLocation = contactMapLocation.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
                                       20000, 20000);
    [contactMapLocation setRegion:region animated:NO];
    contactMapLocation.delegate = self;
}

- (void)getDirections
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [contactMapLocation addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fillFields:(NSArray*) contact
{
    contactImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [contact objectAtIndex:0]]];
    contactName.text = [NSString stringWithFormat:@"%@ %@", [contact objectAtIndex:1], [contact objectAtIndex:2]];
    contactEMail.text = [contact objectAtIndex:3];
    contactANumber.text = [contact objectAtIndex:4];
    contactPNumber.text = [contact objectAtIndex:5];
    contactAddress.text = [contact objectAtIndex:6];
    contactRole.text = [contact objectAtIndex:8];
    contactAccount.text = [contact objectAtIndex:7];
    //contactAccountImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [contact objectAtIndex:7]]];
    [self getDirections];
}

-(void) placeLocation:(NSArray*) contact
{
    NSString *location = [contact objectAtIndex:6];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = contactMapLocation.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 1200.0;
                         region.span.latitudeDelta /= 1200.0;
                         
                         [contactMapLocation setRegion:region animated:YES];
                         [contactMapLocation addAnnotation:placemark];
                     }
                 }
     ];
}

- (IBAction)changeMapType:(id)sender
{
    if (contactMapLocation.mapType == MKMapTypeStandard)
        contactMapLocation.mapType = MKMapTypeSatellite;
    else
        contactMapLocation.mapType = MKMapTypeStandard;
}
- (IBAction)findPopOver:(id)sender
{
    if ([popOver isPopoverVisible])
        [popOver dismissPopoverAnimated:YES];
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
        ContactPicker * contactPicker = [storyboard instantiateViewControllerWithIdentifier:@"ContactPickerPV"];
        
        popOver = [[UIPopoverController alloc] initWithContentViewController:contactPicker];
        
        contactPicker.delegate = self;
        contactPicker.contacts = [dbAdmin getContacts];
        contactPicker.myPopoverController = popOver;
        
        [popOver setContentViewController:contactPicker];
        [popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(BOOL) chooseContact:(ContactPicker*) contact;
{
    NSLog(@"Contact: %@", contact.contact);
    [self fillFields: contact.contact];
    [self placeLocation: contact.contact];
    return YES;
}
@end
