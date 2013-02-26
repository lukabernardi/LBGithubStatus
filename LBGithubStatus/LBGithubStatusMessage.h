//
//  LBGithubStatusMessage.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBGithubStatusAPIClient.h"

@class LBGithubStatusMessage;

typedef void(^LBGithubStatusMessageCompletionBlock)(NSArray *);
typedef void(^LBGithubStatusMessageErrorBlock)(NSError *);

extern NSString * const kLBGithubStatusMessageErrorDomain;

typedef enum  {
    LBGithubStatusMessageErrorCodeMalformedResponse = 1000,
} LBGithubStatusMessageErrorCode;


@interface LBGithubStatusMessage : NSObject

@property (readonly, assign, nonatomic) LBGithubStatusCode status;
@property (readonly, copy,   nonatomic) NSString *body;
@property (readonly, strong, nonatomic) NSDate *createdOn;

/** 
 Retrive all the last status messages available
 */
+ (void)listStatusMessagesWithCompletion:(LBGithubStatusMessageCompletionBlock)completionBlock
                                   error:(LBGithubStatusMessageErrorBlock)errorBlock;
@end
