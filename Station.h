//
//  Station.h
//  weather
//
//  Created by Travis Spangle on 2/14/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface Station :  NSManagedObject  <MKAnnotation> 
{
	NSString * code;
	NSString * weather;
	NSString * temperature;
	NSNumber * latitude;
	NSString * name;
	NSNumber * longitude;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSString * temperature;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end



