//
//  NSDate+StringFormatting.h
//  XcodeTV
//
//  Created by Josh Sloat on 9/13/13.
//  Copyright (c) 2013 Articulate. All rights reserved.
//
//  Abstract: The NSDateFormatter class is Cocoa’s way of converting between NSDate and NSString objects.
//	  To actually convert an NSDate to an NSString using NSDateFormatter requires allocating a formmatter object,
//	  setting a style, and calling stringFromDate on that object. This leads to verbose
//	  and ineffiecent code. Adding a category to NSDate makes the world a better place. This code uses a shared
//    formatter per style (changing the style on an existing object is expensive) and a mutex pattern to make it
//    thread-safe. The category also responds to locale and timezone changes and invalidates the cache as necessary.
//
//   Additional reference:
//     API Proposal: https://articulate.atlassian.net/browse/AT-36
//     ISO 8601: http://en.wikipedia.org/wiki/ISO_8601
//     RFC 3339: http://tools.ietf.org/html/rfc3339
//     Cocoa date formatting: http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
//     http://oleb.net/blog/2011/11/working-with-date-and-time-in-cocoa-part-1/
//     http://oleb.net/blog/2011/11/working-with-date-and-time-in-cocoa-part-2/
//
//   Extension Note:
//      Resist the urge to add additional date formats (setDataFormat) and instead stick with
//      using variations of date styles (setDateStyle). Apple discourages date formatting via format
//      strings since there is no date and time format that is accepted worldwide. Date styles
//      will adapt to user preferences and locale defaults. The only exception to this is with the
//      use of predictable, invariant formats used for computer-to-computer communication.
//

#import <Foundation/Foundation.h>

typedef enum
{
	ACDateStyleNone = 0,
    ACDateStyleInvariantUTCDateTime,        // 2013-11-30T00:00:00Z, GMT, en_US_POSIX
    ACDateStyleInvariantAllDayEventDate,    // 2013-11-30, GMT, en_US_POSIX
    ACDateStyleInvariantExplicitDateTime,   // 2013-11-30T00:00:00, GMT, en_US_POSIX
    ACDateStyleLocalShortDate,              // 11/29/13
    ACDateStyleLocalMediumDate,             // Nov 29, 2013
    ACDateStyleLocalLongDate,               // November 29, 2013
    ACDateStyleLocalShortDateTime,          // 11/29/13, 7:00 PM
    ACDateStyleLocalMediumDateTime,         // Nov 29, 2013, 7:00:00 PM
    ACDateStyleLocalLongDateTime,           // November 29, 2013, 7:00:00 PM EST
    ACDateStyleLocalMediumDateShortTime,    // Nov 29, 2013, 7:00 PM
    ACDateStyleAllDayEventShortDate,        // 11/29/13
    ACDateStyleAllDayEventMediumDate,       // Nov 29, 2013
    ACDateStyleAllDayEventLongDate,         // November 29, 2013
    ACDateStyleExplicitShortDateTime,       // 11/29/13, 7:00 PM
    ACDateStyleExplicitMediumDateTime,      // Nov 29, 2013, 7:00:00 PM
    ACDateStyleExplicitLongDateTime,        // November 29, 2013, 7:00:00 PM EST
    ACDateStyleISO8601,                     // 2014-10-21T19:40:27Z
} ACDateStyle;

@interface NSDate (StringFormatting)

// Mainly used for testing
+ (void)setLocale:(NSLocale *)locale;
+ (void)setShouldRespectLocaleChanges:(BOOL)respectLocaleChanges;

// Invariant, computer-to-computer UTC date transmission
+ (NSDate *)dateFromInvariantUTCDateTimeString:(NSString *)dateString;
- (NSString *)invariantUTCDateTimeString;

// Invariant, computer-to-computer All Day Event date transmission
+ (NSDate *)dateFromInvariantAllDayEventString:(NSString *)dateString;
- (NSString *)invariantAllDayEventDateString;

// Invariant, computer-to-computer explcit date time transmission
+ (NSDate *)dateFromInvariantExplicitDateTimeString:(NSString *)dateString;
- (NSString *)invariantExplicitDateTimeString;

// ISO8601
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;

// Date strings formatted to current locale and timezone
- (NSString *)localShortDateString;
- (NSString *)localMediumDateString;
- (NSString *)localLongDateString;

// Date/time strings formatted to current locale and timezone
- (NSString *)localShortDateTimeString;
- (NSString *)localMediumDateTimeString;
- (NSString *)localLongDateTimeString;

// Date/time strings formatted to current locale and timezone
- (NSString *)localMediumDateShortTimeString;

// Date strings formatted as all day event dates - no concept of local timezone
- (NSString *)allDayEventShortDateString;
- (NSString *)allDayEventMediumDateString;
- (NSString *)allDayEventLongDateString;

// Date/time strings formatted for an explicit date and time - no conversion
- (NSString *)explicitShortDateTimeString;
- (NSString *)explicitMediumDateTimeString;
- (NSString *)explicitLongDateTimeString;

@end
