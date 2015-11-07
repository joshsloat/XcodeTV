//
//  NSDate+RelativeDateString.m
//  XcodeTV
//
//  Created by Josh Sloat on 10/22/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "NSDate+RelativeDateString.h"

@implementation NSDate (RelativeDateString)

#pragma mark - Public Methods

- (NSString *)relativeDateStringFromNow
{
    NSCalendarUnit units = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay |
                           NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:self
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    // components will be positive if the passed in date is in the past
    if (components.year > 0)
    {
        return [self dateStringWithFormatString:NSLocalizedString(@"%d years ago", @"x years ago format string")
                                           unit:components.year];
    }
    else if (components.month > 0)
    {
        return [self dateStringWithFormatString:NSLocalizedString(@"%d months ago", @"x months ago format string")
                                           unit:components.month];
    }
    else if (components.day > 0)
    {
        return [self dateStringWithFormatString:NSLocalizedString(@"%d days ago", @"x days ago format string")
                                           unit:components.day];
    }
    else if (components.hour > 0)
    {
        return [self dateStringWithFormatString:NSLocalizedString(@"%d hours ago", @"x hours ago format string")
                                           unit:components.hour];
    }
    else
    {
        return [self dateStringWithFormatString:NSLocalizedString(@"%d minutes ago", @"x minutes ago format string")
                                           unit:components.minute];
    }
}

#pragma mark - Private Methods

- (NSString *)dateStringWithFormatString:(NSString *)formatString unit:(NSInteger)unit
{
    NSString *timeString = [NSString localizedStringWithFormat:formatString, unit];
    
    return timeString;
}

@end
