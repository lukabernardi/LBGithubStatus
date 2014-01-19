//
//  LBGithubStatusAPIClient.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatusAPIClient.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "LBGithubStatusMessage.h"
#import "LBGithubStatus.h"

static NSString * const kLBGithubStatusAPIBaseURLString = @"https://status.github.com/api/";
static NSString * const kLBGithubStatusMessagesPath     = @"messages.json";
static NSString * const kLBGithubStatusPath             = @"status.json";

NSString * const LBGithubStatusStringGood            = @"good";
NSString * const LBGithubStatusStringMinor           = @"minor";
NSString * const LBGithubStatusStringMajor           = @"major";
NSString * const kLBGithubStatusAPIClientErrorDomain = @"com.lucabernardi.githubstatus.error";

@implementation LBGithubStatusAPIClient

#pragma mark - Init & Dealloc

+ (instancetype)sharedClient
{
    static LBGithubStatusAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kLBGithubStatusAPIBaseURLString];
        _sharedClient = [[LBGithubStatusAPIClient alloc] initWithBaseURL:baseURL];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

#pragma mark - API

- (NSURLSessionDataTask *)listStatusMessagesWithCompletion:(LBGithubStatusMessageCompletionBlock)completionBlock
{
    NSURLSessionDataTask *task = [self GET:kLBGithubStatusMessagesPath
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       if ((responseObject != nil)
                                           && [responseObject isKindOfClass:[NSArray class]]) {
                                           
                                           NSMutableArray *messages = [NSMutableArray array];
                                           for (NSDictionary *messageDictionary in responseObject) {
                                               
                                               LBGithubStatusMessage *message = [[LBGithubStatusMessage alloc] initWithDictionary:messageDictionary];
                                               [messages addObject:message];
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock([NSArray arrayWithArray:messages], nil);
                                           }
                                           
                                       } else {
                                           if (completionBlock) {
                                               completionBlock(nil, [self malformedResponseError]);
                                           }
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       if (completionBlock) {
                                           completionBlock(nil, error);
                                       }
                                   }];
    return task;
}

- (NSURLSessionDataTask *)fetchGithubStatusWithCompletion:(LBGithubStatusCompletionBlock)completionBlock
{
    NSURLSessionDataTask *task = [self GET:kLBGithubStatusPath
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       LBGithubStatus *status = [[LBGithubStatus alloc] initWithDictionary:responseObject];
                                       if (completionBlock) {
                                           completionBlock(status, nil);
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       if (completionBlock) {
                                           completionBlock(nil, error);
                                       }
                                   }];
    return task;
}

#pragma mark - Error

- (NSError *)malformedResponseError
{
    NSError *error = [NSError errorWithDomain:kLBGithubStatusAPIClientErrorDomain
                                         code:LBGithubStatusMessageErrorCodeMalformedResponse
                                     userInfo:@{NSLocalizedDescriptionKey : @"Error while parsing response"}];
    return error;
}


#pragma mark - Parsa API data

+ (LBGithubStatusCode)statusCodeFromString:(NSString *)statusString
{
    if ([statusString isEqualToString:LBGithubStatusStringGood]) {
        return LBGithubStatusCodeGood;
    } else if ([statusString isEqualToString:LBGithubStatusStringMinor]) {
        return LBGithubStatusCodeMinor;
    } else if ([statusString isEqualToString:LBGithubStatusStringMajor]) {
        return LBGithubStatusCodeMajor;
    }
    
    return LBGithubStatusCodeUnknow;
}


#pragma mark - Date Formatter

+ (NSDate *)dateFromISO8601String:(NSString *)dateString
{
    ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];
    NSDate *parsedDate = [dateFormatter dateFromString:dateString];
    return parsedDate;
}

/**
 As Apple said [NSDateFormatter init] is very expensive (https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW10)
 In Apple's code is used a static const, but since NSDateFormatter
 isn't thread safe a better approach is to use Thread local store (http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/Multithreading/CreatingThreads/CreatingThreads.html#//apple_ref/doc/uid/10000057i-CH15-SW4)
 to cache the NSDateFormatter instance
 */

NSString * const kCachedDateFormatterKey = @"CachedDateFormatterKey";

+ (NSDateFormatter *)dateOutputFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedDateFormatterKey];
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        [threadDictionary setObject:dateFormatter forKey:kCachedDateFormatterKey];
    }
    return dateFormatter;
}

@end
