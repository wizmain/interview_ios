//
//  InterviewListController.h
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterviewListController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *categoryName;

@end
