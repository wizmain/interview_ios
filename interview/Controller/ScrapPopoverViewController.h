//
//  ScrapPopoverViewController.h
//  interview
//
//  Created by 김규완 on 13. 3. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InterviewQuestionViewController;

@protocol PopoverClose

- (void)dismissPopover:(int)selectedRow;

@end

@interface ScrapPopoverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, assign) int selectedScrapNo;

@end



