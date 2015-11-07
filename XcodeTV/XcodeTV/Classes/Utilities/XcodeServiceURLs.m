//
//  XcodeServiceURLs.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "XcodeServiceURLs.h"

@implementation XcodeServiceURLs

+ (NSString *)botsEndpoint
{
    return @"api/bots";
}

+ (NSString *)integrationsEndpointForBotIdentifier:(NSString *)identifier
{
    NSString *urlString = [NSString stringWithFormat:@"api/bots/%@/integrations", identifier];
    
    return urlString;
}

+ (NSString *)versionsEndpoint
{
    return @"api/versions";
}

@end
