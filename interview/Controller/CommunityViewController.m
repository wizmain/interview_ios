//
//  CommunityViewController.m
//  interview
//
//  Created by 김규완 on 13. 4. 12..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "CommunityViewController.h"
#import "Constant.h"

@interface CommunityViewController ()
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) UISegmentedControl *segment;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *homeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) NSString *urlString;

- (IBAction)goHome:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;

@end

@implementation CommunityViewController

@synthesize segment;
@synthesize webview, loadingIndicator, homeButton, backButton, forwardButton;
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webview.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"자유게시판", @"Q&A", @"FAQ", @"개선제안", nil]];
    [seg setSegmentedControlStyle:UISegmentedControlStyleBar];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    self.segment = seg;
    self.navigationItem.titleView = self.segment;
    [seg release];
    
    if (IS_iPhone_5) {
        
    } else {
        CGRect frame = self.loadingIndicator.frame;
        frame.origin.y = 198;
        self.loadingIndicator.frame = frame;
    }
    
    [self loadUrl:[NSString stringWithFormat:@"%@%@", kServerUrl, kFreeBoardUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.segment = nil;
}


#pragma mark -
#pragma mark Custom Method
- (void)segmentChange:(id)sender {
    NSLog(@"segmentChange selected=%d", self.segment.selectedSegmentIndex);
    if (self.segment.selectedSegmentIndex == 0) {
        [self loadUrl:[NSString stringWithFormat:@"%@%@", kServerUrl, kFreeBoardUrl]];
    } else if (self.segment.selectedSegmentIndex == 1) {
        [self loadUrl:[NSString stringWithFormat:@"%@%@", kServerUrl, kQnaUrl]];
    } else if (self.segment.selectedSegmentIndex == 2) {
        [self loadUrl:[NSString stringWithFormat:@"%@%@", kServerUrl, kFaqUrl]];
    } else if (self.segment.selectedSegmentIndex == 3) {
        [self loadUrl:[NSString stringWithFormat:@"%@%@", kServerUrl, kImproveUrl]];
    }
}

- (void)loadUrl:(NSString *)urlS {
    NSLog(@"loadUrl %@", urlS);
    NSURL *url = [NSURL URLWithString:urlS];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (IBAction)goHome:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.webview goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webview goForward];
}

- (void)reload {
    [self.webview reload];
}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestStr = [[request URL] absoluteString];
    
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        // do something with [request URL]
        //return NO;
        NSLog(@"LinkClicked");
    }
    
    if ( navigationType == UIWebViewNavigationTypeOther ) {
        // do something with [request URL]
        //return NO;
        NSLog(@"TypeOther");
    }
    
    NSLog(@"shouldStartLoadWithRequest url = %@", requestStr);
    
    
    if([requestStr isEqualToString:[NSString stringWithFormat:@"%@%@", kServerUrl, kFreeBoardUrl]]) {
        [self.segment setSelectedSegmentIndex:0];
    } else if([requestStr isEqualToString:[NSString stringWithFormat:@"%@%@", kServerUrl, kQnaUrl]]) {
        [self.segment setSelectedSegmentIndex:1];
    } else if([requestStr isEqualToString:[NSString stringWithFormat:@"%@%@", kServerUrl, kFaqUrl]]) {
        [self.segment setSelectedSegmentIndex:2];
    } else if([requestStr isEqualToString:[NSString stringWithFormat:@"%@%@", kServerUrl, kImproveUrl]]) {
        [self.segment setSelectedSegmentIndex:3];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    [self.loadingIndicator startAnimating];
    [self.view bringSubviewToFront:self.loadingIndicator];
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    [self.loadingIndicator stopAnimating];
    
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.webview.canGoBack) {
        [self.backButton setEnabled:YES];
    } else {
        [self.backButton setEnabled:NO];
    }
    
    if (self.webview.canGoForward) {
        [self.forwardButton setEnabled:YES];
    } else {
        [self.forwardButton setEnabled:NO];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // report the error inside the webview
    
    if([error code] == NSURLErrorCancelled) {
        return;
    } else {
        
        NSString* errorString = [NSString stringWithFormat:
                                 @"<html><center><font size=+5 color='red'>오류 발생 :<br>%@</font></center></html>",
                                 error.localizedDescription];
        [self.webview loadHTMLString:errorString baseURL:nil];
    }
}

- (void)userDidTapWebView:(id)tapPoint {
    NSLog(@"userDidTapWebView");
    
}
@end
