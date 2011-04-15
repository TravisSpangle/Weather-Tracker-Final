//
//  Weather.h
//  weather
//
//  Created by Travis Spangle on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Station;

@interface Weather : NSObject <NSXMLParserDelegate> {
	BOOL waitingForDisplayLocation;
	
    NSMutableData *xmlData; 
	NSURLConnection *connectionInProgress; 
	NSMutableString *xmlContent;
	
	Station *station_;
	NSManagedObjectContext *managedObjectContext_;
	
	id objectToNotify;
	SEL actionToCall;
}

@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (assign) id objectToNotify;
@property (assign) SEL actionToCall;

- (void)findCityWeatherAndCallBack:(NSString *)city sender:(id)sender withSelector:(SEL)action;
- (void)findCityWeather:(NSString *)city;

@end
