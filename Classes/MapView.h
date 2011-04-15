//
//  MapView.h
//  Weather
//
//  Created by Travis Spangle on 2/20/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {

	IBOutlet MKMapView *mapView;
	
	CLLocationManager *locationManager;

    NSFetchedResultsController *fetchedResultsController_;
	NSManagedObjectContext *managedObjectContext_;

}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)loadCities;

@end
