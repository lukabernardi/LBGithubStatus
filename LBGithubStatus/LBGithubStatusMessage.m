//
//  LBGithubStatusMessage.m
//  GithubStatus
//
//  Created by Luca Bernardi on 17/12/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "LBGithubStatusMessage.h"

NSString * const kLBGithubStatusMessageErrorDomain = @"com.lucabernardi.githubstatus.error";

static NSString * const kLBGithubStatusMessagesPath = @"messages.json";

// API Response key
static NSString * const kLBGithubStatusMessageResponseStatusKey     = @"status";
static NSString * const kLBGithubStatusMessageResponseBodyKey       = @"body";
static NSString * const kLBGithubStatusMessageResponseCreatedOnKey  = @"created_on";


@interface LBGithubStatusMessage ()

@property (readwrite, assign, nonatomic) LBGithubStatusCode status;
@property (readwrite, copy, nonatomic) NSString *body;
@property (readwrite, strong, nonatomic) NSDate *createdOn;

@end


@implementation LBGithubStatusMessage

#pragma mark - Init & Dealloc

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        NSString *statusString = [attributes valueForKey:kLBGithubStatusMessageResponseStatusKey];
        _status = [LBGithubStatusAPIClient statusCodeFromString:statusString];
        
        _body = [attributes valueForKey:kLBGithubStatusMessageResponseBodyKey];
        
        NSString *createdOnString = [attributes valueForKey:kLBGithubStatusMessageResponseCreatedOnKey];
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

#pragma mark - Remote API

+ (void)listStatusMessagesWithCompletion:(LBGithubStatusMessageCompletionBlock)completionBlock
                                   error:(LBGithubStatusMessageErrorBlock)errorBlock
{
    
    [[LBGithubStatusAPIClient sharedClient] getPath:kLBGithubStatusMessagesPath
                                         parameters:nil
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                if ((responseObject != nil)
                                                    && [responseObject isKindOfClass:[NSArray class]]) {
                                                    
                                                    NSMutableArray *messages = [NSMutableArray array];
                                                    for (NSDictionary *messageDictionary in responseObject) {
                                                        
                                                        LBGithubStatusMessage *message = [[LBGithubStatusMessage alloc] initWithAttributes:messageDictionary];
                                                        [messages addObject:message];
                                                    }
                                                    
                                                    if (completionBlock) {
                                                        completionBlock(messages);
                                                    }
                                                    
                                                } else {
                                                    NSError *error = [NSError errorWithDomain:kLBGithubStatusMessageErrorDomain
                                                                                         code:LBGithubStatusMessageErrorCodeMalformedResponse
                                                                                     userInfo:@{NSLocalizedDescriptionKey : @"Error while parsing response"}];
                                                    if (errorBlock) {
                                                        errorBlock(error);
                                                    }
                                                }

                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                if (errorBlock) {
                                                    errorBlock(error);
                                                }
                                            }];
}

@end
