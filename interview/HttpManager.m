//
//  HttpManager.m
//  interview
//
//  Created by 김규완 on 13. 4. 2..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HttpManager.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface HttpManager ()

@end

@implementation HttpManager

@synthesize httpClient;
@synthesize delegate;

- (id)init {
    self = [super init];
    
    if(self != nil) {
        NSURL *url = [NSURL URLWithString:kServerUrl];
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (void)dealloc {
    [httpClient release];
    [super dealloc];
}

+ (HttpManager *)sharedManager {
    static HttpManager *manager;
    
    if (manager == nil) {
        @synchronized (self) {
            manager = [[HttpManager alloc] init];
            assert(manager != nil);
        }
    }
    
    return manager;
}

/***********
 질문카테고리 데이타 조회
************/
- (void)requestCategoryByUp:(NSString *)categoryID {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?up_category_id=%@", kServerUrl, kInterviewCategoryUrl, categoryID];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"CATEGORY_ID"], @"CATEGORY_ID",
                                 [entry valueForKeyPath:@"CATEGORY_NAME"], @"CATEGORY_NAME",
                                 [entry valueForKeyPath:@"UP_CATEGORY_ID"], @"UP_CATEGORY_ID", nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindCategoryData:)]) {
            [delegate bindCategoryData:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindCategoryData:)]) {
            [delegate bindCategoryData:resultList];
        }
    }];
    
    [operation start];
    
}

- (void)requestStandardQuestion {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@", kQuestionStandardUrl];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"Q_TITLE"], @"Q_TITLE",
                                 [entry valueForKeyPath:@"Q_NO"], @"Q_NO",
                                 [entry valueForKeyPath:@"Q_FILENAME"], @"Q_FILENAME",
                                 [entry valueForKeyPath:@"CATEGORY_ID"], @"CATEGORY_ID",
                                 [entry valueForKeyPath:@"ELAPSED_TIME"], @"ELAPSED_TIME", nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindQuestionData:)]) {
            [delegate bindQuestionData:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindQuestionData:)]) {
            [delegate bindQuestionData:resultList];
        }
    }];
    
    [operation start];
}

- (void)requestQuestionData:(NSString *)urlString {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@", kQuestionStandardUrl];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"Q_TITLE"], @"Q_TITLE",
                                 [entry valueForKeyPath:@"Q_NO"], @"Q_NO",
                                 [entry valueForKeyPath:@"Q_FILENAME"], @"Q_FILENAME",
                                 [entry valueForKeyPath:@"CATEGORY_ID"], @"CATEGORY_ID",
                                 [entry valueForKeyPath:@"ELAPSED_TIME"], @"ELAPSED_TIME", nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindQuestionData:)]) {
            [delegate bindQuestionData:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindQuestionData:)]) {
            [delegate bindQuestionData:resultList];
        }
    }];
    
    [operation start];
}

//인터뷰응시한 질문목록
- (void)requestInterviewQuestion:(int)uid {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?uid=%d", kApplyQuestionUrl, uid];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"Q_TITLE"], @"Q_TITLE",
                                 [entry valueForKeyPath:@"Q_NO"], @"Q_NO",
                                 [entry valueForKeyPath:@"Q_FILENAME"], @"Q_FILENAME",
                                 [entry valueForKeyPath:@"CATEGORY_ID"], @"CATEGORY_ID",
                                 nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindInterviewQuestion:)]) {
            [delegate bindInterviewQuestion:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindInterviewQuestion:)]) {
            [delegate bindInterviewQuestion:resultList];
        }
    }];
    
    [operation start];
}

/************************
 * 서버에 올린 인터뷰 데이타 조회
 ************************/
- (void)requestInterviewData:(int)type page:(int)page {
    NSLog(@"HttpManager requestInterviewData");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = nil;
    
    if (type == 1) {//나의영상함
        path = kMyInterviewList;
    } else if(type == 2) {//평가신청함
        path = kEvaluateInterviewList;
    } else if(type == 3) {//베스트영상
        path = kBestInterviewList;
    } else if(type == 4) {//이용자추천
        path = kRecommentInterviewList;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@&p=%d", kServerUrl, path, page];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSURLRequest *request = [NSURLRequest req]
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    /*
     item.setContentsID(o.getInt("uid"));
     item.setTitle(o.getString("subject"));
     String dateString = o.getString("d_regis");
     Date d = DateTimeUtil.getDateFromString(dateString, "yyyyMMddHHmmss");
     item.setCreateTime(d.getTime());
     item.setUserID(o.getString("id"));
     item.setUserKName(o.getString("name"));
     item.setApplyField(o.getString("applyField"));
     item.setSchool(o.getString("school"));
     item.setMajor(o.getString("major"));
     item.setAge(o.getString("age"));
     item.setSex(o.getString("sex"));
     item.setDuration(o.getInt("duration"));
     if(!o.isNull("height")){
     item.setVideoWidth(o.getInt("width"));
     item.setFileSize(o.getInt("size"));
     item.setHierarchy(o.getString("folder"));
     item.setFileName(o.getString("tmpname"));
     item.setThumbNail(o.getString("thumbname"));
     item.setInterviewCategory(o.getString("interview_category"));
     item.setEvaluateState(o.getString("evaluate_state"));
     item.setInqueryState(o.getString("inquery_state"));
     item.setGoodsType(o.getString("goods_type"));
     */
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            //NSLog(@"entry = %@", entry);
            /*
             NSMutableArray *curRow = [[NSMutableArray alloc]init];
             [curRow addObject:[entry valueForKeyPath:@"question"]];
             [curRow addObject:[entry valueForKeyPath:@"answers"]];
             [curRow addObject:[entry valueForKeyPath:@"correct_answer"]];
             [gameQuestions addObject:curRow];
             [curRow release];
             curRow = nil;
             */
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"uid"], @"uid",
                                 [entry valueForKeyPath:@"subject"], @"subject",
                                 [entry valueForKeyPath:@"d_regis"], @"d_regis",
                                 [entry valueForKeyPath:@"id"], @"id",
                                 [entry valueForKeyPath:@"name"], @"name",
                                 [entry valueForKeyPath:@"applyField"], @"applyField",
                                 [entry valueForKeyPath:@"school"], @"school",
                                 [entry valueForKeyPath:@"major"], @"major",
                                 [entry valueForKeyPath:@"age"], @"age",
                                 [entry valueForKeyPath:@"sex"], @"sex",
                                 [entry valueForKeyPath:@"duration"], @"duration",
                                 [entry valueForKeyPath:@"height"], @"height",
                                 [entry valueForKeyPath:@"width"], @"width",
                                 [entry valueForKeyPath:@"size"], @"size",
                                 [entry valueForKeyPath:@"folder"], @"folder",
                                 [entry valueForKeyPath:@"tmpname"], @"tmpname",
                                 [entry valueForKeyPath:@"thumbname"], @"thumbname",
                                 [entry valueForKeyPath:@"interview_category"], @"interview_category",
                                 [entry valueForKeyPath:@"evaluate_state"], @"evaluate_state",
                                 [entry valueForKeyPath:@"inquery_state"], @"inquery_state",
                                 [entry valueForKeyPath:@"goods_type"], @"goods_type", nil];
            
            [resultList addObject:dic];
            
        }
                                         
        if ([delegate respondsToSelector:@selector(bindInterviewData:)]) {
            [delegate bindInterviewData:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindInterviewData:)]) {
            [delegate bindInterviewData:resultList];
        }
    }];
    
    [operation start];
    
}

