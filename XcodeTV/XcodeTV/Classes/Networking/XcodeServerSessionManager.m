//
//  XcodeServerSessionManager.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "XcodeServerSessionManager.h"
#import "ServerDataManager.h"

@implementation XcodeServerSessionManager

#pragma mark - Singleton

+ (XcodeServerSessionManager *)sharedManager
{
    static XcodeServerSessionManager * _sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedManager)
        {
            Server *server = [ServerDataManager defaultServerConfiguration];
            
            NSURL *baseURL = [NSURL URLWithString:server.hostAddress];
            
            NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            _sharedManager = [[XcodeServerSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:urlSessionConfiguration];
        }
    });
    
    return _sharedManager;
}

#pragma mark - Init / Dealloc

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];

    if (self)
    {
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    return self;
}

@end
