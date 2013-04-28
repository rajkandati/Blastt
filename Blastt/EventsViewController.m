//
//  EventsViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/10/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "EventsViewController.h"
#import <Parse/Parse.h>
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"

static NSString *const LoadingCell = @"LoadingCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";


@interface EventsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property(nonatomic, strong) NSMutableArray *events;

@end

@implementation EventsViewController {
    BOOL isLoading;
}
@synthesize eventsTableView = _eventsTableView;
@synthesize events = _events;

- (void)parseEeventPFObjects:(NSArray *)pfEvents
{
    for (PFObject *pfEvent in pfEvents)
    {
        Event *event = [[Event alloc] init];
        PFFile *image = (PFFile *)[pfEvent objectForKey:@"Event_Image"];
        event.imageData = image.getData;
        event.name = [pfEvent objectForKey:@"Event_Name"];
        event.startDateAndTime = [pfEvent objectForKey:@"Start_Time"];
        event.endDateAndTime = [pfEvent objectForKey:@"End_Time"];
        event.place = [pfEvent objectForKey:@"Event_Place"];
        if ([[pfEvent objectForKey:@"Public_Flag"] isEqualToString:@"YES"]) {
            event.publicStatus = YES;
        } else {
            event.publicStatus = NO;
        }
        [self.events addObject:event];
    }
}

- (void)loadEventsFromParse {
    isLoading = YES;
    [self.eventsTableView reloadData];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query orderByDescending:@"createdAt"];
    //self.events = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.events = nil;
            self.events = [[NSMutableArray alloc] init];
            //NSLog(@"%@", objects);
            [self parseEeventPFObjects:objects];
            isLoading = NO;
            [self.eventsTableView reloadData];
            //self.events = [[NSMutableArray alloc] initWithArray:objects];
        } else {
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            isLoading = NO;
            [self.eventsTableView reloadData];
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"EventTableViewCell" bundle:nil];
    [self.eventsTableView registerNib:cellNib forCellReuseIdentifier:@"EventTableViewCell"];
    self.eventsTableView.rowHeight = 120;
    
    cellNib = [UINib nibWithNibName:LoadingCell bundle:nil];
    [self.eventsTableView registerNib:cellNib forCellReuseIdentifier:LoadingCell];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.eventsTableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadEventsFromParse];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddEventViewController *addEventViewController = (AddEventViewController *)navigationController.topViewController;
        addEventViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DisplayEvent"]) {
        EventDetailViewController *eventDetailViewController = (EventDetailViewController *)segue.destinationViewController;
        Event *selectedEvent = [self.events objectAtIndex:[self.eventsTableView indexPathForSelectedRow].row];
        eventDetailViewController.title = selectedEvent.name;
        eventDetailViewController.event = selectedEvent;
    }
}

- (IBAction)logout:(id)sender {
    [self.delegate eventsViewControllerDidLogout:self];
}

#pragma AddEventViewControllerDelegate

- (void)addEventViewControllerDidCancel:(AddEventViewController *)addEventViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addEventViewController:(AddEventViewController *)addEventViewController didFinishAddingEvent:(Event *)event
{
    int newRowIndex;
    if([self.events count] == 0)
    {
        newRowIndex = 1;
    } else {
        newRowIndex = [self.events count];
    }
    self.events = [[NSMutableArray alloc] init];
    [self.events addObject:event];
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    //NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    //[self.eventsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.eventsTableView reloadData];
    
    
    PFFile *file = [PFFile fileWithName:@"img" data:event.imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *pfEvent = [PFObject objectWithClassName:@"Event"];
            [pfEvent setObject:event.name forKey:@"Event_Name"];
            [pfEvent setObject:event.place forKey:@"Event_Place"];
            [pfEvent setObject:event.startDateAndTime forKey:@"Start_Time"];
            [pfEvent setObject:event.endDateAndTime forKey:@"End_Time"];
            [pfEvent setObject:(event.publicStatus? @"YES": @"NO") forKey:@"Public_Flag"];
            [pfEvent setObject:[PFUser currentUser] forKey:@"User"];
            [pfEvent setObject:file forKey:@"Event_Image"];
            
            [pfEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];        }
    }];
}

#pragma UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoading) {
        return 1;
    } else if (self.events == Nil || [self.events count] == 0) {
        return 1;
    } else {
        return self.events.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell" ];
    if (isLoading) {
        return [tableView dequeueReusableCellWithIdentifier:LoadingCell];
    }else if (self.events == nil) {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    } else {
        Event *event = [self.events objectAtIndex:indexPath.row];
        eventCell.eventNameLabel.text = event.name;
        eventCell.eventPlaceLabel.text = event.place;
        eventCell.eventTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", event.startDateAndTime, event.endDateAndTime];
        eventCell.eventImageView.image = [UIImage imageWithData:event.imageData];
        NSLog(@"%@", (event.publicStatus? @"YES": @"NO"));
        if (!event.publicStatus) {
            eventCell.privateLabel.hidden = NO;
        }
    }
    return eventCell;
}

#pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DisplayEvent" sender:[self.events objectAtIndex:indexPath.row]];
    [self.eventsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.events count] ==0 || isLoading) {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)didReceiveMemoryWarning
{
    self.eventsTableView = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
