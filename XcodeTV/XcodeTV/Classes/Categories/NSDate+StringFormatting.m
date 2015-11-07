//
//  NSDate+StringFormatting.m
//  XcodeTV
//
//  Created by Josh Sloat on 9/13/13.
//  Copyright (c) 2013 Articulate. All rights reserved.
//

#import "NSDate+StringFormatting.h"

#import "ISO8601DateFormatter.h"

@implementation NSDate (StringFormatting)

NSDateFormatter *sharedFormatterInvariantUTCDateTimeStyle = nil;
NSDateFormatter *sharedFormatterInvariantAllDayEventDateStyle = nil;
NSDateFormatter *sharedFormatterInvariantExplicitDateTimeStyle = nil;
NSDateFormatter *sharedFormatterLocalShortDateStyle = nil;
NSDateFormatter *sharedFormatterLocalMediumDateStyle = nil;
NSDateFormatter *sharedFormatterLocalLongDateStyle = nil;
NSDateFormatter *sharedFormatterLocalShortDateTimeStyle = nil;
NSDateFormatter *sharedFormatterLocalMediumDateTimeStyle = nil;
NSDateFormatter *sharedFormatterLocalLongDateTimeStyle = nil;
NSDateFormatter *sharedFormatterLocalMediumDateShortTimeStyle = nil;
NSDateFormatter *sharedFormatterAllDayEventShortDateStyle = nil;
NSDateFormatter *sharedFormatterAllDayEventMediumDateStyle = nil;
NSDateFormatter *sharedFormatterAllDayEventLongDateStyle = nil;
NSDateFormatter *sharedFormatterExplicitShortDateTimeStyle = nil;
NSDateFormatter *sharedFormatterExplicitMediumDateTimeStyle = nil;
NSDateFormatter *sharedFormatterExplicitLongDateTimeStyle = nil;
ISO8601DateFormatter *sharedFormatterISO8601Style = nil;

static NSString * kSharedFormatterInvariantUTCDateTimeStyleLock = @"kSharedFormatterInvariantUTCDateTimeStyleLock";
static NSString * kSharedFormatterInvariantAllDayEventDateStyleLock = @"kSharedFormatterInvariantAllDayEventDateStyleLock";
static NSString * kSharedFormatterInvariantExplicitDateTimeStyleLock = @"kSharedFormatterInvariantExplicitDateTimeStyleLock";
static NSString * kSharedFormatterLocalShortDateStyleLock = @"kSharedFormatterLocalShortDateStyleLock";
static NSString * kSharedFormatterLocalMediumDateStyleLock = @"kSharedFormatterLocalMediumDateStyleLock";
static NSString * kSharedFormatterLocalLongDateStyleLock = @"kSharedFormatterLocalLongDateStyleLock";
static NSString * kSharedFormatterLocalShortDateTimeStyleLock = @"kSharedFormatterLocalShortDateTimeStyleLock";
static NSString * kSharedFormatterLocalMediumDateTimeStyleLock = @"kSharedFormatterLocalMediumDateTimeStyleLock";
static NSString * kSharedFormatterLocalLongDateTimeStyleLock = @"kSharedFormatterLocalLongDateTimeStyleLock";
static NSString * kSharedFormatterLocalMediumDateShortTimeStyleLock = @"kSharedFormatterLocalMediumDateTimeStyleLock";
static NSString * kSharedFormatterAllDayEventShortDateStyleLock = @"kSharedFormatterAllDayEventShortDateStyleLock";
static NSString * kSharedFormatterAllDayEventMediumDateStyleLock = @"kSharedFormatterAllDayEventMediumDateStyleLock";
static NSString * kSharedFormatterAllDayEventLongDateStyleLock = @"kSharedFormatterAllDayEventLongDateStyleLock";
static NSString * kSharedFormatterExplicitShortDateTimeStyleLock = @"kSharedFormatterExplicitShortDateTimeStyleLock";
static NSString * kSharedFormatterExplicitMediumDateTimeStyleLock = @"kSharedFormatterExplicitMediumDateTimeStyleLock";
static NSString * kSharedFormatterExplicitLongDateTimeStyleLock = @"kSharedFormatterExplicitLongDateTimeStyleLock";
static NSString * kSharedFormatterISO8601StyleLock = @"kSharedFormatterISO8601StyleLock";

static NSLocale * currentLocale = nil;
static BOOL shouldRespectLocaleChanges = YES;

#pragma mark - Init

