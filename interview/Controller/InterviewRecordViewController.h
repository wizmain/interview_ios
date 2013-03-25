//
//  InterviewRecordViewController.h
//  interview
//
//  Created by 김규완 on 13. 2. 28..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer, MPMoviePlayerController;

@interface InterviewRecordViewController : UIViewController

@property (nonatomic, retain) AVCamCaptureManager *captureManager;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) AudioStreamer *audioStreamer;
@property (nonatomic, retain) IBOutlet UIView *videoPreviewView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, retain) MPMoviePlayerController *player;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *answerTimeBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *answerTimeInfoBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *questionTitleBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *questionInfoBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *categoryTitleButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UITextView *questionText;
@property (nonatomic, retain) NSArray *questionList;

@property (nonatomic, retain) NSString *categoryID;


- (IBAction)toggleRecording:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)nextQuestion:(id)sender;

@end
