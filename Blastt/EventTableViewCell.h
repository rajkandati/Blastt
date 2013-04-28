//
//  EventTableViewCell.h
//  Blastt
//
//  Created by Raj Kandathi on 12/17/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UIImageView *eventImageView;
@property(nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *eventPlaceLabel;
@property(nonatomic, weak) IBOutlet UILabel *eventTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *privateLabel;

@end
