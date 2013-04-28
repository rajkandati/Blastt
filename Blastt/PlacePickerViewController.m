//
//  PlacePickerViewController.m
//  Blastt
//
//  Created by Raj Kandathi on 12/11/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import "PlacePickerViewController.h"
#import "GooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface PlacePickerViewController ()
@property(nonatomic, copy) NSArray *eventLocations;

@end

@implementation PlacePickerViewController
@synthesize eventLocations = _eventLocations;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSArray *)eventLocations
{
    if (!_eventLocations) {
        _eventLocations = [[NSMutableArray alloc] init];
    }
    return _eventLocations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.eventLocations objectAtIndex:indexPath.row];
}

# pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

# pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController.searchBar resignFirstResponder];
    [self.delegate placePickerViewController:self didPickPlace:[self placeAtIndexPath:indexPath].name];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(mockSearch:) userInfo:searchString repeats:NO];
    GooglePlacesAutocompleteQuery *query = [GooglePlacesAutocompleteQuery query];
    query.input = searchString;
    query.radius = 100.0;
    query.language = @"en";
    query.types = SPPlaceTypeEstablishment; 
    query.location = CLLocationCoordinate2DMake(40.729481, -73.996422);
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            self.eventLocations = nil;
            self.eventLocations = [NSArray arrayWithArray:places];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    return NO;
}


@end
