//
//  CalendarVC.h
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 11/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MZDayPicker.h"
#import "DBAdmin.h"

#import <QuartzCore/QuartzCore.h>
#import "NVCalendar.h"
#define Width_View 640
#define Height_View 960
#define Static_Y_Space 160
#define Width_calendarView 288
#define Height_calendarView 288
#define Minus_month_for_Previous_Action 16
#define Seconds_of_Minute 60
#define Minutes_of_Hour 60
#define Hours_of_Day 24
#define Origin_of_calendarView 156
#define Width_Allocated_for_CalendarViews 580

@interface CalendarVC : UIViewController
{
    BOOL isLeft;
    NSDate *dtForMonth;
    int originX,originY;
}
//@property (nonatomic, strong) EKEventStore *eventStore;
//@property (nonatomic, unsafe_unretained) ABAddressBookRef addressBook;
@property (strong, nonatomic) DBAdmin * dbAdmin;

-(void)createCalendar;
-(IBAction)next;
-(IBAction)previous;

@end
