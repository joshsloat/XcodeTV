//
//  XcodeServiceURLs.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XcodeServiceURLs : NSObject

+ (NSString *)botsEndpoint;
+ (NSString *)integrationsEndpointForBotIdentifier:(NSString *)identifier;
+ (NSString *)versionsEndpoint;

@end
