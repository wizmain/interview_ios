//
//  ActivityIndicator.h
//  mClass
//
//  Created by 김규완 on 10. 12. 7..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface ProgressIndicator : UIAlertView {
	UIActivityIndicatorView *activityIndicator;
	UILabel *progressMessage;
	UIImageView *backgroundImageView;
	AppDelegate *appDelegate;
	
}

@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *progressMessage;
@property (nonatomic, assign) UIImageView *backgroundImageView;
@property (nonatomic, assign) AppDelegate *appDelegate;


- (id)initWithLabel:(NSString *)text;
- (void)dismiss;

@end
