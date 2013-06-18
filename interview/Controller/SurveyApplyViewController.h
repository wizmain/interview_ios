//
//  SurveyApplyViewController.h
//  interview
//
//  Created by 김규완 on 13. 4. 26..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyApplyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSDictionary *surveyInfo;

@end