+ (void)load
{
    /* Formatters are initialized using the current locale at time of creation. If the device locale
     changes, the formatter cache must be invalidated so that formatters can be re-created (on demand)
     using the correct locale */
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(currentLocaleDidChange:)
                                                 name:NSCurrentLocaleDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(currentTimeZoneDidChange:)
                                                 name:NSSystemTimeZoneDidChangeNotification object:nil];
    
    currentLocale = [NSLocale currentLocale];
}

#pragma mark - Notification handlers

+ (void)currentLocaleDidChange:(NSNotification *)notification
{
    if (shouldRespectLocaleChanges)
    {
        currentLocale = [NSLocale currentLocale];
        [self clearCache];
    }
}

+ (void)currentTimeZoneDidChange:(NSNotification *)notification
{
    [self clearCache];
}

#pragma mark - Public methods

+ (void)setLocale:(NSLocale *)locale
{
    currentLocale = locale;
    [self clearCache];
}

+ (void)setShouldRespectLocaleChanges:(BOOL)respectLocaleChanges
{
    shouldRespectLocaleChanges = respectLocaleChanges;
}

+ (NSDate *)dateFromInvariantUTCDateTimeString:(NSString *)dateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantUTCDateTime];
    
	return [formatter dateFromString:dateString];
}

- (NSString *)invariantUTCDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantUTCDateTime];
    
	return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromInvariantAllDayEventString:(NSString *)dateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantAllDayEventDate];
    
	return [formatter dateFromString:dateString];
}

+ (NSDate *)dateFromISO8601String:(NSString *)dateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleISO8601];
    
    return [formatter dateFromString:dateString];
}

- (NSString *)invariantAllDayEventDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantAllDayEventDate];
    
	return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromInvariantExplicitDateTimeString:(NSString *)dateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantExplicitDateTime];
    
	return [formatter dateFromString:dateString];
}

- (NSString *)invariantExplicitDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleInvariantExplicitDateTime];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localShortDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalShortDate];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localMediumDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalMediumDate];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localLongDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalLongDate];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localShortDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalShortDateTime];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localMediumDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalMediumDateTime];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localLongDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalLongDateTime];
    
	return [formatter stringFromDate:self];
}

- (NSString *)localMediumDateShortTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleLocalMediumDateShortTime];
    
	return [formatter stringFromDate:self];
}

- (NSString *)allDayEventShortDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleAllDayEventShortDate];
    
	return [formatter stringFromDate:self];
}

- (NSString *)allDayEventMediumDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleAllDayEventMediumDate];
    
	return [formatter stringFromDate:self];
}

- (NSString *)allDayEventLongDateString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleAllDayEventLongDate];
    
    return [formatter stringFromDate:self];
}

- (NSString *)explicitShortDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleExplicitShortDateTime];
    
    return [formatter stringFromDate:self];
}

- (NSString *)explicitMediumDateTimeString
{
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleExplicitMediumDateTime];
    
    return [formatter stringFromDate:self];
}

- (NSString *)explicitLongDateTimeString
{
    /* Note: not sure this format would ever be desirable, since it would usually expose the fact
     that the underlying implementation use GMT to lock in the date and time */
    NSDateFormatter *formatter = [NSDate sharedFormatter:ACDateStyleExplicitLongDateTime];
    
    return [formatter stringFromDate:self];
}

#pragma mark - Private methods

+ (void)clearCache
{
    sharedFormatterLocalShortDateStyle = nil;
    sharedFormatterLocalMediumDateStyle = nil;
    sharedFormatterLocalLongDateStyle = nil;
    sharedFormatterLocalShortDateTimeStyle = nil;
    sharedFormatterLocalMediumDateTimeStyle = nil;
    sharedFormatterLocalLongDateTimeStyle = nil;
    sharedFormatterLocalMediumDateShortTimeStyle = nil;
    sharedFormatterAllDayEventShortDateStyle = nil;
    sharedFormatterAllDayEventMediumDateStyle = nil;
    sharedFormatterAllDayEventLongDateStyle = nil;
    sharedFormatterExplicitShortDateTimeStyle = nil;
    sharedFormatterExplicitMediumDateTimeStyle = nil;
    sharedFormatterExplicitLongDateTimeStyle = nil;
    
    // note: the invariant formatters do not need to be cleared
}

