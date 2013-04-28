//
//  EventsViewController.h
//  Blastt
//
//  Created by Raj Kandathi on 12/10/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"

@class EventsViewController;

@protocol EventsViewControllerDelegate <NSObject>
- (void)eventsViewControllerDidLogout:(EventsViewController *)eventsViewController;
@end

@interface EventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddEventViewControllerDelegate>

@property(nonatomic, weak) id <EventsViewControllerDelegate> delegate;

@end
