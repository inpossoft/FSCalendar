//
//  LoadViewExampleViewController.m
//  FSCalendar
//
//  Created by DingWenchao on 6/25/15.
//  Copyright (c) 2015 =. All rights reserved.
//

#import "LoadViewExampleViewController.h"

@implementation LoadViewExampleViewController

- (void)dealloc
{
    NSLog(@"%@:%s", self.class.description, __FUNCTION__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        self.images = @{@"2015/02/01":[UIImage imageNamed:@"icon_cat"],
                        @"2015/02/05":[UIImage imageNamed:@"icon_footprint"],
                        @"2015/02/20":[UIImage imageNamed:@"icon_cat"],
                        @"2015/03/07":[UIImage imageNamed:@"icon_footprint"]};
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    self.view = view;
    
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;

    calendar.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
	calendar.appearance.todayColor = [UIColor clearColor];
	calendar.appearance.titleTodayColor = [UIColor lightGrayColor];
	calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
	calendar.appearance.borderDefaultColor = [UIColor whiteColor];
	calendar.appearance.weekdayTextColor = [UIColor lightGrayColor];
	calendar.appearance.titleDefaultColor = [UIColor lightGrayColor];
	calendar.appearance.titleSelectionColor = [UIColor lightGrayColor];
	calendar.appearance.subtitleDefaultColor = [UIColor lightGrayColor];
	calendar.appearance.subtitleSelectionColor = [UIColor lightGrayColor];
	calendar.appearance.subtitleTodayColor = [UIColor lightGrayColor];
	calendar.appearance.selectionColor = [UIColor clearColor];
	calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
	calendar.headerHeight = 0;
	calendar.isWeeklyPaging = YES;

    [view addSubview:calendar];
    self.calendar = calendar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	[self.calendar setCurrentPage:[self.calendar tomorrowOfDate:[NSDate date]]];
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.calendar setScope:FSCalendarScopeMonth animated:YES];
        });
    });
     */
    
    
}

- (NSString *)calendar:(FSCalendar *)calendar monthNameForDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM"];
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
	NSInteger dayOfWeek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
	NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
	// Check if is first day of month or it's first day on calendar
	if (components.day == 1 || ([date compare:[NSDate date]] == NSOrderedAscending && dayOfWeek == 1 && secondsBetween < 604800)) {
		return [dateFormatter stringFromDate:date].uppercaseString;
	}
	return nil;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    NSLog(@"should select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[calendar stringFromDate:calendar.currentPage format:@"MMMM YYYY"]);
}

- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    CGFloat height = [calendar sizeThatFits:CGSizeZero].height;
    calendar.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, height);
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{
    return self.images[[calendar stringFromDate:date format:@"yyyy/MM/dd"]];
}

@end
