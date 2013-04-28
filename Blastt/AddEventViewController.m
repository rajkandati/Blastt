//
//  AddEventViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/16/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "AddEventViewController.h"


@interface AddEventViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventStatusSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) UIImage *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;

@end

@implementation AddEventViewController

@synthesize eventNameTextField = _eventNameTextField;
@synthesize doneBarButton = _doneBarButton;
@synthesize delegate = _delegate;
@synthesize event = _event;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize endTimeLabel = _endTimeLabel;
@synthesize eventStatusSegmentedControl = _eventStatusSegmentedControl;
@synthesize eventImageView = _eventImageView;
@synthesize imgPicker = _imgPicker;
@synthesize eventImage = _eventImage;
@synthesize eventPlace = _eventPlace;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventImageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.eventImageView addGestureRecognizer:tapGesture];
    
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (UIImage *)eventImage
{
    if (!_eventImage) {
        _eventImage = [[UIImage alloc] init];
    }
    return _eventImage;
}

- (void)imageTapped:(UITapGestureRecognizer *)tapGesture
{
    //[self presentModalViewController:self.imgPicker animated:YES];
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

- (NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate:date];
}


- (Event *)event
{
    if (!_event) {
        _event = [[Event alloc] init];
    }
    return _event;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.event.name) self.eventNameTextField.text = self.event.name;
    if (self.event.startDateAndTime) {
        self.startTimeLabel.text = self.event.startDateAndTime;
    } else {
        self.startTimeLabel.text = [self getFormattedDate:[NSDate date]];
    }
    if (self.event.endDateAndTime) self.endTimeLabel.text = self.event.endDateAndTime;
    if (self.event.place) self.eventPlace.text = self.event.place;
}

- (void)didReceiveMemoryWarning
{
    self.eventNameTextField = nil;
    self.doneBarButton = nil;
    self.startTimeLabel = nil;
    self.endTimeLabel = nil;
    self.eventStatusSegmentedControl = nil;
    self.eventImageView = nil;
    self.imgPicker = nil;
    self.eventPlace = nil;
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.eventNameTextField resignFirstResponder];
    if ([segue.identifier isEqualToString:@"PickDateAndTime"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        EventDateTimePickerTableViewController *eventDateTimePickerTableViewController = (EventDateTimePickerTableViewController *)navigationController.topViewController;
        eventDateTimePickerTableViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"PickPlace"]) {
        PlacePickerViewController *placePickerViewController = (PlacePickerViewController*)segue.destinationViewController;
        placePickerViewController.delegate = self;
    }
}

- (IBAction)cancel
{
    [self.delegate addEventViewControllerDidCancel:self];
}

- (IBAction)done
{
    self.event.name = self.eventNameTextField.text;
    self.event.startDateAndTime = self.startTimeLabel.text;
    self.event.endDateAndTime = self.endTimeLabel.text;
    self.event.place = self.eventPlace.text;
    if (self.eventStatusSegmentedControl.selectedSegmentIndex == 0) {
        self.event.publicStatus = YES;
    } else {
        self.event.publicStatus = NO;
    }

    [self.delegate addEventViewController:self didFinishAddingEvent:self.event];
}

# pragma PlacePickerViewControllerDelegate methods

- (void)placePickerViewController:(PlacePickerViewController *)placePickerViewController didPickPlace:(NSString *)placeName
{
    if (placeName && placeName.length > 0) {
        self.event.place = placeName;
        self.eventPlace.text = self.event.place;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma EventDateTimePickerTableViewControllerDelegate methods

- (void)eventDateTimePickerTableViewController:(EventDateTimePickerTableViewController *)eventDateTimePickerTableViewController
                               didPickStartDateTime:(NSString *)startDateTimeString
                               andEndDateTime: (NSString *)endDateTimeString
{
    if (startDateTimeString) self.event.startDateAndTime = startDateTimeString;
    if (endDateTimeString) self.event.endDateAndTime = endDateTimeString;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)eventDateTimePickerTableViewControllerDidCancel:(EventDateTimePickerTableViewController *)eventDateTimePickerTableViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    self.eventImageView.image = img;
    self.event.imageData = UIImagePNGRepresentation(img);
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma UITextFieldDelegate methods.

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

# pragma UITableViewDataSource methods
/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 60.0;
    } else {
        return 43.0;
    }
}*/

# pragma UITableViewDelegate methods.

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.eventNameTextField resignFirstResponder];

}

@end
