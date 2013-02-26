//
//  LBGithubStatusAPIClient.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum {
    LBGithubStatusCodeGood,
    LBGithubStatusCodeMinor,
    LBGithubStatusCodeMajor,
    LBGithubStatusCodeUnknow = 99,
} LBGithubStatusCode;

extern NSString * const LBGithubStatusStringGood;
extern NSString * const LBGithubStatusStringMinor;
extern NSString * const LBGithubStatusStringMajor;

@interface LBGithubStatusAPIClient : AFHTTPClient

+ (instancetype)sharedClient;

+ (LBGithubStatusCode)statusCodeFromString:(NSString *)statusString;
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;
+ (NSDateFormatter *)dateOutputFormatter;

@end
