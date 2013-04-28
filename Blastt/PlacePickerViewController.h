//
//  PlacePickerViewController.h
//  Blastt
//
//  Created by Raj Kandathi on 12/11/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlacePickerViewController;
@protocol PlacePickerViewControllerDelegate <NSObject>
- (void)placePickerViewController:(PlacePickerViewController*)placePickerViewController didPickPlace:(NSString*)placeName;
@end

@interface PlacePickerViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) id <PlacePickerViewControllerDelegate> delegate;
@end
