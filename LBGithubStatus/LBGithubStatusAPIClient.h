//
//  LBGithubStatusAPIClient.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LBGithubStatus.h"

typedef enum  {
    LBGithubStatusMessageErrorCodeMalformedResponse = 1000,
} LBGithubStatusMessageErrorCode;

extern NSString * const LBGithubStatusStringGood;
extern NSString * const LBGithubStatusStringMinor;
extern NSString * const LBGithubStatusStringMajor;
extern NSString * const kLBGithubStatusAPIClientErrorDomain;

typedef void(^LBGithubStatusMessageCompletionBlock)(NSArray *messages, NSError *error);
typedef void(^LBGithubStatusCompletionBlock)(LBGithubStatus *status, NSError *error);

@interface LBGithubStatusAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)listStatusMessagesWithCompletion:(LBGithubStatusMessageCompletionBlock)completionBlock;
- (NSURLSessionDataTask *)fetchGithubStatusWithCompletion:(LBGithubStatusCompletionBlock)completionBlock;

+ (LBGithubStatusCode)statusCodeFromString:(NSString *)statusString;
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;
+ (NSDateFormatter *)dateOutputFormatter;

@end
