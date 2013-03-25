//
//  MainViewController.h
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"

@interface MainViewController : UIViewController <UITabBarControllerDelegate>



- (void)switchTabView:(NSInteger)tabIndex;
- (void)switchMoviePlayer:(NSString*)url;

@end
