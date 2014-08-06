//
//  CalendarVC.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 11/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "CalendarVC.h"

@interface CalendarVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation CalendarVC
//@synthesize addressBook, eventStore;
@synthesize dbAdmin;

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
    dtForMonth = [NSDate date];
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gray.jpg"]];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];

    [self createCalendar];
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    //[self askPermission];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createCalendar
{
    if ([self.view viewWithTag:1001])
    {
        [[self.view viewWithTag:1001] removeFromSuperview];
    }
    UIView *viewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    viewTmp.tag=1001;
    [self.view addSubview:viewTmp];
    isLeft = YES;
    int X = 0;
    //right now i have create 2*2 matrix of calendar to display on view, in next versions i wll make it dynamic.
    for(int i = 0 ;i < 4;i++)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dtForMonth];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSInteger day = [components day];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSRange totaldaysForMonth = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dtForMonth];//total days of particular month
        dtForMonth = [dtForMonth dateByAddingTimeInterval:Seconds_of_Minute*Minutes_of_Hour*Hours_of_Day*totaldaysForMonth.length];
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        NSString *strMonthName = [[dt monthSymbols] objectAtIndex:month-1];//January,Febryary,March etc...
        strMonthName = [strMonthName stringByAppendingString:[NSString  stringWithFormat:@"- %ld",(long)year]];
        
        X = isLeft ? 60 : 420;
        
        if(i % 2 == 0)
        {
            originY = (i*Origin_of_calendarView)+Static_Y_Space;
        }
        
        NVCalendar  *vwCal = [[NVCalendar alloc] initWithFrame:CGRectMake(X, originY, Width_calendarView,Height_calendarView)];
        X++;
        vwCal.tag = i+100;
        vwCal.layer.masksToBounds = NO;
        vwCal.layer.shadowColor = [UIColor blackColor].CGColor;
        vwCal.layer.shadowOffset = CGSizeMake(20, 20);
        vwCal.layer.shadowOpacity = 0.4;
        vwCal.backgroundColor = [UIColor whiteColor];
        vwCal.layer.cornerRadius = 5.0;
        vwCal.layer.borderColor = [UIColor blackColor].CGColor;
        vwCal.layer.borderWidth = 2.0;
        
        vwCal = [vwCal createCalOfDay:day Month:month Year:year MonthName:strMonthName];
        [viewTmp addSubview:vwCal];
        isLeft = !isLeft;
    }
}
-(IBAction)next
{
    [self createCalendar];
}
-(IBAction)previous
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-Minus_month_for_Previous_Action];
    dtForMonth = [gregorian dateByAddingComponents:components toDate:dtForMonth options:0];
    [self createCalendar];
}

