//
//  Scrap.h
//  interview
//
//  Created by 김규완 on 13. 3. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScrapQuestion;

@interface Scrap : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber *scrapNo;
@property (nonatomic, retain) NSSet *scrapQuestion;
@end

@interface Scrap (CoreDataGeneratedAccessors)

- (void)addScrapQuestionObject:(ScrapQuestion *)value;
- (void)removeScrapQuestionObject:(ScrapQuestion *)value;
- (void)addScrapQuestion:(NSSet *)values;
- (void)removeScrapQuestion:(NSSet *)values;

@end
