//
//  ServerDataManager.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "ServerDataManager.h"
#import "UserDefaultsManager.h"
#import "XcodeServiceURLs.h"
#import "XcodeServerSessionManager.h"
#import "ServerVersions.h"

@implementation ServerDataManager

#pragma mark - Public Methods

+ (BOOL)isServerConfigured
{
    Server *server = [self defaultServerConfiguration];
    
    return server.username && server.password && server.hostAddress;
}

+ (void)saveServerConfiguration:(Server *)server
{
    [UserDefaultsManager sharedManager].baseAPIURLString = server.hostAddress;
    [UserDefaultsManager sharedManager].hostDescription = server.hostDescription;
    
    NSURLProtectionSpace *potectionSpace = [ServerDataManager protectionSpaceForHostAddress:server.hostAddress];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:server.username
                                                             password:server.password
                                                          persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:potectionSpace];
}

+ (Server *)defaultServerConfiguration
{
    Server *server = [Server new];
    server.hostAddress = [UserDefaultsManager sharedManager].baseAPIURLString;
    server.hostDescription = [UserDefaultsManager sharedManager].hostDescription;
    
    NSURLProtectionSpace *potectionSpace = [ServerDataManager protectionSpaceForHostAddress:server.hostAddress];
    
    NSDictionary *credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:potectionSpace];
    NSURLCredential *credential = [credentials.objectEnumerator nextObject];
    
    server.username = credential.user;
    server.password = credential.password;

    return server;
}

+ (void)getServerVersionsForServer:(Server *)server
                       withSuccess:(ServerDataManagerSuccessBlock)success
                           failure:(ServerDataManagerFailureBlock)failure
{
    [[XcodeServerSessionManager sharedManager] GET:[XcodeServiceURLs versionsEndpoint]
                                        parameters:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        NSError *jsonModelError = nil;
        ServerVersions *serverVersions = [[ServerVersions alloc] initWithDictionary:responseObject error:&jsonModelError];
        
        if (success)
        {
            success(nil, serverVersions);
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (failure)
        {
            failure(nil, error);
        }
    }];
}

#pragma mark - Private Methods

+ (NSURLProtectionSpace *)protectionSpaceForHostAddress:(NSString *)hostAddress
{
    NSURL *hostURL = [NSURL URLWithString:hostAddress];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:hostURL.host
                                                                                  port:[hostURL.port integerValue]
                                                                              protocol:hostURL.scheme
                                                                                 realm:nil
                                                                  authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    
    return protectionSpace;
}

@end
