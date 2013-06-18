//
//  EvaluateViewController.h
//  interview
//
//  Created by 김규완 on 13. 4. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluatePopoverController.h"
#import "ScrapPopoverViewController.h"
@class  Interview;

@interface EvaluateViewController : UIViewController <PopoverClose, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Interview *interview;
@property (nonatomic, assign) int interviewUid;

@end
