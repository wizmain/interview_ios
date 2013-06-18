//
//  InterviewQuestionViewController.h
//  interview
//
//  Created by 김규완 on 13. 3. 20..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapPopoverViewController.h"
@class Interview;

@interface InterviewQuestionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, PopoverClose>

@property (nonatomic, retain) Interview *interview;
@property (nonatomic, retain) NSDictionary *serverInterviewData;
@property (nonatomic, assign) BOOL isLocal;//로컬인터뷰 질문데이타인지 서버에 올린 데이타인지

- (void)dismissPopover:(int)selectedRow;

@end
