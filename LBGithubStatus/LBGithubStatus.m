//
//  LBGithubStatus.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatus.h"
#import "LBGithubStatusAPIClient.h"

// API Response key
static NSString * const kLBGithubStatusResponseStatusKey      = @"status";
static NSString * const kLBGithubStatusResponseLastUpdatedKey = @"last_updated";


@interface LBGithubStatus ()
@property (readwrite, copy,   nonatomic) NSString *status;
@property (readwrite, assign, nonatomic) LBGithubStatusCode statusCode;
@property (readwrite, strong, nonatomic) NSDate *lastUpdated;
@end


@implementation LBGithubStatus

#pragma mark - Init & Dealloc

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSString *statusString      = [dictionary valueForKey:kLBGithubStatusResponseStatusKey];
        NSString *lastUpdatedString = [dictionary valueForKey:kLBGithubStatusResponseLastUpdatedKey];
        _status      = statusString;
        _statusCode  = [LBGithubStatusAPIClient statusCodeFromString:statusString];
        _lastUpdated = [LBGithubStatusAPIClient dateFromISO8601String:lastUpdatedString];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: 0x%x \n\tStatus:%d; \n\tLast Updated:%@>",
                NSStringFromClass([self class]),
                (unsigned int)self,
                self.statusCode,
                self.lastUpdated];
}

@end