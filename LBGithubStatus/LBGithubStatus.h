//
//  LBGithubStatus.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LBGithubStatusCode) {
    LBGithubStatusCodeGood,
    LBGithubStatusCodeMinor,
    LBGithubStatusCodeMajor,
    LBGithubStatusCodeUnknow = 99,
};

@interface LBGithubStatus : NSObject

@property (nonatomic, readonly, copy) NSString *status;
@property (nonatomic, readonly, assign) LBGithubStatusCode statusCode;
@property (nonatomic, readonly, strong) NSDate *lastUpdated;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
