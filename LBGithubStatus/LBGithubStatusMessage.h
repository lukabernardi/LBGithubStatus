//
//  LBGithubStatusMessage.h
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBGithubStatus.h"

@interface LBGithubStatusMessage : NSObject

@property(nonatomic, readonly, assign) LBGithubStatusCode status;
@property(nonatomic, readonly, copy) NSString *body;
@property(nonatomic, readonly, strong) NSDate *createdOn;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
