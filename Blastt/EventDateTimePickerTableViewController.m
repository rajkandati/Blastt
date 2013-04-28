//
//  EventDateTimePickerTableViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/10/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "EventDateTimePickerTableViewController.h"

@interface EventDateTimePickerTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDateTimePicker;
@property (nonatomic) int selectedTableCell;

@end

@implementation EventDateTimePickerTableViewController
@synthesize eventStartTimeLabel = _eventStartTimeLabel;
@synthesize eventEndTimeLabel = _eventEndTimeLabel;
@synthesize eventDateTimePicker = _eventDateTimePicker;
@synthesize selectedTableCell = _selectedTableCell;


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)getFormattedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate:self.eventDateTimePicker.date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.eventStartTimeLabel.text = [self getFormattedDate];
}

- (IBAction)eventDateChanged:(UIDatePicker *)sender
{
    if (self.selectedTableCell == 0) {
        self.eventStartTimeLabel.text = [self getFormattedDate];
    } else if (self.selectedTableCell == 1) {
        self.eventEndTimeLabel.text = [self getFormattedDate];
    }
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.delegate eventDateTimePickerTableViewController:self
                                     didPickStartDateTime:self.eventStartTimeLabel.text
                                           andEndDateTime:self.eventEndTimeLabel.text];
}

#pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTableCell = indexPath.row;
}

- (void)didReceiveMemoryWarning
{
    self.eventDateTimePicker = nil;
    self.eventStartTimeLabel = nil;
    self.eventEndTimeLabel = nil;
    [super didReceiveMemoryWarning];
}

@end