/*-(BOOL) askPermission
{
    eventStore = [[EKEventStore alloc] init];
    
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent])
    {
        case EKAuthorizationStatusAuthorized:
        {
            [self readEvents];
            break;
        }
        case EKAuthorizationStatusDenied:
        {
            [self displayAccessDenied];
            break;
        }
        case EKAuthorizationStatusNotDetermined:
        {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
            {
                 if (granted)
                     [self readEvents];
                 else
                     [self displayAccessDenied];
             }];
            break;
        }
        case EKAuthorizationStatusRestricted:
        {
            [self displayAccessRestricted];
            break;
        }
    }
    return YES;
}

- (EKSource *) sourceInEventStore:(EKEventStore *)paramEventStore sourceType:(EKSourceType)paramType sourceTitle:(NSString *)paramSourceTitle
{
    for (EKSource *source in paramEventStore.sources)
    {
        if (source.sourceType == paramType && [source.title caseInsensitiveCompare:paramSourceTitle] == NSOrderedSame)
            return source;
    }
    return nil;
}

- (EKCalendar *) calendarWithTitle:(NSString *)paramTitle type:(EKCalendarType)paramType inSource:(EKSource *)paramSource forEventType:(EKEntityType)paramEventType
{
    for (EKCalendar *calendar in [paramSource calendarsForEntityType:paramEventType])
    {
        if ([calendar.title caseInsensitiveCompare:paramTitle] == NSOrderedSame && calendar.type == paramType)
            return calendar;
    }
    return nil;
}

- (void) readEvents
{
    eventStore = [[EKEventStore alloc] init];
    
    EKSource *icloudSource = [self sourceInEventStore:eventStore sourceType:EKSourceTypeCalDAV sourceTitle:@"iCloud"];
    
    if (icloudSource == nil)
    {
        NSLog(@"You have not configured iCloud for your device.");
        return;
    }
    
    EKCalendar *calendar = [self calendarWithTitle:@"Calendar" type:EKCalendarTypeCalDAV inSource:icloudSource forEventType:EKEntityTypeEvent];
    
    if (calendar == nil)
    {
        NSLog(@"Could not find the calendar we were looking for.");
        return;
    }
    
    / /The start date will be today
    NSDate *startDate = [NSDate date];
    
    // The end date will be 1 day from today
    NSDate *endDate = [startDate dateByAddingTimeInterval:24 * 60 * 60];
    
    // Create the predicate that we can later pass to the
     event store in order to fetch the events
    NSPredicate *searchPredicate =
    [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:@[calendar]];
    
    // Make sure we succeeded in creating the predicate
    if (searchPredicate == nil)
    {
        NSLog(@"Could not create the search predicate.");
        return;
    }
    
    // Fetch all the events that fall between
     the starting and the ending dates
    NSArray *events = [eventStore eventsMatchingPredicate:searchPredicate];
    
    // Go through all the events and print their information
     out to the console
    if (events != nil)
    {
        NSUInteger counter = 1;
        for (EKEvent *event in events)
        {
            NSLog(@"Event %lu Start Date = %@", (unsigned long)counter, event.startDate);
            
            NSLog(@"Event %lu End Date = %@", (unsigned long)counter, event.endDate);
            
            NSLog(@"Event %lu Title = %@", (unsigned long)counter, event.title);
            
            counter++;
        }
        
    }
    else
        NSLog(@"The array of events for this start/end time is nil.");
}

- (void) displayMessage:(NSString *)paramMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:paramMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void) displayAccessDenied
{
    [self displayMessage:@"Access to the event store is denied."];
}

- (void) displayAccessRestricted
{
    [self displayMessage:@"Access to the event store is restricted."];
}

- (void)eventViewController:(EKEventViewController *)controller
      didCompleteWithAction:(EKEventViewAction)action{
    
    switch (action){
            
        case EKEventViewActionDeleted:{
            NSLog(@"User deleted the event.");
            break;
        }
        case EKEventViewActionDone:{
            NSLog(@"User finished viewing the event.");
            break;
        }
        case EKEventViewActionResponded:{
            NSLog(@"User responsed to the invitation in the event.");
            break;
        }
            
    }
    
}

// 1
//- (void) displayEventViewController{
//
//    EKSource *icloudSource = [self sourceInEventStore:self.eventStore
//                                           sourceType:EKSourceTypeCalDAV
//                                          sourceTitle:@"iCloud"];
//
//    if (icloudSource == nil){
//        NSLog(@"You have not configured iCloud for your device.");
//        return;
//    }
//
//    NSSet *calendars = [icloudSource
//                        calendarsForEntityType:EKEntityTypeEvent];
//
//    NSTimeInterval NSOneYear = 1 * 365 * 24.0f * 60.0f * 60.0f;
//    NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:-NSOneYear];
//    NSDate *endDate = [NSDate date];
//
//    NSPredicate *predicate =
//    [self.eventStore predicateForEventsWithStartDate:startDate
//                                             endDate:endDate
//                                           calendars:calendars.allObjects];
//
//    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
//
//    if ([events count] > 0){
//        EKEvent *event = events[0];
//        EKEventViewController *controller = [[EKEventViewController alloc] init];
//        controller.event = event;
//        controller.allowsEditing = NO;
//        controller.allowsCalendarPreview = YES;
//        controller.delegate = self;
//
//        [self.navigationController pushViewController:controller
//                                             animated:YES];
//    }
//
//
//}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    static BOOL beenHereBefore = NO;
    
    if (beenHereBefore){
        return;
    } else {
        beenHereBefore = YES;
    }
    
    self.eventStore = [[EKEventStore alloc] init];
    
    switch ([EKEventStore
             authorizationStatusForEntityType:EKEntityTypeEvent]){
            
        case EKAuthorizationStatusAuthorized:{
            [self displayEventViewController];
            break;
        }
        case EKAuthorizationStatusDenied:{
            [self displayAccessDenied];
            break;
        }
        case EKAuthorizationStatusNotDetermined:{
            [self.eventStore
             requestAccessToEntityType:EKEntityTypeEvent
             completion:^(BOOL granted, NSError *error) {
                 if (granted){
                     [self displayEventViewController];
                 } else {
                     [self displayAccessDenied];
                 }
             }];
            break;
        }
        case EKAuthorizationStatusRestricted:{
            [self displayAccessRestricted];
            break;
        }
            
    }
    
}

- (void) displayEventViewController{
    
    EKSource *icloudSource = [self sourceInEventStore:self.eventStore
                                           sourceType:EKSourceTypeCalDAV
                                          sourceTitle:@"iCloud"];
    
    if (icloudSource == nil){
        NSLog(@"You have not configured iCloud for your device.");
        return;
    }
    
    NSSet *calendars = [icloudSource
                        calendarsForEntityType:EKEntityTypeEvent];
    
    NSTimeInterval NSOneYear = 1 * 365 * 24.0f * 60.0f * 60.0f;
    NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:-NSOneYear];
    NSDate *endDate = [NSDate date];
    
    NSPredicate *predicate =
    [self.eventStore predicateForEventsWithStartDate:startDate
                                             endDate:endDate
                                           calendars:calendars.allObjects];
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
    if ([events count] > 0){
        EKEvent *event = events[0];
        EKEventViewController *controller = [[EKEventViewController alloc] init];
        controller.event = event;
        controller.allowsEditing = YES;
        controller.allowsCalendarPreview = YES;
        controller.delegate = self;
        
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Go Back"
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
        
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    
}*/

@end
