//
//  MovieViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 20..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MovieViewController.h"
#import "AlertUtils.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Interview.h"

@interface MovieViewController ()
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) MPMoviePlayerViewController *playerView;
@end

@implementation MovieViewController

@synthesize player, playerView, movieUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.movieUrl) {
        NSURL *url = [NSURL URLWithString:movieUrl];
        playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        //[playerView.view setFrame:[UIScreen mainScreen].bounds];
        player = [playerView moviePlayer];
        //[player setControlStyle:MPMovieControlStyleFullscreen];
        player.view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:playerView.view];
        //[self presentMoviePlayerViewControllerAnimated:playerView];
        
    } else {
        AlertWithMessage(@"동영상 정보가 설정되지 않았습니다");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(durationAvailableCallback:)
												 name:MPMovieDurationAvailableNotification
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(mediaTypesAvailableNoti:)
												 name:MPMovieMediaTypesAvailableNotification
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerFullscreenNoti:)
												 name:MPMoviePlayerDidEnterFullscreenNotification
											   object:player];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerExitFullscreenNoti:)
												 name:MPMoviePlayerDidExitFullscreenNotification
											   object:player];
	//동영상 플레이 상태
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerPlaybackStateChange:)
												 name:MPMoviePlayerPlaybackStateDidChangeNotification
											   object:player];
	
	//버퍼링 상태등.. 변화
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerLoadStateChange:)
												 name:MPMoviePlayerLoadStateDidChangeNotification
											   object:player];
	
	//무비 url 변경시
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerNowPlayingMovieChange:)
												 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
											   object:player];
	
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(MPMoviePlayerDidExitFullscreen:)
                                                  name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

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
    self.player = nil;
    self.playerView = nil;
}

- (void)dealloc {

    [playerView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method


#pragma mark -
#pragma mark MoviePlayer Notification Method

- (void)MPMoviePlayerDidExitFullscreen:(NSNotification *)aNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:nil];
    
    [self.player stop];
    //[self.view removeFromSuperview];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)movieFinishedCallback:(NSNotification *)aNotification {
	
	//MPMoviePlayerController *player = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
	//[self dismissModalViewControllerAnimated:YES];
}

- (void)durationAvailableCallback:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	
	//NSLog(@"durationAvailableCallback %f", player.duration);
	
	
}

- (void)mediaTypesAvailableNoti:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"mediaTypesAvailableNoti");
}

- (void)moviePlayerFullscreenNoti:(NSNotification *)aNotification {
	//NSLog(@"moviePlayerFullscreenNoti");
}

- (void)moviePlayerExitFullscreenNoti:(NSNotification *)aNotification {
	//NSLog(@"MPMoviePlayerDidExitFullscreenNotification");
}

- (void)moviePlayerPlaybackStateChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	if (player) {
		//NSLog(@"moviePlayerPlaybackStateChange %d", player.playbackState);
        
        if (player.playbackState == MPMoviePlaybackStatePlaying) {
            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
        
	}
	
}

- (void)moviePlayerLoadStateChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"moviePlayerLoadStateChane");
    
    
}

- (void)moviePlayerNowPlayingMovieChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"now playing movie url = %@", player.contentURL);
}

@end
