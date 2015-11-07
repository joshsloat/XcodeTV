//
//  BotDataManager.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BotDataManager.h"
#import "XcodeServerSessionManager.h"
#import "BotCollection.h"
#import "AFNetworking.h"
#import "TRVSURLSessionOperation.h"
#import "IntegrationCollection.h"
#import "XcodeServiceURLs.h"

@interface BotDataManager ()

@end

@implementation BotDataManager

#pragma mark - Public Methods

- (void)getBotsWithSuccess:(BotDataManagerSuccessBlock)success
                   failure:(BotDataManagerFailureBlock)failure
{
    // get the bot collection
    [[XcodeServerSessionManager sharedManager] GET:[XcodeServiceURLs botsEndpoint]
                                        parameters:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        NSError *jsonModelError = nil;
        
        BotCollection *collection = [[BotCollection alloc] initWithDictionary:responseObject error:&jsonModelError];
        
        // get integrations list for each bot
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSURLSession *session = [XcodeServerSessionManager sharedManager].session;
        
        NSError *requestError = nil;
        
        for (Bot *bot in collection.results)
        {
            NSString *urlString = [XcodeServiceURLs integrationsEndpointForBotIdentifier:bot.identifier];
            
            urlString = [[NSURL URLWithString:urlString relativeToURL:[XcodeServerSessionManager sharedManager].baseURL] absoluteString];
            
            NSURLRequest *request = [[XcodeServerSessionManager sharedManager].requestSerializer requestWithMethod:@"GET"
                                                                                                         URLString:urlString
                                                                                                        parameters:nil
                                                                                                             error:&requestError];
            
            [queue addOperation:[[TRVSURLSessionOperation alloc] initWithSession:session
                                                                         request:request
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                
                
                NSError *serializationError = nil;
                NSError *jsonModelError = nil;
                NSDictionary *deserializedResponse = [[XcodeServerSessionManager sharedManager].responseSerializer
                                                      responseObjectForResponse:response
                                                      data:data
                                                      error:&serializationError];
                
                IntegrationCollection *integrationCollection = [[IntegrationCollection alloc] initWithDictionary:deserializedResponse error:&jsonModelError];
                
                // only care about the most recent for our purposes
                bot.lastIntegration = integrationCollection.results.firstObject;
            }]];
        
        }

        [queue waitUntilAllOperationsAreFinished];
        
        if (success)
        {
            success(nil, collection);
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

@end
