//
//  HttpManager.h
//  interview
//
//  Created by 김규완 on 13. 4. 2..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPClient;


@protocol HttpManagerDelegate <NSObject>

@required

@optional
- (void)bindInterviewData:(NSMutableArray*)interviewData;
- (void)loginResult:(NSDictionary *)result;
- (void)bindCategoryData:(NSMutableArray*)categoryData;
- (void)bindQuestionData:(NSMutableArray*)questionData;
- (void)bindInterviewQuestion:(NSMutableArray*)questionData;
- (void)bindEvaluateResult:(NSDictionary*)resultData;
- (void)bindSurveyData:(NSMutableArray*)resultData;
- (void)bindSurveyQuestion:(NSMutableArray*)questionData;
- (void)surveyQuestionSetAnswerResult:(NSString*)result;
@end

@interface HttpManager : NSObject {
    id<HttpManagerDelegate> delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain, readonly) AFHTTPClient *httpClient;

+ (HttpManager *)sharedManager;

- (void)requestCategoryByUp:(NSString*)categoryID;
- (void)requestInterviewData:(int)type page:(int)page;
- (void)login:(NSString*)userid password:(NSString*)password;
- (void)requestQuestionData:(NSString *)urlString;
- (void)requestStandardQuestion;
- (void)requestInterviewQuestion:(int)uid;
- (void)requestEvaluateResult:(int)uid;
- (void)requestSurveyList;
- (void)requestSurveyQuestion:(int)uid;
- (void)surveyQuestionSetAnswer:(int)suid questionUid:(int)quid answer:(NSString*)answer;

@end
