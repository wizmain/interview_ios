//
//  HomeViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "InterviewStartViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ScrapViewController.h"
#import "WebViewController.h"
#import "CommunityViewController.h"
#import "Constant.h"
#import "SurveyViewController.h"

@interface HomeViewController ()

@property (nonatomic, retain) IBOutlet UIButton *mainButton1;
@property (nonatomic, retain) IBOutlet UIButton *mainButton2;
@property (nonatomic, retain) IBOutlet UIButton *mainButton3;
@property (nonatomic, retain) IBOutlet UIButton *mainButton4;
@property (nonatomic, retain) IBOutlet UIButton *mainButton5;
@property (nonatomic, retain) IBOutlet UIButton *mainButton6;
@property (nonatomic, retain) IBOutlet UIButton *mainButton7;
@property (nonatomic, retain) IBOutlet UIButton *mainButton8;
@property (nonatomic, retain) IBOutlet UIButton *mainButton9;
@property (nonatomic, retain) IBOutlet UIButton *mainButton10;


- (IBAction)buttonClick:(id)sender;

@end

@implementation HomeViewController

@synthesize mainButton1, mainButton2, mainButton3, mainButton4, mainButton5, mainButton6, mainButton7, mainButton8, mainButton9, mainButton10;
@synthesize managedObjectContext;

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
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    //self.view.backgroundColor = [UIColor blueColor];
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.mainButton1 = nil;
    self.mainButton2 = nil;
    self.mainButton3 = nil;
    self.mainButton4 = nil;
    self.mainButton5 = nil;
    self.mainButton6 = nil;
    self.mainButton7 = nil;
    self.mainButton8 = nil;
    self.mainButton9 = nil;
    self.mainButton10 = nil;
    self.managedObjectContext = nil;
}

- (void)dealloc {
    [mainButton1 release];
    [mainButton2 release];
    [mainButton3 release];
    [mainButton4 release];
    [mainButton5 release];
    [mainButton6 release];
    [mainButton7 release];
    [mainButton8 release];
    [mainButton9 release];
    [mainButton10 release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSLog(@"sender tag = %d", button.tag);
    
    if(button.tag == 1){//interview start
        //InterviewStartViewController *start = [[InterviewStartViewController alloc] initWithNibName:@"InterviewStartViewController" bundle:nil];
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
    } else if(button.tag == 2){//스크랩
        ScrapViewController *scrap = [[ScrapViewController alloc] initWithNibName:@"ScrapViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scrap];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [scrap release];
        [navi release];
    } else if(button.tag == 3) {//영상보기
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:2];
    } else if(button.tag == 4) {//잡인터뷰
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:3];
    } else if(button.tag == 5) {//취업노하우
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kKnowHowUrl;
        web.title = @"취업노하우";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 6) {//공지사항
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kNoticeUrl;
        web.title = @"공지사항";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 7) {//커뮤니티
        CommunityViewController *web = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 8) {//면접설정
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:4];
    } else if(button.tag == 9) {//이용안내
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = kManualUrl;
        web.title = @"이용안내";
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [web release];
        [navi release];
    } else if(button.tag == 10) {//설문조사
        SurveyViewController *survey = [[SurveyViewController alloc] initWithNibName:@"SurveyViewController" bundle:nil];
        UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:survey];
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:navi animated:YES];
        [naviBg release];
        [survey release];
        [navi release];
    }
    
}

- (void)deleteAll {
    NSLog(@"DeleteAll");
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"InterviewQuestion" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interviewQuestion=%@", item);
        [self.managedObjectContext deleteObject:item];
    }
    
    entiryDescription = [NSEntityDescription entityForName:@"Interview" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    [request release];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interview=%@", item);
        [self.managedObjectContext deleteObject:item];
        
    }
    
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
    }
    
    
}


@end
