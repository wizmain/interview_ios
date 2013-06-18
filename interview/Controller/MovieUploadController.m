//
//  MovieUploadController.m
//  interview
//
//  Created by 김규완 on 13. 4. 1..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MovieUploadController.h"
#import "Interview.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"
#import "Constant.h"
#import "NSNumber+NSNumber_Helpers.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AlertUtils.h"
#import "JSON.h"
#import <Foundation/Foundation.h>
#import "SettingProperties.h"
#import "HttpManager.h"
#import "InterviewQuestion.h"

@interface MovieUploadController ()

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel1;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel2;
@property (nonatomic, retain) IBOutlet UIImageView *thumbImage;
@property (nonatomic, retain) IBOutlet UIButton *uploadStartButton;
@property (nonatomic, retain) IBOutlet UIButton *checkButton;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIAlertView *progressAlert;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UITextView *infoText;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, retain) NSString *movieWidth;
@property (nonatomic, retain) NSString *movieHeight;
@property (nonatomic, retain) NSString *movieSize;
@property (nonatomic, retain) NSString *movieDuration;
@property (nonatomic, retain) NSString *sendFileName;
@property (nonatomic, retain) AFHTTPRequestOperation *httpOperation;
@property (nonatomic, retain) AFJSONRequestOperation *jsonOperation;
@property (nonatomic, retain) AFHTTPClient *httpClient;
@property (nonatomic, retain) SettingProperties *interviewSetting;

@end

@implementation MovieUploadController

