//
//  EventDateTimePickerTableViewController.h
//  Blastt
//
//  Created by Raj Kandathi on 12/10/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventDateTimePickerTableViewController;
@protocol EventDateTimePickerTableViewControllerDelegate <NSObject>
- (void)eventDateTimePickerTableViewControllerDidCancel:(EventDateTimePickerTableViewController *)eventDateTimePickerTableViewController;
- (void)eventDateTimePickerTableViewController:(EventDateTimePickerTableViewController *)eventDateTimePickerTableViewController
                               didPickStartDateTime:(NSString *)startDateTimeString
                               andEndDateTime: (NSString *)endDateTimeString;
@end

@interface EventDateTimePickerTableViewController : UITableViewController
@property(nonatomic, weak) id<EventDateTimePickerTableViewControllerDelegate> delegate;
@end
