//
//  InterviewController.m
//  interview
//
//  Created by 김규완 on 12. 8. 1..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "InterviewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"
#import "VideoPlayerViewController.h"

@interface InterviewController ()
@property (nonatomic,retain) NSNumberFormatter *numberFormatter;
@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) IBOutlet AVCamPreviewView *videoPreviewView;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) MPMoviePlayerController *player;
//@property (nonatomic, retain) VideoPlayerViewController *player;
@property (nonatomic, retain) MPMoviePlayerViewController *playerView;

- (IBAction)record:(id)sender;
@end

@interface InterviewController (InternalMethods)

@end

@interface InterviewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>
@end

@interface InterviewController (AVCamPreviewViewDelegate) <AVCamPreviewViewDelegate>
@end

@implementation InterviewController

@synthesize numberFormatter = _numberFormatter;
@synthesize captureManager = _captureManager;
@synthesize videoPreviewView = _videoPreviewView;
@synthesize captureVideoPreviewLayer = _captureVideoPreviewLayer;
@synthesize recordButton;
@synthesize cancelButton;
@synthesize player, playerView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    
    if(self != nil) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
        [self setNumberFormatter:numberFormatter];
        [numberFormatter release];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
        [self setNumberFormatter:numberFormatter];
        [numberFormatter release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"[video]interviewer1" ofType:@"mp4"];
    NSLog(@"path = %@", path);
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    
    
    //playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //playerView.view.frame = CGRectMake(0, 0, 320, 208);
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
    [player setControlStyle:MPMovieControlStyleNone];
    [[player view] setFrame:CGRectMake(0, 0, 320, 208)];
    //[player setScalingMode:MPMovieScalingModeAspectFill];
    //[player setShouldAutoplay:NO];
    [player setRepeatMode:MPMovieRepeatModeOne];
    
	//player = [playerView moviePlayer];
    [self.view addSubview:player.view];
    [player play];
    
    /*
    VideoPlayerViewController *p = [[VideoPlayerViewController alloc] init];
    p.URL = url;
    p.view.frame = CGRectMake(0, 0, 320, 208);
    [self.view addSubview:p.view];
    self.player = p;
    [p release];
    */
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];
    NSLog(@"AVAudioSession error %@", error);
    UInt32 doSetProperty = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
    [[AVAudioSession sharedInstance] setActive: YES error: &error];
    NSLog(@"AVAudioSession2 error %@", error);
    
    AVCamCaptureManager *captureManager = [[AVCamCaptureManager alloc] init];
    if ([captureManager setupSessionWithPreset:AVCaptureSessionPresetHigh error:&error]) {
        [self setCaptureManager:captureManager];
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[captureManager session]];
        UIView *view = [self videoPreviewView];
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        
        [captureVideoPreviewLayer setFrame:bounds];
        
        if ([captureVideoPreviewLayer isOrientationSupported]) {
            [captureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        }
        
        [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [[captureManager session] startRunning];
        
        [self setCaptureVideoPreviewLayer:captureVideoPreviewLayer];
        
        if ([[captureManager session] isRunning]) {
            
            [captureManager setOrientation:AVCaptureVideoOrientationPortrait];
            [captureManager setDelegate:self];
            
            NSUInteger cameraCount = [captureManager cameraCount];
            NSLog(@"cameraCount = %d", cameraCount);
            if (cameraCount < 1 && [captureManager micCount] < 1) {
                [[self recordButton] setEnabled:NO];
            }
            
            [viewLayer insertSublayer:captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
            
            
            [captureVideoPreviewLayer release];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Failed to start session."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
            [[self recordButton] setEnabled:NO];
            
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Input Device Init Failed"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    [captureManager release];
    
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
    [self setPlayerView:nil];
    [self setNumberFormatter:nil];
    [self setCaptureManager:nil];
    self.cancelButton = nil;
    
}

- (void)dealloc
{
    [player release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#pragma mark -
#pragma mark Custom Method

- (IBAction)record:(id)sender
{
    if (![[self captureManager] isRecording]) {
        [[self recordButton] setEnabled:NO];
        [[self captureManager] startRecording];
    } else {
        [[self recordButton] setEnabled:NO];
        [[self captureManager] stopRecording];
    }
}

- (IBAction)cancelRecord:(id)sender {
    if (![[self captureManager] isRecording]) {
        [[self captureManager] stopRecording];
    }
    [player stop];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)adjustOrientation:(id)sender
{
    AVCaptureVideoPreviewLayer *previewLayer = [self captureVideoPreviewLayer];
    AVCaptureSession *session = [[self captureManager] session];
    [session beginConfiguration];
    
    [[self captureManager] setOrientation:AVCaptureVideoOrientationPortrait];
    if ([previewLayer isOrientationSupported]) {
        [previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [session commitConfiguration];
}

@end


@implementation InterviewController (InternalMethods)



@end

@implementation InterviewController (AVCamCaptureManagerDelegate)

- (void) captureStillImageFailedWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Still Image Capture Failure"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) cannotWriteToAssetLibrary
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incompatible with Asset Library"
                                                        message:@"The captured file cannot be written to the asset library. It is likely an audio-only file."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) acquiringDeviceLockFailedWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Configuration Lock Failure"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) assetLibraryError:(NSError *)error forURL:(NSURL *)assetURL
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Asset Library Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) someOtherError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) recordingBegan
{
    [[self recordButton] setTitle:@"Stop"];
    [[self recordButton] setEnabled:YES];
}

- (void) recordingFinished
{
    [[self recordButton] setTitle:@"Record"];
    [[self recordButton] setEnabled:YES];
}

- (void) deviceCountChanged
{
    AVCamCaptureManager *captureManager = [self captureManager];
    if ([captureManager cameraCount] >= 1 || [captureManager micCount] >= 1) {
        [[self recordButton] setEnabled:YES];
    } else {
        [[self recordButton] setEnabled:NO];
    }
}

@end

@implementation InterviewController (AVCamPreviewViewDelegate)

- (void)tapToFocus:(CGPoint)point
{
    AVCamCaptureManager *captureManager = [self captureManager];
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        
    }
}

- (void)tapToExpose:(CGPoint)point
{
    AVCamCaptureManager *captureManager = [self captureManager];
    if ([[[captureManager videoInput] device] isExposurePointOfInterestSupported]) {
        
    }
}

- (void)resetFocusAndExpose
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    [[self captureManager] focusAtPoint:pointOfInterest];
    [[self captureManager] exposureAtPoint:pointOfInterest];
    
    [[self captureManager] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
}

@end


