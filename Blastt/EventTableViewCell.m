//
//  EventTableViewCell.m
//  Blastt
//
//  Created by Raj Kandathi on 12/17/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize eventNameLabel = _eventNameLabel;
@synthesize eventImageView = _eventImageView;
@synthesize eventPlaceLabel = _eventPlaceLabel;
@synthesize eventTimeLabel = _eventTimeLabel;
@synthesize privateLabel = _privateLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"TableCellGradient"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView = backgroundImageView;
    
    UIImage *selectedImage = [UIImage imageNamed:@"SelectedTableCellGradient"];
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
    self.selectedBackgroundView = selectedImageView;
}

@end
