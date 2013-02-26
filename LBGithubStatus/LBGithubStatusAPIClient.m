//
//  LBGithubStatusAPIClient.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatusAPIClient.h"

#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

static NSString * const kLBGithubStatusAPIBaseURLString = @"https://status.github.com/api/";

NSString * const LBGithubStatusStringGood  = @"good";
NSString * const LBGithubStatusStringMinor = @"minor";
NSString * const LBGithubStatusStringMajor = @"major";

@implementation LBGithubStatusAPIClient

+ (instancetype)sharedClient
{
    static LBGithubStatusAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kLBGithubStatusAPIBaseURLString];
        _sharedClient = [[LBGithubStatusAPIClient alloc] initWithBaseURL:baseURL];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
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
