//
//  LBViewController.h
//  LBGithubStatus
//
//  Created by Luca Bernardi on 26/02/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *messageBodyTextView;
@property (strong, nonatomic) IBOutlet UILabel *messageDateLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)updateButtonTapped:(id)sender;

@end
