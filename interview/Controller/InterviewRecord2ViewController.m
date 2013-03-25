//
//  InterviewRecord2ViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 6..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewRecord2ViewController.h"
#import "AnimatedGif.h"

@interface InterviewRecord2ViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *interviewerGif;

@end

@implementation InterviewRecord2ViewController

@synthesize interviewerGif;

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
    NSURL *interviewerUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"interviewer1_small" ofType:@"gif"]];
    UIImageView *gifImage = [AnimatedGif getAnimationForGifAtUrl: interviewerUrl];
    //interviewerGif = [AnimatedGif getAnimationForGifAtUrl: interviewerUrl];
    [self.view addSubview:gifImage];

    //CGRect frame = gifImage.frame;
    //frame.size.width = 320;
    //frame.size.height = 480;
    //gifImage.frame = frame;
    
    //[interviewerGif addSubview:gifImage];
    //[interviewerGif setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.interviewerGif = nil;
}



@end
