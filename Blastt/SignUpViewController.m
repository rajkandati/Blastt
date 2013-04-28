//
//  SignUpViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/10/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "EventsViewController.h"
#import "LoginViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpViewController
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEventsAfterSignUp"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        EventsViewController *eventsViewController = (EventsViewController *)navigationController.topViewController;
        NSLog(@"%@", [self.presentingViewController class]);
        LoginViewController *loginViewController = (LoginViewController *)self.presentingViewController;
        eventsViewController.delegate = loginViewController;
    }
}


- (IBAction)signUpPressed {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    //input rules for non empty username and password
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self performSegueWithIdentifier:@"ShowEventsAfterSignUp" sender:self];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (IBAction)cancelPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
