//
//  LBViewController.m
//  LBGithubStatus
//
//  Created by Luca Bernardi on 26/02/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBViewController.h"
#import "LBGithubStatusAPIClient.h"
#import "LBGithubStatusMessage.h"


@interface LBViewController ()
@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateButtonTapped:(id)sender
{
    
    [self.activityIndicator startAnimating];
    
    NSURLSessionDataTask *task = [[LBGithubStatusAPIClient sharedClient] listStatusMessagesWithCompletion:^(NSArray *messages, NSError *error) {
        if (messages) {
            LBGithubStatusMessage *lastMessage = (LBGithubStatusMessage *)messages[0];
            self.messageBodyTextView.text = lastMessage.body;
            self.messageDateLabel.text    = [[LBGithubStatusAPIClient dateOutputFormatter] stringFromDate:lastMessage.createdOn];
            [self.activityIndicator stopAnimating];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
        }
    }];
    
    [task resume];
}
@end
