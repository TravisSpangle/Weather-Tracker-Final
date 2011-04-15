//
//  CreateStation.h
//  Weather
//
//  Created by Travis Spangle on 2/16/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;
@class Weather;

@interface CreateStation : UIViewController {

	UITextField *nameField_;
	
	NSManagedObjectContext *managedObjectContext_;
	Station *station_;
	Weather *weatherLookUp;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) Weather *weatherLookUp;

@end
