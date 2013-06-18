//
//  SettingProperties.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUserNameKey	@"userName"
#define kSchoolNameKey	@"schoolName"
#define kMajorNameKey	@"majorName"
#define kHakBunKey      @"hakbun"
#define kApplyField     @"applyfield"
#define kUserSex        @"usersex"
#define kUserAge        @"userage"
#define kAnswerTerm     @"answerTerm"
#define kBirthDay       @"birthDay"


@interface SettingProperties : NSObject<NSCoding, NSCopying> {

}

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *schoolName;
@property (nonatomic, retain) NSString *majorName;
@property (nonatomic, retain) NSString *hakbun;
@property (nonatomic, retain) NSString *applyField;
@property (nonatomic, retain) NSString *userSex;
@property (nonatomic, retain) NSString *userAge;
@property (nonatomic, retain) NSString *answerTerm;
@property (nonatomic, retain) NSString *birthDay;

@end
