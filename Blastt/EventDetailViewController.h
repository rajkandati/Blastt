//
//  EventDetailViewController.h
//  Blastt
//
//  Created by Raj Kandathi on 12/17/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <MessageUI/MessageUI.h>

@interface EventDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong) Event *event;

@end
