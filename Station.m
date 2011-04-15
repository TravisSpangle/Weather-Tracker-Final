// 
//  Station.m
//  weather
//
//  Created by Travis Spangle on 2/14/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "Station.h"


@implementation Station 

@dynamic code, weather, temperature, latitude, name, longitude;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

@end
