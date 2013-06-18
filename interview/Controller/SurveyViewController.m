//
//  SurveyViewController.m
//  interview
//
//  Created by 김규완 on 13. 4. 26..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "SurveyViewController.h"
#import "Utils.h"
#import "Constant.h"
#import "HttpManager.h"
#import "SurveyApplyViewController.h"

@interface SurveyViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *surveyList;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@implementation SurveyViewController

@synthesize table, surveyList, httpManager;

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
    
    self.navigationItem.title = @"설문조사";
    
    self.httpManager = [HttpManager sharedManager];
    [self.httpManager setDelegate:self];
    
    [self.httpManager requestSurveyList];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.surveyList = nil;
    self.httpManager = nil;
}

- (void)bindSurveyData:(NSMutableArray *)resultData {
    self.surveyList = resultData;
    [self.table reloadData];
}

- (void)close:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.surveyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"SurveyListCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImage *img = [UIImage imageNamed:@"15-tags"];
		cell.imageView.image = img;
        [img release];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.surveyList != nil) {
        if(self.surveyList.count > 0){
			NSDictionary *a = [self.surveyList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"subject"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"subject"];
                }
                
                if([a objectForKey:@"s_date"] != (id)[NSNull null] && [a objectForKey:@"e_date"] != (id)[NSNull null]){
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyyMMddHHmmss"];
                    NSDate *sDate = [format dateFromString:[a objectForKey:@"s_date"]];
                    NSDate *eDate = [format dateFromString:[a objectForKey:@"e_date"]];
                    [format setDateFormat:@"yyyy-MM-dd"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[format stringFromDate:sDate], [format stringFromDate:eDate]];

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
	NSDictionary *a = [self.surveyList objectAtIndex:row];
    
    SurveyApplyViewController *apply = [[SurveyApplyViewController alloc] initWithNibName:@"SurveyApplyViewController" bundle:nil];
    apply.surveyInfo = a;
    UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:apply];
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:navi animated:YES];
    [naviBg release];
    [apply release];
    [navi release];
}


@end
