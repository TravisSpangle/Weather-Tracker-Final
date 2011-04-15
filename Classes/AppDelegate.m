//
//  weatherAppDelegate.m
//  weather
//
//  Created by Travis Spangle on 2/14/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "StationController.h"
#import "MapView.h"

@implementation AppDelegate

@synthesize window;

- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Create Station Controller and set managedObjectContext
	StationController *stationController = [[[StationController alloc] init] autorelease];
	stationController.managedObjectContext = self.managedObjectContext;

	// Call and set Navigation Controller on Station Controller
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stationController];
	
	// Create the first of two view controllers for our Tab Bar
	UIViewController *nv = navigationController;
	
	// Create the second of two view controllers for our Tab Bar
	MapView *mv = [[MapView alloc] init];
	mv.managedObjectContext = self.managedObjectContext;
	
	UIViewController *viewMap = mv;
	
	// Make an array containing the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects:nv, viewMap, nil];
	
	// Create the tabBarController
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	// Attach them to the tab bar controller
	[tabBarController setViewControllers:viewControllers];
	
	[nv release];
	[mv release];
	
	// Put the tabBarController's view on the window
	[window setRootViewController:tabBarController];
	[tabBarController release];
	
    // Show the window
	[self.window makeKeyAndVisible];
	
    return YES;	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"weather.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

