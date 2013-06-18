//
//  EvaluatePopoverController.h
//  interview
//
//  Created by 김규완 on 13. 4. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluatePopoverController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) int selectedRow;
@property (nonatomic, retain) UIViewController *parent;
@end
