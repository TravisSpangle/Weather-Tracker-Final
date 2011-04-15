//
//  MapView.m
//  Weather
//
//  Created by Travis Spangle on 2/20/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "MapView.h"
#import "Station.h"
#import "CityTempAnnotation.h"

@implementation MapView

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//setup tab bar
		UIImage* anImage = [UIImage imageNamed:@"radar.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[self loadCities];
}

- (void)viewWillDisappear:(BOOL)animated {	
	self.fetchedResultsController = nil;
	[mapView removeAnnotations:mapView.annotations];	
	[super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

	//map stuff
	[mapView setDelegate:self];

	//center of united states
	CLLocationCoordinate2D usa;
    usa.latitude = 37.250556;
    usa.longitude = -96.358333;
	
	//set the span and pat out 4 percent
	MKCoordinateSpan span;
    span.latitudeDelta = 1.04*(126.766667 - 66.95) ;
    span.longitudeDelta = 1.04*(49.384472 - 24.520833) ;
	
	//setting the region
	MKCoordinateRegion region;
    region.span = span;
    region.center = usa;

	//fire cordinates onto map view
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {

    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];

    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    

#pragma mark -
#pragma mark MapView Actions

- (void)loadCities {

	NSArray *tempArray = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
	
	for (Station *station in tempArray)
	{
		CLLocationCoordinate2D cityLocation;
		cityLocation.latitude = [station.latitude doubleValue];
		cityLocation.longitude = [station.longitude doubleValue];
		[mapView addAnnotation:station];
	}
	 
	[tempArray release]; tempArray = nil;		
}

#pragma mark Map View Delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString *AnnotationViewID = @"annotationViewID";
	
    CityTempAnnotation *annotationView =
	(CityTempAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[[CityTempAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;

}

@end
