//
//  Weather.m
//  weather
//
//  Created by Travis Spangle on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Weather.h"
#import "Station.h"

@implementation Weather

@synthesize station = station_, managedObjectContext = managedObjectContext_;
@synthesize objectToNotify, actionToCall;

- (id)init {
	xmlData = [[NSMutableData alloc] init]; 
	
    return self;
}

- (void)dealloc {
    [super dealloc];
	[station_ release];
	[xmlData release];
	[managedObjectContext_ release];
}

- (void)findCityWeatherAndCallBack:(NSString *)city sender:(id)sender withSelector:(SEL)action {
	
	[self findCityWeather:city];
	self.objectToNotify = sender;
	self.actionToCall = action;

}

- (void)findCityWeather:(NSString *)city
{
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=%@", [city stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];//self.station.name]];
	
	// Create a request object with that URL								  
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringCacheData 
										 timeoutInterval:30]; 
	
    // Clear out the existing connection if there is one 
    if (connectionInProgress) { 
        [connectionInProgress cancel]; 
        [connectionInProgress release]; 
    } 
	
	// Create and initiate the connection
    connectionInProgress = [[[NSURLConnection alloc] initWithRequest:request 
                                                           delegate:self 
                                                   startImmediately:YES] autorelease]; 
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [xmlData appendData:data]; 
} 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{ 	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData]; 
    [parser setDelegate:self]; 
    [parser parse]; 
    [parser release]; 

	waitingForDisplayLocation = NO;
} 

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict 
{ 	
	if([elementName isEqual:@"display_location"])
	{
		waitingForDisplayLocation = YES;
	}
	
    if (([elementName isEqual:@"latitude"] || [elementName isEqual:@"longitude"]) && waitingForDisplayLocation) { 
        xmlContent = [[[NSMutableString alloc] init] autorelease]; 
    } 
	
	if ([elementName isEqual:@"temp_f"] || [elementName isEqual:@"weather"]) {
		xmlContent = [[[NSMutableString alloc] init] autorelease];
	}
} 
- (void)parser:(NSXMLParser *)parser 
foundCharacters:(NSString *)string 
{ 
	[xmlContent setString:string];
} 
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{ 
	BOOL shouldAbort = NO;
	
	if(!self.station) {
		self.station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
	}
	
	if ([elementName isEqual:@"latitude"] && waitingForDisplayLocation) { 
		if ([xmlContent isEqual:@""]) {
			shouldAbort = YES;
		}
		self.station.latitude = [NSNumber numberWithDouble: [xmlContent doubleValue]];
    }
	
	if ([elementName isEqual:@"longitude"] && waitingForDisplayLocation) { 
		if ([xmlContent isEqual:@""]) {
			shouldAbort = YES;
		}
		self.station.longitude = [NSNumber numberWithDouble: [xmlContent doubleValue]];
    }
	
	if([elementName isEqual:@"display_location"])
	{
		waitingForDisplayLocation = NO;
	}
	
	if ([elementName isEqual:@"temp_f"]) {
		if ([xmlContent isEqual:@""]) {
			shouldAbort = YES;
		}
		self.station.temperature = [NSString stringWithFormat:@"%@", xmlContent];
	}
	
	if ([elementName isEqual:@"weather"]) {
		if ([xmlContent isEqual:@""]) {
			shouldAbort = YES;
		}
		self.station.weather = [NSString stringWithFormat:@"%@", xmlContent];
	}
	
	if (shouldAbort) {
		self.station.weather = @"Error: Could not find data";
		[parser abortParsing];
	}
} 

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSError *error = nil;
	if(![self.managedObjectContext save:&error]) {
		NSLog(@"%s: Problem saving: %@",__PRETTY_FUNCTION__, error);
	}

	[self.objectToNotify performSelector:self.actionToCall withObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{ 
	NSLog(@"%@",error);
    [connectionInProgress release]; 
    connectionInProgress = nil; 
    [xmlData release]; 
    xmlData = nil; 
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", 
                             [error localizedDescription]]; 
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString 
                                                             delegate:nil 
                                                    cancelButtonTitle:@"OK" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:nil]; 
    [actionSheet autorelease]; 
}    

@end
