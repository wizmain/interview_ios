//
//  Interview.h
//  interview
//
//  Created by 김규완 on 13. 3. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Interview : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * applyField;
@property (nonatomic, retain) NSDate * regdate;
@property (nonatomic, retain) NSString * interviewType;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSString * interviewCategory;
@property (nonatomic, retain) NSSet *interviewQuestion;
@end

@interface Interview (CoreDataGeneratedAccessors)

- (void)addInterviewQuestionObject:(NSManagedObject *)value;
- (void)removeInterviewQuestionObject:(NSManagedObject *)value;
- (void)addInterviewQuestion:(NSSet *)values;
- (void)removeInterviewQuestion:(NSSet *)values;

@end
