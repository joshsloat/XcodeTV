//
//  UserDefaultsManager.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

// TODO: this will need to be an array - maybe store array of server object JSON?
@property (nonatomic, copy) NSString *baseAPIURLString;
@property (nonatomic, copy) NSString *hostDescription;

+ (UserDefaultsManager *)sharedManager;

@end
