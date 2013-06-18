//
//  InterviewQuestion.h
//  interview
//
//  Created by 김규완 on 13. 3. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interview;

@interface InterviewQuestion : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * qno;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSNumber * elapsedTime;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) Interview *interview;

@end
