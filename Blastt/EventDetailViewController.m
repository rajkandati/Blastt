//
//  EventDetailViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/17/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "EventDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation EventDetailViewController

@synthesize event = _event;
@synthesize eventPlaceLabel = _eventPlaceLabel;
@synthesize eventImageView = _eventImageView;
@synthesize timeLabel = _timeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.eventImageView.image = [[UIImage alloc] initWithData:self.event.imageData];
    self.eventPlaceLabel.text = self.event.place;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", self.event.startDateAndTime, self.event.endDateAndTime];
}

- (IBAction)blastt
{
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init] ;
	if([MFMessageComposeViewController canSendText])
	{
		messageController.body = [NSString stringWithFormat:@"Join me for %@ at  %@. Timings: %@ - %@", self.event.name, self.event.place, self.event.startDateAndTime, self.event.endDateAndTime];
		messageController.messageComposeDelegate = self;
		[self presentViewController:messageController animated:YES completion:nil];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultFailed:
            //Maybe display an alert
			break;
		case MessageComposeResultSent:
            //Maybe display an alert
			break;
		default:
			break;
	}    
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    self.eventImageView = nil;
    self.eventPlaceLabel = nil;
    self.timeLabel = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