@synthesize titleLabel, infoLabel1, infoLabel2, thumbImage, uploadStartButton, checkButton;
@synthesize interview, progressAlert, progressView, infoText;
@synthesize movieWidth, movieHeight, movieSize, movieDuration, sendFileName;
@synthesize httpOperation, httpClient, jsonOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"면접질문";
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];

    [self.uploadStartButton setBackgroundImage:[[UIImage imageNamed:@"big_btn_bg_blue@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)] forState:UIControlStateNormal];
    
    _isChecked = NO;
    
    if (IS_iPhone_5) {
        
    } else {
        CGRect buttonFrame = self.uploadStartButton.frame;
        CGRect infoFrame = self.infoText.frame;
        
        buttonFrame.origin.y = 200;
        infoFrame.origin.y = 250;
        self.uploadStartButton.frame = buttonFrame;
        self.infoText.frame = infoFrame;
    }
    
    self.interviewSetting = [Utils settingProperties];
    self.httpClient = [[HttpManager sharedManager] httpClient];
    
    if(self.interview) {
        [self bindInterviewInfo];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.uploadStartButton = nil;
    self.titleLabel = nil;
    self.infoLabel1 = nil;
    self.infoLabel2 = nil;
    self.thumbImage = nil;
    self.checkButton = nil;
    self.progressView = nil;
    self.progressAlert = nil;
    self.movieSize = nil;
    self.movieWidth = nil;
    self.movieHeight = nil;
    self.movieDuration = nil;
    self.httpClient = nil;
    self.httpOperation = nil;
    self.jsonOperation = nil;
    self.interviewSetting = nil;
}

- (void)dealloc {
    
    [uploadStartButton release];
    [titleLabel release];
    [infoLabel1 release];
    [infoLabel2 release];
    [thumbImage release];
    [checkButton release];
    [progressAlert release];
    [progressView release];
    [httpClient release];
    [httpOperation release];
    [jsonOperation release];
    [super dealloc];
}



#pragma mark -
#pragma mark Custom Method
- (void)bindInterviewInfo {
    
    self.titleLabel.text = self.interview.name;
    self.infoLabel1.text = self.interview.applyField;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileUrl = [NSURL URLWithString:interview.fileUrl];
    
    //썸네일 이미지 미리 저장된 이미지로
    NSString *thumbPath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, interview.filename];
    NSLog(@"thumbPath=%@", thumbPath);
    [self.thumbImage setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    
    //동영상파일 시간알아내기
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileUrl];
    
    CMTime d = playerItem.duration;
    float seconds = CMTimeGetSeconds(d);
    NSLog(@"duration: %.2f", seconds);
    
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", interview.filename];
    NSNumber *fileSize = [Utils fileSize:destinationPath];
    
    NSString *fileInfoString = [NSString stringWithFormat:@"%@ (%@)", [Utils convertTimeFromSeconds:seconds], [NSNumber displayFileFormat:fileSize]];
    self.infoLabel2.text = fileInfoString;
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    CGSize mediaSize = track.naturalSize;
    int width = (int)mediaSize.width;
    int height = (int)mediaSize.height;
    int duration = (int)seconds;
    
    self.movieSize = [NSString stringWithFormat:@"%d", [fileSize integerValue]];
    self.movieWidth = [NSString stringWithFormat:@"%d", width];
    self.movieHeight = [NSString stringWithFormat:@"%d", height];
    self.movieDuration = [NSString stringWithFormat:@"%d", duration];
    
}

- (IBAction)uploadStart:(id)sender {
    [self createProgressionAlertWithMessage:@"파일 업로드"];
    [progressAlert setMessage:@"파일정보 등록중.."];
        
    unsigned units = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDate *today = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:units fromDate:today];
    NSString *uploadFolder = [NSString stringWithFormat:@"%d/%02d/%02d", [comp year], [comp month], [comp day]];
    int milisecond = [NSDate timeIntervalSinceReferenceDate] * 1000;
    self.sendFileName = [NSString stringWithFormat:@"%@%d_%@.%@", [[self.interview.filename lastPathComponent] stringByDeletingPathExtension], milisecond, @"develope", [self.interview.filename pathExtension]];
    
    //NSURL *url = [NSURL URLWithString:kUploadServerUrl];
    //httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:uploadFolder, @"folder", self.interview.filename, @"filename",
                           [self.interview.filename pathExtension], @"ext",
                           @"develope", @"id",
                           self.movieSize, @"size",
                           self.movieWidth, @"width",
                           self.movieHeight, @"height",
                           self.movieDuration, @"duration",
                           self.sendFileName, @"tmpname", nil];
    
    [httpClient postPath:kMovieFileInfoInsertUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = (NSString*)responseObject;
        NSLog(@"file info insert success result=%@", result);
        NSError *error = nil;
        NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"fileUid=%@", [jsonFromData valueForKey:@"uid"]);
        [self fileUplaod:[jsonFromData valueForKey:@"uid"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"file info insert fail");
        AlertWithMessage(@"전송에 실패했습니다");
    }];
    
    
    
    NSLog(@"uploadFolder = %@ filename=%@ fileext=%@", uploadFolder, self.interview.filename, [self.interview.filename pathExtension]);
    NSLog(@"size = %@ width=%@ height=%@ duration=%@", self.movieSize, self.movieWidth, self.movieHeight, self.movieDuration);
    NSLog(@"tmpName=%@", [NSString stringWithFormat:@"%@%d_%@.%@", [[self.interview.filename lastPathComponent] stringByDeletingPathExtension], milisecond, @"develope", [self.interview.filename pathExtension]]);
    
    
}

- (void)fileUplaod:(NSString*)fileUid {
    NSLog(@"fileUpload");
    [httpClient release];
    [httpOperation release];
    
    //이제 파일업로드
    [progressAlert setMessage:@"파일 업로드 준비중.."];
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", kUploadServerUrl, kMovieFileInfoInsertUrl];
    NSURL *url = [NSURL URLWithString:kUploadServerUrl];
    
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.movieWidth, @"width", self.movieHeight, @"height", nil];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", interview.filename];
    NSData *movieFile = [[NSFileManager defaultManager] contentsAtPath:destinationPath];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:kFileUploadUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:movieFile name:@"file" fileName:self.sendFileName mimeType:@"video/quicktime"];
    }];
    
    httpOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        [progressAlert setMessage:[NSString stringWithFormat:@"파일업로드 %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite]];
        float progress = totalBytesWritten/totalBytesExpectedToWrite;
        
        [self.progressView setProgress:progress animated:YES];
        if (totalBytesWritten >= totalBytesExpectedToWrite) {
            
            [progressAlert setMessage:@"인터뷰정보 등록중.."];
            [self regInterviewInfo:fileUid];
        }
     
    }];
    
    [httpOperation start];
    
}

