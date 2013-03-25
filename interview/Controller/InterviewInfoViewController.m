//
//  InterviewInfoViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 27..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewInfoViewController.h"
#import "Utils.h"
#import "RecordReadyController.h"

@interface InterviewInfoViewController ()

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *infoText;

- (IBAction)goInterviewReady:(id)sender;

@end

@implementation InterviewInfoViewController

@synthesize startButton;
@synthesize titleLabel, infoText;
@synthesize categoryID;
@synthesize subCategoryID, subCategoryName;

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
    
    
    if([self.categoryID isEqualToString:@"ROOT"]) {
        infoText.text = @"실제 면접상황과 동일하게 \n최신 면접 질문을 자동추출하여 면접을 시작합니다. \n면접을 준비하는 지원자에게 가장 적합한 면접 모델입니다.";
        titleLabel.text = @"면접분야 : 표준";
        self.navigationItem.title = @"표준";
    } else if([self.categoryID isEqualToString:@"A"]) {
        infoText.text = @"면접 질문의 유형별로 집중적으로 연습할 수 있습니다.\n선택하신 면접 질문의 유형에 맞춰 면접을 시작힙니다.";
        titleLabel.text = @"면접분야 : 유형별";
        self.navigationItem.title = @"유형별";
    } else if([self.categoryID isEqualToString:@"B"]) {
        infoText.text = @"지원하고자 하는 기업의 업중, 직무에 대한 면접 질문입니다.\n선택한 업직종에 관련된 질문으로 면접을 시작합니다.";
        titleLabel.text = @"면접분야 : 업직종";
        self.navigationItem.title = @"업직종";
    } else if([self.categoryID isEqualToString:@"C"]) {
        infoText.text = @"공무원 시험의 면접에서 자주 나오는 질문에 대해\n집중적으로 면접 연습을 시작합니다.";
        titleLabel.text = @"면접분야 : 공무원";
        self.navigationItem.title = @"공무원";
    } else {
        
    }
    
    if( ![Utils isNullString:self.subCategoryName] ) {
        titleLabel.text = [NSString stringWithFormat:@"면접분야 : %@", self.subCategoryName];
        self.navigationItem.title = self.subCategoryName;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.startButton = nil;
    self.titleLabel = nil;
    self.infoText = nil;
    self.categoryID = nil;
    self.subCategoryName = nil;
    self.subCategoryID = nil;
}

#pragma mark -
#pragma mark Custom Method
- (IBAction)goInterviewReady:(id)sender {
    RecordReadyController *r = [[RecordReadyController alloc] initWithNibName:@"RecordReadyController" bundle:nil];
    r.categoryID = self.categoryID;
    if( ![Utils isNullString:self.subCategoryID] ) {
        r.categoryID = self.categoryID;
    }
    
    [self.navigationController pushViewController:r animated:YES];
    
    /*
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:r];
    UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    [naviBg release];
    
    [self presentModalViewController:navi animated:YES];
    [navi release];
    */
    [r release];
}


@end
