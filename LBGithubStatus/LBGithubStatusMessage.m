//
//  LBGithubStatusMessage.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatusMessage.h"
#import "LBGithubStatusAPIClient.h"

// API Response key
static NSString * const kLBGithubStatusMessageResponseStatusKey     = @"status";
static NSString * const kLBGithubStatusMessageResponseBodyKey       = @"body";
static NSString * const kLBGithubStatusMessageResponseCreatedOnKey  = @"created_on";


@interface LBGithubStatusMessage ()
@property (nonatomic, assign) LBGithubStatusCode status;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSDate *createdOn;
@end


@implementation LBGithubStatusMessage

#pragma mark - Init & Dealloc

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSString *statusString    = [dictionary valueForKey:kLBGithubStatusMessageResponseStatusKey];
        NSString *createdOnString = [dictionary valueForKey:kLBGithubStatusMessageResponseCreatedOnKey];
        NSString *bodyString      = [dictionary valueForKey:kLBGithubStatusMessageResponseBodyKey];
        _status    = [LBGithubStatusAPIClient statusCodeFromString:statusString];
        _body      = bodyString;
        _createdOn = [LBGithubStatusAPIClient dateFromISO8601String:createdOnString];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@: 0x%x \n\tStatus:%d \n\tBody:%@ \n\tCreated On:%@;>",
                NSStringFromClass([self class]),
                (unsigned int)self,
                self.status,
                self.body,
                self.createdOn];
}

@end
