//
//  CreateStation.m
//  Weather
//
//  Created by Travis Spangle on 2/16/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "CreateStation.h"
#import "Station.h"
#import "Weather.h"

@implementation CreateStation

@synthesize station=station_,managedObjectContext = managedObjectContext_, weatherLookUp;
@synthesize nameField=nameField_;

-(id)init{
	weatherLookUp = [[Weather alloc] init];
	
	return self;
}

- (void)dealloc {
    [super dealloc];
	[managedObjectContext_ release];
	[weatherLookUp release];
}

-(void)cancelEditing {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)doneEditing {
	 if(!self.station) {
		 self.station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
	 }

	self.station.name = self.nameField.text;
	self.station.weather = @"Loading...";

	NSError *error = nil;
	if(![self.managedObjectContext save:&error]) {
		NSLog(@"%s: Problem saving: %@",__PRETTY_FUNCTION__, error);
	}

	self.weatherLookUp.station = self.station;
	self.weatherLookUp.managedObjectContext = self.managedObjectContext;

	[[self weatherLookUp] findCityWeather:self.station.name];	

	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.nameField.text = self.station.name;	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)] autorelease];
	
	self.navigationItem.title = @"Add City";
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
 	self.nameField = nil;
}

@end