- (void)login:(NSString*)userid password:(NSString*)password {
    
    NSLog(@"HttpManager login");
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceUuid = [[AppDelegate sharedAppDelegate] deviceUuid];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kLoginUrl];
    //NSLog(@"urlString=%@", urlString);
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSDictionary *result = [[NSDictionary alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid", password,@"passwd", @"iOS", @"mobile_os", systemVersion, @"mobile_version", deviceUuid, @"device_id", @"", @"device_token", nil];
    
    //[httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kLoginUrl parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"userSession=%@",[JSON valueForKeyPath:@"userSession"]);
        
        
        if ([delegate respondsToSelector:@selector(loginResult:)]) {
            [delegate loginResult:[JSON valueForKeyPath:@"userSession"]];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"login fail");
        NSLog(@"userSession=%@",[JSON valueForKeyPath:@"userSession"]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(loginResult:)]) {
            [delegate loginResult:[JSON valueForKeyPath:@"userSession"]];
        }
    }];
    
    [operation start];
}


- (void)requestEvaluateResult:(int)uid {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?interviewUid=%d", kEvaluateResultUrl, uid];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *evaluate = [JSON valueForKeyPath:@"evaluate"];
        NSLog(@"evaluate=%@", evaluate);
        
        if ([delegate respondsToSelector:@selector(bindEvaluateResult:)]) {
            [delegate bindEvaluateResult:evaluate];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindEvaluateResult:)]) {
            [delegate bindEvaluateResult:nil];
        }
    }];
    
    [operation start];
}


- (void)requestSurveyList {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kSurveyListUrl];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"uid"], @"uid",
                                 [entry valueForKeyPath:@"subject"], @"subject",
                                 [entry valueForKeyPath:@"s_date"], @"s_date",
                                 [entry valueForKeyPath:@"e_date"], @"e_date", nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindSurveyData:)]) {
            [delegate bindSurveyData:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindSurveyData:)]) {
            [delegate bindSurveyData:resultList];
        }
    }];
    
    [operation start];
    
}


- (void)requestSurveyQuestion:(int)uid {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?uid=%d", kServerUrl, kSurveyQuestionUrl, uid];
    NSLog(@"urlString=%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"requestSurveyQuestion Success %@", JSON);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"uid"], @"uid",
                                 [entry valueForKeyPath:@"subject"], @"subject",
                                 [entry valueForKeyPath:@"type"], @"type",
                                 [entry valueForKeyPath:@"example"], @"example", nil];
            //NSLog(@"subject = %@", [entry valueForKeyPath:@"subject"]);
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(bindSurveyQuestion:)]) {
            [delegate bindSurveyQuestion:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(bindSurveyQuestion:)]) {
            [delegate bindSurveyQuestion:resultList];
        }
    }];
    
    [operation start];
    
}

- (void)surveyQuestionSetAnswer:(int)suid questionUid:(int)quid answer:(NSString*)answer {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *surveyUid = [NSString stringWithFormat:@"%d", suid];
    NSString *questionUid = [NSString stringWithFormat:@"%d", quid];

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:surveyUid,@"suid", questionUid,@"quid", answer, @"answer", nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kSurveySetAnswerUrl parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"requestSurveyQuestion Success %@", JSON);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"uid=%@ message=%@",[JSON valueForKeyPath:@"uid"], [JSON valueForKeyPath:@"message"]);
        
        
        if ([delegate respondsToSelector:@selector(surveyQuestionSetAnswerResult:)]) {
            [delegate surveyQuestionSetAnswerResult:[JSON valueForKeyPath:@"uid"]];
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(surveyQuestionSetAnswerResult:)]) {
            [delegate surveyQuestionSetAnswerResult:@"-1"];
        }
    }];
    
    [operation start];
}

@end
