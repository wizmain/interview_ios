//
//  WebViewController.h
//  interview
//
//  Created by 김규완 on 13. 4. 3..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *title;

@end