- (void)regInterviewInfo:(NSString*)fileUid {

    NSArray *qList = [self.interview.interviewQuestion allObjects];
    NSLog(@"qList count=%d", qList.count);
    //SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSMutableArray *jsonArray = [[NSMutableArray alloc] initWithCapacity:qList.count];
    for (int i=0; i<qList.count; i++) {
        InterviewQuestion *q = [qList objectAtIndex:i];
        NSLog(@"interviewquestion title=%@ filename=%@ qno=%d, categoryid=%@", q.title, q.filename, [q.qno integerValue], q.categoryID);
        NSDictionary *jq = [[NSDictionary alloc] initWithObjectsAndKeys:q.categoryID, @"categoryID",
                            q.filename, @"fileName",
                            [NSString stringWithFormat:@"%d",[q.qno integerValue]], @"questionNo",
                            q.title, @"title", nil];
        
        [jsonArray insertObject:jq atIndex:i];
    }
    
    NSString *jsonString = [jsonArray JSONRepresentation];
    NSLog(@"qList JsonString=%@", jsonString);
    [jsonArray release];
    
    NSString *title = [NSString stringWithFormat:@"%@님이 올린 영상", @"develope"];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"subject",
                           [[AppDelegate sharedAppDelegate] authUserID], @"id",
                           [Utils cookieValue:@"username"], @"name",
                           [NSString stringWithFormat:@"[%@]", fileUid], @"upload",
                           @"", @"content",
                           [NSString stringWithFormat:@"%d",[[AppDelegate sharedAppDelegate] authUserNo]], @"mbrUid",
                           self.interviewSetting.applyField, @"applyField",
                           self.interviewSetting.schoolName, @"school",
                           self.interviewSetting.majorName, @"major",
                           self.interviewSetting.userAge, @"age",
                           self.interviewSetting.userSex, @"sex",
                           self.interview.interviewCategory, @"interviewCategory",
                           jsonString, @"qlist", nil];
    
    //NSURL *url = [NSURL URLWithString:kUploadServerUrl];
    //httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    [httpClient postPath:kMovieInsertUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSString *result = (NSString*)responseObject;
        //NSLog(@"interview insert success result=%@", result);
        //NSError *error = nil;
        //NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        [progressAlert dismissWithClickedButtonIndex:1 animated:YES];
        AlertWithMessage(@"등록이 완료 되었습니다");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"file info insert fail");
        [progressAlert dismissWithClickedButtonIndex:1 animated:YES];
        AlertWithMessage(@"전송에 실패했습니다");
    }];

}


- (void)createProgressionAlertWithMessage:(NSString *)message
{
    progressAlert = [[UIAlertView alloc] initWithTitle:message message:@"\"파일정보 등록중..\"\n\n" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:nil];

    //progressAlert = [[UIAlertView alloc] initWithFrame:CGRectMake(30, 200, 240, 200)];
    // Create the progress bar and add it to the alert
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [progressAlert addSubview:progressView];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];

    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = @"\"0%\"";
    label.tag = 1;
    
    [progressAlert addSubview:label];
    */
    
    [progressAlert show];
    [progressAlert release];
    

}

- (IBAction)toggleCheckUpload:(id)sender {
    if (_isChecked) {

        [self.checkButton setImage:[UIImage imageNamed:@"checked2"] forState:UIControlStateNormal];
        _isChecked = NO;
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"checked2_on"] forState:UIControlStateNormal];
        _isChecked = YES;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click buttonIndex=%d", buttonIndex);
	//printf(\"User Pressed Button %d\n\", buttonIndex + 1);
	//printf(\"Text Field 1: %s\n\", [[[alertView textFieldAtIndex:0] text] cStringUsingEncoding:1]);
    //[progressAlert dismissWithClickedButtonIndex:0 animated:YES];
	if (buttonIndex == 0)
	{
        if(httpClient){
            [httpClient cancelAllHTTPOperationsWithMethod:@"POST" path:kMovieFileInfoInsertUrl];
            //[httpClient release];
        }
        
        if(httpOperation){
            [httpOperation cancel];
            //[httpOperation release];
        }
    }
    //[alertView release];
}
@end
