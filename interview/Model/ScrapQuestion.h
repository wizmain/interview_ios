//
//  ScrapQuestion.h
//  interview
//
//  Created by 김규완 on 13. 3. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScrapQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * qno;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * elapsedTime;
@property (nonatomic, retain) NSManagedObject *scrap;

@end
