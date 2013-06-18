//
//  MainViewController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "InterviewStartViewController.h"
#import "JobInterviewViewController.h"
#import "SettingsController.h"
#import "MovieListController.h"
#import <CoreAudio/CoreAudioTypes.h>
#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController ()
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, assign) BOOL isRotate;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@end

@implementation MainViewController

@synthesize tabController, isRotate;

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
    
    isRotate = NO;
    
    //UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    //self.view.backgroundColor = backImg;
    //[backImg release];
    
    //탭 컨트롤러 등록
    
	if (self.tabController.view.superview == nil) {

		if (self.tabController == nil) {
            UITabBarController *tab = [[UITabBarController alloc] init];
			//tab.customizableViewControllers = nil;
            UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
            
            HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            //UINavigationController *tab1Navi = [[UINavigationController alloc] initWithRootViewController:home];
            //[home release];
            
            //[[tab1Navi tabBarItem] setImage:[UIImage imageNamed:@"53-house"]];
            //[[tab1Navi tabBarItem] setTitle:@"Home"];
            
            //if([tab1Navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            //    [tab1Navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
            //}
            
            [[home tabBarItem] setImage:[UIImage imageNamed:@"53-house"]];
            [[home tabBarItem] setTitle:@"Home"];
            
            
            InterviewStartViewController *interview = [[InterviewStartViewController alloc] initWithNibName:@"InterviewStartViewController" bundle:nil];
            UINavigationController *tab2Navi = [[UINavigationController alloc] initWithRootViewController:interview];
            [[tab2Navi tabBarItem] setImage:[UIImage imageNamed:@"02-interview"]];
            [[tab2Navi tabBarItem] setTitle:@"면접시작"];
            [interview release];
            
            if([tab2Navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
                [tab2Navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
            }
            
            MovieListController *movieList = [[MovieListController alloc] initWithNibName:@"MovieListController" bundle:nil];
            UINavigationController *tab3Navi = [[UINavigationController alloc] initWithRootViewController:movieList];
            [[tab3Navi tabBarItem] setImage:[UIImage imageNamed:@"69-display"]];
            [[tab3Navi tabBarItem] setTitle:@"영상보기"];
            [movieList release];
            
            if([tab3Navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
                [tab3Navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
            }
            
            JobInterviewViewController *jobinterview = [[JobInterviewViewController alloc] initWithNibName:@"JobInterviewViewController" bundle:nil];
            UINavigationController *tab4Navi = [[UINavigationController alloc] initWithRootViewController:jobinterview];
            [[tab4Navi tabBarItem] setImage:[UIImage imageNamed:@"291-idcard"]];
            [[tab4Navi tabBarItem] setTitle:@"잡인터뷰"];
            [jobinterview release];
            
            if([tab4Navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
                [tab4Navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
            }
            
            SettingsController *setting = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
            UINavigationController *tab5Navi = [[UINavigationController alloc] initWithRootViewController:setting];
            [[tab5Navi tabBarItem] setImage:[UIImage imageNamed:@"19-gear"]];
            [[tab5Navi tabBarItem] setTitle:@"면접설정"];
            [setting release];
            
            if([tab5Navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
                [tab5Navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
            }
            
            tab.viewControllers = [NSArray arrayWithObjects:home, tab2Navi, tab3Navi, tab4Navi, tab5Navi, nil];
            //tab.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
            //[tab1Navi release];
            
            [home release];
            [tab2Navi release];
            [tab3Navi release];
            [tab4Navi release];
            [tab5Navi release];
            [naviBg release];
            naviBg = nil;
            
            self.tabController = tab;
            [[self tabController] setDelegate:self];
            
            [tab release];
            
        }
    }
    
    
    [self.view addSubview:self.tabController.view];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tabController = nil;
    self.moviePlayer = nil;
}

- (void)dealloc
{
    [tabController release];
    [_moviePlayer release];
    [super dealloc];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return YES;
}


-(NSUInteger)supportedInterfaceOrientations
{
    //return self.fullScreenVideoIsPlaying ?
    //UIInterfaceOrientationMaskAllButUpsideDown :
    //UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return 0;
}



#pragma mark -
#pragma mark Custom Method

- (void)switchTabView:(NSInteger)tabIndex
{
	//[self.view addSubview:self.tabController.view];
	self.tabController.selectedIndex = tabIndex;
    [self.tabController viewWillAppear:NO];
}

- (void)switchMoviePlayer:(NSString *)url {
    /*
    MovieViewController *movie = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    movie.movieUrl = url;
    movie.view.autoresizesSubviews = YES;
    movie.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    [self presentModalViewController:movie animated:YES];
    
    [movie release];
    */
    
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[viewController viewWillAppear:NO];
}


#pragma mark -
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
}


@end