+ (NSDateFormatter *)sharedFormatter:(ACDateStyle)style
{
    NSDateFormatter *formatter = nil;
	
    switch (style)
	{
		case ACDateStyleInvariantUTCDateTime:
        {
			formatter = [self sharedFormatterInvariantUTCDateTimeStyle];
        }
			break;
            
        case ACDateStyleInvariantAllDayEventDate:
        {
			formatter = [self sharedFormatterInvariantAllDayEventDateStyle];
        }
			break;
            
        case ACDateStyleInvariantExplicitDateTime:
        {
			formatter = [self sharedFormatterInvariantExplicitDateTimeStyle];
        }
			break;
            
        case ACDateStyleLocalShortDate:
        {
            formatter = [self sharedFormatterLocalShortDateStyle];
        }
            break;
            
        case ACDateStyleLocalMediumDate:
        {
            formatter = [self sharedFormatterLocalMediumDateStyle];
        }
            break;
            
        case ACDateStyleLocalLongDate:
        {
            formatter = [self sharedFormatterLocalLongDateStyle];
        }
            break;
            
        case ACDateStyleLocalShortDateTime:
        {
            formatter = [self sharedFormatterLocalShortDateTimeStyle];
        }
            break;
            
        case ACDateStyleLocalMediumDateTime:
        {
            formatter = [self sharedFormatterLocalMediumDateTimeStyle];
        }
            break;
            
        case ACDateStyleLocalLongDateTime:
        {
            formatter = [self sharedFormatterLocalLongDateTimeStyle];
        }
            break;
            
        case ACDateStyleLocalMediumDateShortTime:
        {
            formatter = [self sharedFormatterLocalMediumDateShortTimeStyle];
        }
            break;
            
        case ACDateStyleAllDayEventShortDate:
        {
            formatter = [self sharedFormatterAllDayEventShortDateStyle];
        }
            break;
            
        case ACDateStyleAllDayEventMediumDate:
        {
            formatter = [self sharedFormatterAllDayEventMediumDateStyle];
        }
            break;
            
        case ACDateStyleAllDayEventLongDate:
        {
            formatter = [self sharedFormatterAllDayEventLongDateStyle];
        }
            break;
            
        case ACDateStyleExplicitShortDateTime:
        {
            formatter = [self sharedFormatterExplicitShortDateTimeStyle];
        }
            break;
            
        case ACDateStyleExplicitMediumDateTime:
        {
            formatter = [self sharedFormatterExplicitMediumDateTimeStyle];
        }
            break;
            
        case ACDateStyleExplicitLongDateTime:
        {
            formatter = [self sharedFormatterExplicitLongDateTimeStyle];
        }
            break;
            
        case ACDateStyleISO8601:
        {
            formatter = (NSDateFormatter *)[self sharedFormatterISO8601Style];
        }
            break;
            
		default:
			break;
	}
    
	return formatter;
}

