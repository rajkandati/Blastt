//
//  LoginViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/9/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEvents"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        EventsViewController *eventsViewController = (EventsViewController *)navigationController.topViewController;
        eventsViewController.delegate = self;
    }
}

- (void)eventsViewControllerDidLogout:(EventsViewController *)eventsViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)loginPressed {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"ShowEvents" sender:self];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        
    }];
}

@end
