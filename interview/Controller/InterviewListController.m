//
//  InterviewListController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "InterviewListController.h"
#import "Constant.h"
#import "JSON.h"
#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "AlertUtils.h"
#import "RecordReadyController.h"
#import "InterviewInfoViewController.h"

@interface InterviewListController ()

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *interviewList;

- (void)bindInterviewList;

@end

@implementation InterviewListController

@synthesize table, interviewList;
@synthesize categoryID, categoryName;

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
    
    //타이틀
	self.navigationItem.title = self.categoryName;
    self.table.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //네비게이션 바 버튼 설정
    /*
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    */
    
    [self bindInterviewList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.categoryID =nil;
    self.interviewList =nil;
    self.categoryName = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Custom Method

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindInterviewList {

    NSString *url = [kServerUrl stringByAppendingFormat:@"%@?up_category_id=%@", kInterviewCategoryUrl, self.categoryID];
	
	HTTPRequest *httpRequest = [[AppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"bindInterview url = %@", url);
	
    //통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
    
    /*
     NSError *error = nil;
     NSHTTPURLResponse *response = nil;
     NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
     NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     [self didNoticeReceiveFinished:resultData];
     */
}

#pragma mark -
#pragma mark HTTPRequest delegate
- (void)didReceiveFinished:(NSString *)result {
	//NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	self.interviewList = (NSArray *)[jsonParser objectWithString:result];
    NSLog(@"didReceiveFinished interviewList count %d", [self.interviewList count]);
    [self.table reloadData];
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.interviewList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"CategoryCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImage *img = [UIImage imageNamed:@"15-tags"];
		cell.imageView.image = img;
        [img release];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.interviewList != nil) {
        if(self.interviewList.count > 0){
			NSDictionary *a = [self.interviewList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"CATEGORY_NAME"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"CATEGORY_NAME"];
                } else {
                    
                }
            }
        }
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	NSDictionary *a = [self.interviewList objectAtIndex:row];
    
	InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:nil];
    v.categoryID = self.categoryID;
    v.subCategoryID = [a objectForKey:@"CATEGORY_ID"];
    v.subCategoryName = [a objectForKey:@"CATEGORY_NAME"];
    
	[self.navigationController pushViewController:v animated:YES];
    [v release];
    
}

@end
