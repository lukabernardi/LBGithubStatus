//
//  LBGithubStatus.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatus.h"


static NSString * const kLBGithubStatusPath = @"status.json";

// API Response key
static NSString * const kLBGithubStatusResponseStatusKey     = @"status";
static NSString * const kLBGithubStatusResponseLastUpdatedKey = @"last_updated";


@interface LBGithubStatus ()
@property (readwrite, copy,   nonatomic) NSString *status;
@property (readwrite, assign, nonatomic) LBGithubStatusCode statusCode;
@property (readwrite, strong, nonatomic) NSDate *lastUpdated;
@end


@implementation LBGithubStatus

#pragma mark - Init & Dealloc

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        NSString *statusString = [attributes valueForKey:kLBGithubStatusResponseStatusKey];
        _status     = statusString;
        _statusCode = [LBGithubStatusAPIClient statusCodeFromString:statusString];
        
        NSString *lastUpdatedString = [attributes valueForKey:kLBGithubStatusResponseLastUpdatedKey];
        _lastUpdated = [LBGithubStatusAPIClient dateFromISO8601String:lastUpdatedString];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@: 0x%x \n\tStatus:%d; \n\tLast Updated:%@>",
                NSStringFromClass([self class]),
                (unsigned int)self,
                self.statusCode,
                self.lastUpdated];
}

#pragma mark - Remote API

+ (void)fetchGithubStatusWithCompletion:(LBGithubStatusCompletionBlock)completionBlock
                             error:(LBGithubStatusErrorBlock)errorBlock
{
    [[LBGithubStatusAPIClient sharedClient] getPath:kLBGithubStatusPath
                                         parameters:nil
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                LBGithubStatus *status = [[LBGithubStatus alloc] initWithAttributes:responseObject];
                                                if (completionBlock) {
                                                    completionBlock(status);
                                                }
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                if (errorBlock) {
                                                    errorBlock(error);
                                                }
                                            }];
}

@end
