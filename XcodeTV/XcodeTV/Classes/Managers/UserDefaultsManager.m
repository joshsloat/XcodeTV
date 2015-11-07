//
//  UserDefaultsManager.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager

@synthesize baseAPIURLString = _baseAPIURLString;
@synthesize hostDescription = _hostDescription;

static NSString * const kUserDefaultsKeyBaseAPIURLString = @"BaseAPIURLString";
static NSString * const kUserDefaultsKeyHostDescription = @"HostDescription";

#pragma mark - Singleton

+ (UserDefaultsManager *)sharedManager
{
    static UserDefaultsManager * _sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedManager)
        {
            _sharedManager = [[UserDefaultsManager alloc] init];
        }
    });
    
    
    return _sharedManager;
}

#pragma mark - Public Properties

- (NSString *)baseAPIURLString
{
    if (!_baseAPIURLString)
    {
        _baseAPIURLString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyBaseAPIURLString];
    }
    
    return _baseAPIURLString;
}

- (void)setBaseAPIURLString:(NSString *)baseAPIURLString
{
    if (![_baseAPIURLString isEqualToString:baseAPIURLString])
    {
        _baseAPIURLString = baseAPIURLString;
        
        [[NSUserDefaults standardUserDefaults] setValue:baseAPIURLString forKey:kUserDefaultsKeyBaseAPIURLString];
    }
}

- (NSString *)hostDescription
{
    if (!_hostDescription)
    {
        _hostDescription = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyHostDescription];
    }
    
    return _hostDescription;
}

- (void)setHostDescription:(NSString *)hostDescription
{
    if (![_hostDescription isEqualToString:hostDescription])
    {
        _hostDescription = hostDescription;
        
        [[NSUserDefaults standardUserDefaults] setValue:hostDescription forKey:kUserDefaultsKeyHostDescription];
    }
}

@end
