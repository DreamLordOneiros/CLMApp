#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define day_label_width 45
#define day_label_height 36

@interface NVCalendar : UIView<UIGestureRecognizerDelegate>
{
}
-(NVCalendar *)createCalOfDay:(int)currentDay Month:(int)currentMonth Year:(int)currentYear MonthName:(NSString *)name;
@end
