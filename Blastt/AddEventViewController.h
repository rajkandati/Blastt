//
//  AddEventViewController.h
//  Blastt
//
//  Created by Raj Kandathi on 12/16/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventDateTimePickerTableViewController.h"
#import "PlacePickerViewController.h"


@class AddEventViewController;
@protocol AddEventViewControllerDelegate <NSObject>
- (void)addEventViewController:(AddEventViewController *)addEventViewController didFinishAddingEvent:(Event*)event;
- (void)addEventViewControllerDidCancel:(AddEventViewController *)addEventViewController;
@end

@interface AddEventViewController : UITableViewController <UITextFieldDelegate, EventDateTimePickerTableViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, PlacePickerViewControllerDelegate>
@property (weak, nonatomic) id<AddEventViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
- (IBAction)cancel;
- (IBAction)done;
@end
