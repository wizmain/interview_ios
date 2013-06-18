//
//  InterviewRecordViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 28..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewRecordViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreMedia/CMTime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVVideoComposition.h>
#import "AudioStreamer.h"
#import "Utils.h"
#import "SettingProperties.h"
#import "Constant.h"
#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "Interview.h"
#import "InterviewQuestion.h"
#import "HttpManager.h"

#define kRequestQuestionCnt     6

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface InterviewRecordViewController () <HttpManagerDelegate>

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) int defaultAnswerTime;//기본 답변 시간
@property (nonatomic, assign) int elapsedTime;//질문 소요된 시간
@property (nonatomic, assign) int currentQuestion;
@property (nonatomic, assign) int totalQuestion;//총 질문 갯수
@property (nonatomic, retain) SettingProperties *settings;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL isClose;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@interface InterviewRecordViewController () <UIGestureRecognizerDelegate>
@end

@interface InterviewRecordViewController (InternalMethods)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)updateButtonStates;
@end

@interface InterviewRecordViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>

@end

@implementation InterviewRecordViewController

@synthesize managedObjectContext, categoryID;
@synthesize captureManager, recordButton, closeButton;
@synthesize videoPreviewView, captureVideoPreviewLayer;
@synthesize player, audioStreamer, timer, elapsedTime, questionText;
@synthesize defaultAnswerTime, totalQuestion, settings;
@synthesize answerTimeBarButton, answerTimeInfoBarButton, questionTitleBarButton, questionInfoBarButton, categoryTitleButton, nextButton;
@synthesize isClose;

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
    if(IS_iOS_6){
        //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    } else {
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:NO];
    }
    
    isClose = NO;
    
    [self.spinner startAnimating];
    //인터뷰 설정
    self.settings = [Utils settingProperties];
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
    //총질문갯수
    totalQuestion = 0;
    //하단 버튼 셋팅
    [self initToolbarButtons];
    //녹화화면준비
    [self setupAVCam];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    /* 면접관동영상
    NSString *path = [[NSBundle mainBundle] pathForResource:@"[video]interviewer1" ofType:@"mp4"];
    NSLog(@"path = %@", path);
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //playerView.view.frame = CGRectMake(0, 0, 320, 208);
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.useApplicationAudioSession = YES;
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
    [player setControlStyle:MPMovieControlStyleNone];
    [[player view] setFrame:CGRectMake(0, 0, 320, 208)];
    //[player setScalingMode:MPMovieScalingModeAspectFill];
    //[player setShouldAutoplay:NO];
    [player setRepeatMode:MPMovieRepeatModeOne];
    
	//player = [playerView moviePlayer];
    [self.view addSubview:player.view];
    [player play];
    */
    
    
    //인터뷰 질문 오디오 스트리밍 셋팅
    //[self setupAudioStreamer];
    //표준 질문 가져오기
    //[self requestStandardQuestion];
    
    if (self.questionList) {
        totalQuestion = self.questionList.count;
        [self.spinner stopAnimating];
    } else {
        [self setInterviewQuestion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setVideoPreviewView:nil];
    [self setCaptureVideoPreviewLayer:nil];
    [self setRecordButton:nil];
    [self setPlayer:nil];
    [self setCaptureManager:nil];
    self.answerTimeBarButton = nil;
    self.answerTimeInfoBarButton = nil;
    self.questionList = nil;
    self.questionText = nil;
    self.questionInfoBarButton = nil;
    self.categoryTitleButton = nil;
    self.nextButton = nil;
    self.closeButton = nil;
    self.timer = nil;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode"];
	[captureManager release];
    [videoPreviewView release];
	[captureVideoPreviewLayer release];
    [recordButton release];
	[closeButton release];
    [player release];
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(self.timer)
        [self.timer invalidate];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Custom Method

- (void)initToolbarButtons {
    
    //인터뷰 기본 답변 시간
    
    if(self.settings != nil){
        defaultAnswerTime = [[NSString stringWithFormat:@"%@",[settings answerTerm]] intValue];
    } else {
        defaultAnswerTime = 25;
    }
    
    [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
    
    self.answerTimeBarButton.title = @"답변시간";
    self.answerTimeInfoBarButton.title = [NSString stringWithFormat:@"%d초", self.defaultAnswerTime];
    self.questionTitleBarButton.title = @"질문";
    self.questionInfoBarButton.title = @"0/9";
    
    
    [self.answerTimeBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
    [self.answerTimeInfoBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor redColor], UITextAttributeTextColor, [UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
    [self.questionTitleBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
    [self.questionInfoBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor redColor], UITextAttributeTextColor, [UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
    //[self.categoryTitleButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor redColor], UITextAttributeTextColor, [UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
}

//레코더 셋업
- (void)setupAVCam {
    
    //오디오 세션 오디오 녹음도 가능하게
    /*
    AVAudioSession* audio = [[AVAudioSession alloc] init];
    [audio setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [audio setActive: YES error: nil];
    
    UInt32 allowMixing = true;
    //AudioSessionSetProperty( kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(allowMixing), &allowMixing);
    AudioSessionSetProperty( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof( allowMixing ), &allowMixing );
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                    audioRouteChangeListenerCallback,
                                    self);
    */
    if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		[manager release];
		
		[[self captureManager] setDelegate:self];
        
        NSLog(@"captureManger %@", self.captureManager);
        if(self.captureManager == nil){
            NSLog(@"captureManger nil");
        }
        
		if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self videoPreviewView];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
            
			//if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
			//	[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
			//}
            [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
            //녹화버튼 상태 업데이트 이부분은 면접질문이 완료되면 셋팅되는걸로 이동
            //[self updateButtonStates];
			
            // Create the focus mode UI overlay
			//AVCaptureFocusMode initialFocusMode = [[[captureManager videoInput] device] focusMode];
			
			[self addObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
            
            
            
            // Add a single tap gesture to focus on the point tapped, then lock focus
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
			[singleTap setDelegate:self];
			[singleTap setNumberOfTapsRequired:1];
			[view addGestureRecognizer:singleTap];
			
            // Add a double tap gesture to reset the focus mode to continuous auto focus
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
			[doubleTap setDelegate:self];
			[doubleTap setNumberOfTapsRequired:2];
			[singleTap requireGestureRecognizerToFail:doubleTap];
			[view addGestureRecognizer:doubleTap];
			
			[doubleTap release];
			[singleTap release];
            
            /*
             AVURLAsset *interviewer = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"[video]interviewer1" ofType:@"mp4"]] options:nil];
             AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
             */
		}		
	}
}

//면접 질문 하기
- (void)playQuestion:(int) qNo {
    NSLog(@"playQuestion %d", qNo);
    _currentQuestion = qNo;
    
    if ([[[self captureManager] recorder] isRecording]) {
    
        if(qNo <= totalQuestion){
            //NSArray *a = [self.questionList objectAtIndex:i-1];
            //NSLog(@"a=%@",a);
            NSDictionary *q = [self.questionList objectAtIndex:qNo-1];
            
            //NSDictionary *q = [a objectAtIndex:0];
            NSLog(@"q=%@", q);
            
            //질문표시
            [self.questionText setText:[q valueForKey:@"Q_TITLE"]];
            
            NSLog(@"elapsedtime=%@", [NSString stringWithFormat:@"%@",[q objectForKey:@"ELAPSED_TIME"]]);
          
            if([Utils isNullString:[NSString stringWithFormat:@"%@",[q objectForKey:@"ELAPSED_TIME"]]]){
                [self.answerTimeInfoBarButton setTitle:[NSString stringWithFormat:@"%d초",self.defaultAnswerTime]];
                
            } else {
                if([Utils isNumbericString:[NSString stringWithFormat:@"%@",[q objectForKey:@"ELAPSED_TIME"]]]){
                    [self.answerTimeInfoBarButton setTitle:[NSString stringWithFormat:@"%@초",[q objectForKey:@"ELAPSED_TIME"]]];
                    elapsedTime = [[NSString stringWithFormat:@"%@",[q objectForKey:@"ELAPSED_TIME"]] intValue];
                } else {
                    elapsedTime = self.defaultAnswerTime;
                }
            
            }
            
            if(elapsedTime <= 0){
                elapsedTime = 25;
                [self.answerTimeInfoBarButton setTitle:[NSString stringWithFormat:@"%d초",elapsedTime]];
            }
            
            [self.questionInfoBarButton setTitle:[NSString stringWithFormat:@"%d/%d", qNo,[self.questionList count]]];
            
            NSString *audioUrl = [kAudioServer stringByAppendingFormat:@"%@/%@/%@", kAudioFolder, [q objectForKey:@"CATEGORY_ID"], [q objectForKey:@"Q_FILENAME"]];
            //@"http://www.smartinterview.co.kr/files/interview_audio/coelsoft/BA/BA001.mp3"
            AudioStreamer *s = [[[AudioStreamer alloc] initWithURL:[NSURL URLWithString:audioUrl]] autorelease];
            [s start];
            //[self.audioStreamer start];
            //[s release];
            //질문타이머 시작
            [self performSelector:@selector(timerStart) withObject:nil afterDelay:4];
            
        }
    }
}

- (void)timerStart {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)onTimer:(NSTimer *)timer {
    if(self.elapsedTime > 0){
        elapsedTime--;
        [self.answerTimeInfoBarButton setTitle:[NSString stringWithFormat:@"%d초",self.elapsedTime]];
    } else {
        if(self.currentQuestion >= totalQuestion) {
            [self.timer invalidate];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Interview"
                                                                message:@"다음 질문이 없습니다 녹화를 종료해 주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [self.timer invalidate];
        } else {
            [self goNextQuestion];
        }
    }
}

//다음질문 실행
- (void)goNextQuestion {
    [self.timer invalidate];
    if(self.currentQuestion >= totalQuestion) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Interview"
                                                            message:@"다음 질문이 없습니다 녹화를 종료해 주세요"
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [self.timer invalidate];
    } else {
        [self playQuestion:_currentQuestion+1];
    }
}

- (void)bindQuestionData:(NSMutableArray *)questionData {
    
    self.questionList = questionData;
    
    if(self.questionList){
        totalQuestion = [self.questionList count];
    } else {
        totalQuestion = 0;
    }
    
    //녹화버튼 상태 업데이트
    [self updateButtonStates];
    
    [self.spinner stopAnimating];
}

- (void)setInterviewQuestion {
    
    if(self.categoryID){
        self.categoryID = @"A";
    }

    if([self.categoryID isEqualToString:@"A"]){//표준
        [self.httpManager requestStandardQuestion];
    } else if([self.categoryID isEqualToString:@"AA"] || [self.categoryID isEqualToString:@"AB"] || [self.categoryID isEqualToString:@"AC"] || [self.categoryID isEqualToString:@"AD"] || [self.categoryID isEqualToString:@"AE"] || [self.categoryID isEqualToString:@"AF"] || [self.categoryID isEqualToString:@"AG"] || [self.categoryID isEqualToString:@"C"]){
        NSString *url = [kServerUrl stringByAppendingFormat:@"%@?up_category_id=%@&cnt=%d", kQuestionRandByUpUrl, self.categoryID, kRequestQuestionCnt];
        [self.httpManager requestQuestionData:url];
    } else {
        NSString *url = [kServerUrl stringByAppendingFormat:@"%@?up_category_id=%@&cnt=%d", kQuestionRandUrl, self.categoryID, kRequestQuestionCnt];
        [self.httpManager requestQuestionData:url];
    }
}

- (void)insertInterviewData:(NSString *)fileUrl {
    
    NSLog(@"insertInterviewData file=%@",fileUrl);
    //url 형식에서 파일명만
    NSArray *parts = [fileUrl componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    if(self.managedObjectContext != nil) {
        Interview *interview = [NSEntityDescription insertNewObjectForEntityForName:@"Interview" inManagedObjectContext:self.managedObjectContext];
        NSDate *d = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy년MM월dd일 HH:mm:ss"];
        interview.name = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:d]];
        interview.filename = filename;
        interview.fileUrl = fileUrl;
        interview.regdate = d;
        interview.interviewCategory = self.categoryID;
        if(self.settings){
            interview.sex = self.settings.userSex;
            interview.age = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",self.settings.userAge] integerValue]];
            interview.school = self.settings.schoolName;
            interview.major = self.settings.majorName;
            interview.applyField = self.settings.applyField;
        }
        
        
        NSMutableSet *qListSet = [[NSMutableSet alloc] init];
        
        for (int i=0; i<self.questionList.count; i++) {
            NSDictionary *d = [self.questionList objectAtIndex:i];
            
            //InterviewQuestion *q = [[InterviewQuestion alloc] init];
            InterviewQuestion *q = [NSEntityDescription insertNewObjectForEntityForName:@"InterviewQuestion" inManagedObjectContext:self.managedObjectContext];
            q.seq = [NSNumber numberWithInt:i+1];
            q.title = [d objectForKey:@"Q_TITLE"];
            q.qno = [NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",[d objectForKey:@"Q_NO"]] integerValue]];
            q.filename = [d objectForKey:@"Q_FILENAME"];
            q.categoryID = [d objectForKey:@"CATEGORY_ID"];
            q.elapsedTime = [NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",[d objectForKey:@"ELAPSED_TIME"]] integerValue]];
            
            [qListSet addObject:q];
        }
        
        NSLog(@"qListSet = %@",qListSet);
        //interview.interviewQuestion = qListSet;
        [interview addInterviewQuestion:qListSet];
        //NSLog(@"insert qList count=%d qListSet count=%d", self.questionList.count, qListSet.count);
        
        NSError *error = nil;
        if(![self.managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            
        } else {
            
        }
        
        [qListSet release];
        [d release];
        [dateFormat release];
        
        
        if(isClose) {//창을 닫기 위해 닫는 경우
            /* 원상복귀 */
            if(IS_iOS_6){
                //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            } else {
                //[[UIApplication sharedApplication] setStatusBarHidden:YES];
                [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
            }
            
            [self dismissModalViewControllerAnimated:NO];
        }
    } else {
        NSLog(@"managedObjectContext nil");
    }
}

- (void)makeThumbnail:(NSString*)movieFilePath {
    
    NSArray *parts = [movieFilePath componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileUrl = [NSURL URLWithString:movieFilePath];
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    [asset release];
    CMTime thumbTime = CMTimeMakeWithSeconds(0,1);
    
    //CGSize maxSize = CGSizeMake(320, 180);
    CGSize maxSize = CGSizeMake(80, 80);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        //[button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
        //UIImage *thumbImg = [[UIImage imageWithCGImage:im] retain];
        
        //image radius
        //[movieListCell.thumbnailImageView setImage:[[UIImage imageWithCGImage:im] imageScaledToSize:maxSize]];
        //[movieListCell.thumbnailImageView setImage:[UIImage imageWithCGImage:im]];
        NSString *thumbFileName = [filename stringByAppendingString:@".png"];
        NSData *thumbData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:im])];
        NSString *thumbFilePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, thumbFileName];
        [thumbData writeToFile:thumbFilePath atomically:YES];
        [generator release];
    };
    
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    //Thumbnail------------------------------------------------------------------------------------------------------------------------
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"Document directory: %@", [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]);

}





- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode
{
	NSString *focusString = @"";
	
	switch (focusMode) {
		case AVCaptureFocusModeLocked:
			focusString = @"locked";
			break;
		case AVCaptureFocusModeAutoFocus:
			focusString = @"auto";
			break;
		case AVCaptureFocusModeContinuousAutoFocus:
			focusString = @"continuous";
			break;
	}
	
	return focusString;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
		
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue ) {
    NSLog(@"audioRouteChangeListenerCallback");
    /*
    // ensure that this callback was invoked for a route change
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    
    {
        // Determines the reason for the route change, to ensure that it is not
        //      because of a category change.
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
        
        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        SInt32 routeChangeReason;
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
            //Handle Headset Unplugged
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            //Handle Headset plugged in
        }
        
    }
    */
    
}


#pragma mark Toolbar Actions
- (IBAction)toggleCamera:(id)sender
{
    // Toggle between cameras when there is more than one
    [[self captureManager] toggleCamera];
    
    // Do an initial focus
    [[self captureManager] continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

- (IBAction)toggleRecording:(id)sender
{
    
    // Start recording if there isn't a recording running. Stop recording if there is.
    [[self recordButton] setEnabled:NO];
    [[self nextButton] setEnabled:NO];
    if (![[[self captureManager] recorder] isRecording]) {
        BOOL isQuestionExist = YES;
        if(self.questionList != nil ) {
            if([self.questionList count] > 0){
                [[self captureManager] startRecording];
            } else {
                isQuestionExist = NO;
            }
        } else {
            isQuestionExist = NO;
        }
        
        if(!isQuestionExist){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Interview"
                                                                message:@"면접 질문이 설정되지 않았습니다"
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        
    } else {
        [self.spinner startAnimating];
        [self.timer invalidate];
        [[self captureManager] stopRecording];
    }
}

- (IBAction)close:(id)sender {
    
    [self.spinner startAnimating];
    
    isClose = YES;
    
    [self.timer invalidate];
    self.timer = nil;
    //[self.player stop];
    
    if ([[[self captureManager] recorder] isRecording]) {
        [[self captureManager] stopRecording];
    } else {
        /* 원상복귀 */
        if(IS_iOS_6){
            //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        } else {
            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
        }
        
        [self dismissModalViewControllerAnimated:NO];
    }

}

- (IBAction)nextQuestion:(id)sender {
    [self goNextQuestion];
}


/*
- (IBAction)captureStillImage:(id)sender
{
    // Capture a still image
    [[self stillButton] setEnabled:NO];
    [[self captureManager] captureStillImage];
    
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:[[self videoPreviewView] frame]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         [flashView release];
                     }
     ];
}
*/
@end

@implementation InterviewRecordViewController (InternalMethods)

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([captureVideoPreviewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported])
        [captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Update button states based on the number of available cameras and mics
- (void)updateButtonStates
{
	NSUInteger cameraCount = [[self captureManager] cameraCount];
	NSUInteger micCount = [[self captureManager] micCount];
    
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        if (cameraCount < 2) {
            //[[self cameraToggleButton] setEnabled:NO];
            
            if (cameraCount < 1) {
                //[[self stillButton] setEnabled:NO];
                
                if (micCount < 1)
                    [[self recordButton] setEnabled:NO];
                else {
                    [[self recordButton] setEnabled:YES];
                }
            } else {
                //[[self stillButton] setEnabled:YES];
                [[self recordButton] setEnabled:YES];
            }
        } else {
            //[[self cameraToggleButton] setEnabled:YES];
            //[[self stillButton] setEnabled:YES];
            [[self recordButton] setEnabled:YES];
        }
    });
}

@end

@implementation InterviewRecordViewController (AVCamCaptureManagerDelegate)

- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"면접을 중단합니다.")];
        [[self recordButton] setEnabled:YES];
        
        //면접질문 시작
        //[self.audioStreamer start];
        [self playQuestion:1];
        [[self nextButton] setEnabled:YES];
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)cm
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [[self recordButton] setTitle:NSLocalizedString(@"Record", @"면접을 시작합니다.")];
        [[self recordButton] setEnabled:YES];
        
    });
    NSLog(@"savedFile=%@",cm.savedFileUrl);
    NSLog(@"savedFile abspath=%@", [cm.savedFileUrl absoluteString]);
    //Thumbnail------------------------------------------------------------------------------------------------------------------------
    [self makeThumbnail:[cm.savedFileUrl absoluteString]];
    NSLog(@"make Thumbnail");
    
    [self insertInterviewData:[cm.savedFileUrl absoluteString]];
    NSLog(@"insertInterviewData ok");
    [[self nextButton] setEnabled:NO];
    [self.spinner stopAnimating];
    
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        //[[self stillButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
	[self updateButtonStates];
}

@end
