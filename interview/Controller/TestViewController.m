//
//  TestViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

@end
