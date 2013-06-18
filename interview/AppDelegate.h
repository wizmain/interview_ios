//
//  AppDelegate.h
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@class LoginViewController;
@class HTTPRequest;
@class AVCamViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (nonatomic, retain, readonly) HTTPRequest *httpRequest;
@property (nonatomic, retain, readonly) NSString *version;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, retain) NSString *authUserID;
@property (nonatomic, assign) int authUserNo;
@property (nonatomic, assign) int authGroup;
@property (nonatomic, getter = isAlertRunning) BOOL alertRunning;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (AppDelegate *)sharedAppDelegate;
- (void)switchMainView;
- (void)switchLoginView;
- (BOOL)isCellNetwork;
- (BOOL)isNetworkReachable;
- (NSString *)deviceUuid;
@end
