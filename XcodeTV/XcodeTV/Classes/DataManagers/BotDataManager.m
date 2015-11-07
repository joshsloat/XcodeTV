//
//  BotDataManager.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BotDataManager.h"
#import "BotSessionManager.h"
#import "BotCollection.h"
#import "AFNetworking.h"
#import "TRVSURLSessionOperation.h"
#import "IntegrationCollection.h"
#import "XcodeServiceURLs.h"
#import "ServerDataManager.h"

@interface BotDataManager ()

@property (nonatomic, strong) BotSessionManager *botSessionManager;

@end

@implementation BotDataManager

#pragma mark - Properties

- (BotSessionManager *)botSessionManager
{
    if (!_botSessionManager)
    {
        Server *server = [ServerDataManager defaultServerConfiguration];
        
        NSURL *baseURL = [NSURL URLWithString:server.hostAddress];
        
        NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _botSessionManager = [[BotSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:urlSessionConfiguration];
    }
    
    return _botSessionManager;
}

#pragma mark - Public Methods

- (void)getBotsWithSuccess:(BotDataManagerSuccessBlock)success
                   failure:(BotDataManagerFailureBlock)failure
{
     __weak typeof(self) weakSelf = self;
    
    // get the bot collection
    [self.botSessionManager GET:@"api/bots" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        NSError *jsonModelError = nil;
        
        BotCollection *collection = [[BotCollection alloc] initWithDictionary:responseObject error:&jsonModelError];
        
        // get integrations list for each bot
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSURLSession *session = weakSelf.botSessionManager.session;
        
        NSError *requestError = nil;
        
        for (Bot *bot in collection.results)
        {
            NSString *urlString = [NSString stringWithFormat:@"api/bots/%@/integrations", bot.identifier];
            
            urlString = [[NSURL URLWithString:urlString relativeToURL:self.botSessionManager.baseURL] absoluteString];
            
            NSURLRequest *request = [weakSelf.botSessionManager.requestSerializer requestWithMethod:@"GET"
                                                                                          URLString:urlString
                                                                                         parameters:nil
                                                                                              error:&requestError];
            
            [queue addOperation:[[TRVSURLSessionOperation alloc] initWithSession:session
                                                                         request:request
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                
                
                NSError *serializationError = nil;
                NSError *jsonModelError = nil;
                NSDictionary *deserializedResponse = [weakSelf.botSessionManager.responseSerializer
                                                      responseObjectForResponse:response
                                                      data:data
                                                      error:&serializationError];
                
                IntegrationCollection *integrationCollection = [[IntegrationCollection alloc] initWithDictionary:deserializedResponse error:&jsonModelError];
                
                // only care about the most recent for our purposes
                bot.lastIntegration = integrationCollection.results.firstObject;
            }]];
        
        }

        [queue waitUntilAllOperationsAreFinished];
        
        NSLog(@"All requests are done!");
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"%@", error);
    }];
}

@end