+ (NSDateFormatter *)sharedFormatterInvariantUTCDateTimeStyle
{
    if (!sharedFormatterInvariantUTCDateTimeStyle)
    {
        @synchronized(kSharedFormatterInvariantUTCDateTimeStyleLock)
        {
            if (sharedFormatterInvariantUTCDateTimeStyle == nil)
            {
                sharedFormatterInvariantUTCDateTimeStyle = [[NSDateFormatter alloc] init];
                
                // TODO: determine if this should be our default UTC date time style format string?  Rise server is using fractional seconds (.SSS)
                [sharedFormatterInvariantUTCDateTimeStyle setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                [sharedFormatterInvariantUTCDateTimeStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [sharedFormatterInvariantUTCDateTimeStyle setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            }
        }
    }
    
    return sharedFormatterInvariantUTCDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterInvariantAllDayEventDateStyle
{
    if (!sharedFormatterInvariantAllDayEventDateStyle)
    {
        @synchronized(kSharedFormatterInvariantAllDayEventDateStyleLock)
        {
            if (sharedFormatterInvariantAllDayEventDateStyle == nil)
            {
                sharedFormatterInvariantAllDayEventDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterInvariantAllDayEventDateStyle setDateFormat:@"yyyy-MM-dd"];
                [sharedFormatterInvariantAllDayEventDateStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [sharedFormatterInvariantAllDayEventDateStyle setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            }
        }
    }
    
    return sharedFormatterInvariantAllDayEventDateStyle;
}

+ (NSDateFormatter *)sharedFormatterInvariantExplicitDateTimeStyle
{
    if (!sharedFormatterInvariantExplicitDateTimeStyle)
    {
        @synchronized(kSharedFormatterInvariantExplicitDateTimeStyleLock)
        {
            if (sharedFormatterInvariantExplicitDateTimeStyle == nil)
            {
                sharedFormatterInvariantExplicitDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterInvariantExplicitDateTimeStyle setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                [sharedFormatterInvariantExplicitDateTimeStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [sharedFormatterInvariantExplicitDateTimeStyle setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            }
        }
    }
    
    return sharedFormatterInvariantExplicitDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalShortDateStyle
{
    if (!sharedFormatterLocalShortDateStyle)
    {
        @synchronized(kSharedFormatterLocalShortDateStyleLock)
        {
            if (sharedFormatterLocalShortDateStyle == nil)
            {
                sharedFormatterLocalShortDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalShortDateStyle setDateStyle:NSDateFormatterShortStyle];
                [sharedFormatterLocalShortDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterLocalShortDateStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalShortDateStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalMediumDateStyle
{
    if (!sharedFormatterLocalMediumDateStyle)
    {
        @synchronized(kSharedFormatterLocalMediumDateStyleLock)
        {
            if (sharedFormatterLocalMediumDateStyle == nil)
            {
                sharedFormatterLocalMediumDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalMediumDateStyle setDateStyle:NSDateFormatterMediumStyle];
                [sharedFormatterLocalMediumDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterLocalMediumDateStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalMediumDateStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalLongDateStyle
{
    if (!sharedFormatterLocalLongDateStyle)
    {
        @synchronized(kSharedFormatterLocalLongDateStyleLock)
        {
            if (sharedFormatterLocalLongDateStyle == nil)
            {
                sharedFormatterLocalLongDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalLongDateStyle setDateStyle:NSDateFormatterLongStyle];
                [sharedFormatterLocalLongDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterLocalLongDateStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalLongDateStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalShortDateTimeStyle
{
    if (!sharedFormatterLocalShortDateTimeStyle)
    {
        @synchronized(kSharedFormatterLocalShortDateTimeStyleLock)
        {
            if (sharedFormatterLocalShortDateTimeStyle == nil)
            {
                sharedFormatterLocalShortDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalShortDateTimeStyle setDateStyle:NSDateFormatterShortStyle];
                [sharedFormatterLocalShortDateTimeStyle setTimeStyle:NSDateFormatterShortStyle];
                [sharedFormatterLocalShortDateTimeStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalShortDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalMediumDateTimeStyle
{
    if (!sharedFormatterLocalMediumDateTimeStyle)
    {
        @synchronized(kSharedFormatterLocalMediumDateTimeStyleLock)
        {
            if (sharedFormatterLocalMediumDateTimeStyle == nil)
            {
                sharedFormatterLocalMediumDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalMediumDateTimeStyle setDateStyle:NSDateFormatterMediumStyle];
                [sharedFormatterLocalMediumDateTimeStyle setTimeStyle:NSDateFormatterMediumStyle];
                [sharedFormatterLocalMediumDateTimeStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalMediumDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalLongDateTimeStyle
{
    if (!sharedFormatterLocalLongDateTimeStyle)
    {
        @synchronized(kSharedFormatterLocalLongDateTimeStyleLock)
        {
            if (sharedFormatterLocalLongDateTimeStyle == nil)
            {
                sharedFormatterLocalLongDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalLongDateTimeStyle setDateStyle:NSDateFormatterLongStyle];
                [sharedFormatterLocalLongDateTimeStyle setTimeStyle:NSDateFormatterLongStyle];
                [sharedFormatterLocalLongDateTimeStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalLongDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterLocalMediumDateShortTimeStyle
{
    if (!sharedFormatterLocalMediumDateShortTimeStyle)
    {
        @synchronized(kSharedFormatterLocalMediumDateShortTimeStyleLock)
        {
            if (sharedFormatterLocalMediumDateShortTimeStyle == nil)
            {
                sharedFormatterLocalMediumDateShortTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterLocalMediumDateShortTimeStyle setDateStyle:NSDateFormatterMediumStyle];
                [sharedFormatterLocalMediumDateShortTimeStyle setTimeStyle:NSDateFormatterShortStyle];
                [sharedFormatterLocalMediumDateShortTimeStyle setLocale:currentLocale];
            }
        }
    }
    
    return sharedFormatterLocalMediumDateShortTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterAllDayEventShortDateStyle
{
    if (!sharedFormatterAllDayEventShortDateStyle)
    {
        @synchronized(kSharedFormatterAllDayEventShortDateStyleLock)
        {
            if (sharedFormatterAllDayEventShortDateStyle == nil)
            {
                sharedFormatterAllDayEventShortDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterAllDayEventShortDateStyle setDateStyle:NSDateFormatterShortStyle];
                [sharedFormatterAllDayEventShortDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterAllDayEventShortDateStyle setLocale:currentLocale];
                [sharedFormatterAllDayEventShortDateStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterAllDayEventShortDateStyle;
}

+ (NSDateFormatter *)sharedFormatterAllDayEventMediumDateStyle
{
    if (!sharedFormatterAllDayEventMediumDateStyle)
    {
        @synchronized(kSharedFormatterAllDayEventMediumDateStyleLock)
        {
            if (sharedFormatterAllDayEventMediumDateStyle == nil)
            {
                sharedFormatterAllDayEventMediumDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterAllDayEventMediumDateStyle setDateStyle:NSDateFormatterMediumStyle];
                [sharedFormatterAllDayEventMediumDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterAllDayEventMediumDateStyle setLocale:currentLocale];
                [sharedFormatterAllDayEventMediumDateStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterAllDayEventMediumDateStyle;
}

+ (NSDateFormatter *)sharedFormatterAllDayEventLongDateStyle
{
    if (!sharedFormatterAllDayEventLongDateStyle)
    {
        @synchronized(kSharedFormatterAllDayEventLongDateStyleLock)
        {
            if (sharedFormatterAllDayEventLongDateStyle == nil)
            {
                sharedFormatterAllDayEventLongDateStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterAllDayEventLongDateStyle setDateStyle:NSDateFormatterLongStyle];
                [sharedFormatterAllDayEventLongDateStyle setTimeStyle:NSDateFormatterNoStyle];
                [sharedFormatterAllDayEventLongDateStyle setLocale:currentLocale];
                [sharedFormatterAllDayEventMediumDateStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterAllDayEventLongDateStyle;
}

+ (NSDateFormatter *)sharedFormatterExplicitShortDateTimeStyle
{
    if (!sharedFormatterExplicitShortDateTimeStyle)
    {
        @synchronized(kSharedFormatterExplicitShortDateTimeStyleLock)
        {
            if (sharedFormatterExplicitShortDateTimeStyle == nil)
            {
                sharedFormatterExplicitShortDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterExplicitShortDateTimeStyle setDateStyle:NSDateFormatterShortStyle];
                [sharedFormatterExplicitShortDateTimeStyle setTimeStyle:NSDateFormatterShortStyle];
                [sharedFormatterExplicitShortDateTimeStyle setLocale:currentLocale];
                [sharedFormatterExplicitShortDateTimeStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterExplicitShortDateTimeStyle;
}

+ (NSDateFormatter *)sharedFormatterExplicitMediumDateTimeStyle
{
    if (!sharedFormatterExplicitMediumDateTimeStyle)
    {
        @synchronized(kSharedFormatterExplicitMediumDateTimeStyleLock)
        {
            if (sharedFormatterExplicitMediumDateTimeStyle == nil)
            {
                sharedFormatterExplicitMediumDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterExplicitMediumDateTimeStyle setDateStyle:NSDateFormatterMediumStyle];
                [sharedFormatterExplicitMediumDateTimeStyle setTimeStyle:NSDateFormatterMediumStyle];
                [sharedFormatterExplicitMediumDateTimeStyle setLocale:currentLocale];
                [sharedFormatterExplicitMediumDateTimeStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterExplicitMediumDateTimeStyle;
}

+ (ISO8601DateFormatter *)sharedFormatterISO8601Style
{
    if (!sharedFormatterISO8601Style)
    {
        @synchronized(kSharedFormatterISO8601StyleLock)
        {
            if (sharedFormatterISO8601Style == nil)
            {
                sharedFormatterISO8601Style = [[ISO8601DateFormatter alloc] init];
            }
        }
    }
    
    return sharedFormatterISO8601Style;
}

+ (NSDateFormatter *)sharedFormatterExplicitLongDateTimeStyle
{
    if (!sharedFormatterExplicitLongDateTimeStyle)
    {
        @synchronized(kSharedFormatterExplicitLongDateTimeStyleLock)
        {
            if (sharedFormatterExplicitLongDateTimeStyle == nil)
            {
                sharedFormatterExplicitLongDateTimeStyle = [[NSDateFormatter alloc] init];
                [sharedFormatterExplicitLongDateTimeStyle setDateStyle:NSDateFormatterLongStyle];
                [sharedFormatterExplicitLongDateTimeStyle setTimeStyle:NSDateFormatterLongStyle];
                [sharedFormatterExplicitLongDateTimeStyle setLocale:currentLocale];
                [sharedFormatterExplicitLongDateTimeStyle setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
        }
    }
    
    return sharedFormatterExplicitLongDateTimeStyle;
}

@end