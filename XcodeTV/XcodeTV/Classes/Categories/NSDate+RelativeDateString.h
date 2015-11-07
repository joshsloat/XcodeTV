//
//  NSDate+RelativeDateString.h
//  XcodeTV
//
//  Created by Josh Sloat on 10/22/15.
//  Copyright © 2015 Articulate. All rights reserved.
//
//  Abstract: A category on NSDate for generating a relative date string (ex: 2 minutes ago).
//

#import <Foundation/Foundation.h>

@interface NSDate (RelativeDateString)

- (NSString *)relativeDateStringFromNow;

@end
