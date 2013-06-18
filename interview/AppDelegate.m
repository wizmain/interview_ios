//
//  AppDelegate.m
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "HTTPRequest.h"
#import "Utils.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    
    [mainViewController release];
    [loginViewController release];
    [authUserID release];
    //[httpRequest release];
    [version release];
    
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize mainViewController, loginViewController;
@synthesize authUserID, version, alertRunning;
//@synthesize httpRequest;


+ (AppDelegate *)sharedAppDelegate {
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    //httpRequest = [[HTTPRequest alloc] init];
    
    if([Utils isNullString:version]){
        version = @"0.0.0";
    }
	
	if (self.mainViewController.view.superview == nil) {
		if (self.mainViewController == nil) {
			MainViewController *mainView = [[MainViewController alloc]
											initWithNibName:@"MainViewController"
											bundle:nil];
			self.mainViewController = mainView; 
			//CGRect newFrame = self.window.frame;
			//self.mainViewController.view.frame = CGRectMake(0, 20, 320, 460);
			[mainView release];
		}
	}
    
    if (self.loginViewController == nil) {
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		self.loginViewController = login;
		[login release];
        
		//self.loginViewController.view.frame = CGRectMake(0, 20, 320, 460);
        //CGRect rect = [[UIScreen mainScreen] bounds];
        
        //self.loginViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
	}
    
    
    
	[self.window addSubview:self.loginViewController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"interview" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"interview.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }    
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //if(self.shouldRotate ) //shouldRotate is my flag
    //{
    //    self.shouldRotate = NO;
        return (UIInterfaceOrientationMaskAll);
    //}
    //return (UIInterfaceOrientationMaskPortrait);
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)switchMainView {
    NSLog(@"switchMainView");
	if (self.mainViewController == nil) {
		MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        
		self.mainViewController = main;
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.mainViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        
        
		[main release];
        
	}
    
    [self.window addSubview:self.mainViewController.view];
    //[self.window bringSubviewToFront:self.mainViewController.view];
	
}

- (void)switchLoginView {
    
	if (self.loginViewController == nil) {
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		self.loginViewController = login;
		[login release];
        
		//self.loginViewController.view.frame = CGRectMake(0, 20, 320, 460);
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        self.loginViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
	}
	[self.window addSubview:self.loginViewController.view];
}

-(BOOL) isNetworkReachable
{
	struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkFlagsReachable){
        return YES;
    }else {
        return NO;
    }
}

-(BOOL)isCellNetwork{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)deviceUuid {
    UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid;
	if ([dev respondsToSelector:@selector(uniqueIdentifier)])
		deviceUuid = dev.uniqueIdentifier;
	else {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		id uuid = [defaults objectForKey:@"deviceUuid"];
		if (uuid)
			deviceUuid = (NSString *)uuid;
		else {
			CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
			deviceUuid = (NSString *)cfUuid;
			CFRelease(cfUuid);
			[defaults setObject:deviceUuid forKey:@"deviceUuid"];
		}
	}
    
    return deviceUuid;
}
@end
