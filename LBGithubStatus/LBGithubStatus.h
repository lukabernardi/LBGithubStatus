//
//  LBGithubStatus.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBGithubStatusAPIClient.h"

@class LBGithubStatus;

typedef void(^LBGithubStatusCompletionBlock)(LBGithubStatus *);
typedef void(^LBGithubStatusErrorBlock)(NSError *);


@interface LBGithubStatus : NSObject

@property (readonly, copy,   nonatomic) NSString *status;
@property (readonly, assign, nonatomic) LBGithubStatusCode statusCode;
@property (readonly, strong, nonatomic) NSDate *lastUpdated;

/**
 Retrive the current github status
 */
+ (void)fetchGithubStatusWithCompletion:(LBGithubStatusCompletionBlock)completionBlock
                                  error:(LBGithubStatusErrorBlock)errorBlock;
@end
