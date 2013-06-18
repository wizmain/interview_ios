//
//  JobInterviewViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "JobInterviewViewController.h"
#import "MovieListCell.h"
#import "Utils.h"
#import "NSNumber+NSNumber_Helpers.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "MainViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "HttpManager.h"
#import "InterviewQuestionViewController.h"
#import "EvaluateViewController.h"

@interface JobInterviewViewController () <MovieListCellDelegate, HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *interviewList;
@property (nonatomic, retain) UISegmentedControl *segment;

@end

@implementation JobInterviewViewController

@synthesize table, interviewList, segment;

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
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"나의영상함", @"평가신청함", @"베스트영상", @"이용자추천", nil]];
    [seg setSegmentedControlStyle:UISegmentedControlStyleBar];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];

    self.segment = seg;
    self.navigationItem.titleView = self.segment;
    [seg release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    self.table = nil;
    self.interviewList = nil;
    self.segment = nil;
}

- (void)dealloc {
    
    [interviewList release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [self requestInterview];
}


#pragma mark -
#pragma mark Custom Method
- (void)segmentChange:(id)sender {
    if (self.segment.selectedSegmentIndex == 0) {
        [self requestInterview];
    } else if(self.segment.selectedSegmentIndex == 1) {
        [self requestInterview];
    } else if(self.segment.selectedSegmentIndex == 2) {
        [self requestInterview];
    } else if(self.segment.selectedSegmentIndex == 3) {
        [self requestInterview];
    }
}

- (void)requestInterview {
    NSLog(@"requestInterview");
    HttpManager *manager = [HttpManager sharedManager];
    [manager setDelegate:self];
    
    
    [manager requestInterviewData:self.segment.selectedSegmentIndex+1 page:1];

}


#pragma mark -
#pragma mark HttpManagerDelegate
- (void)bindInterviewData:(NSMutableArray *)interviewData {
    NSLog(@"HttpManager delegate : bindInterviewData");
    self.interviewList = interviewData;
    
    [self.table reloadData];
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.interviewList.count;
}

#pragma mark -
#pragma mark Table view delegate
#define kMovieListCellHeight    115
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMovieListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"MovieListCell";
    MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
	if (cell == nil) {
        cell = [MovieListCell cellWithNib];
	}
	
	//NSUInteger row = [indexPath row];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell to show the book's title
    NSDictionary *interview = [[self interviewList] objectAtIndex:[indexPath row]];
    NSLog(@"configureCell %@", interview);
    
    MovieListCell *movieListCell = (MovieListCell *)cell;
    movieListCell.data = interview;
    movieListCell.titleLabel.text = [interview valueForKey:@"subject"];
    movieListCell.infoLabel1.text = [interview valueForKey:@"applyField"];
    movieListCell.tag = [[NSString stringWithFormat:@"%@",[interview valueForKey:@"uid"]] intValue];
    
    movieListCell.button1.enabled = NO;
    [movieListCell.button1 setTitle:@"" forState:UIControlStateNormal];
    [movieListCell.button1 setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray"] forState:UIControlStateNormal];
    
    
    [movieListCell.button2 setTitle:@"재생하기" forState:UIControlStateNormal];
    [movieListCell.button3 setTitle:@"면접질문" forState:UIControlStateNormal];
    
    
    if (self.segment.selectedSegmentIndex == 1) {
        
        NSString *state = [interview objectForKey:@"evaluate_state"];
        //R:평가대기, D:파일삭제 G:평가중 E:평가완료
        if ([state isEqualToString:@"R"]) {
            [movieListCell.button4 setTitle:@"평가대기" forState:UIControlStateNormal];
            [movieListCell.button4 setEnabled:NO];
        } else if([state isEqualToString:@"D"]){
            [movieListCell.button4 setTitle:@"파일삭제" forState:UIControlStateNormal];
            [movieListCell.button4 setEnabled:NO];
        } else if([state isEqualToString:@"G"]) {
            [movieListCell.button4 setTitle:@"평가중" forState:UIControlStateNormal];
            [movieListCell.button4 setEnabled:NO];
        } else if([state isEqualToString:@"E"]) {
            [movieListCell.button4 setTitle:@"평가결과" forState:UIControlStateNormal];
            [movieListCell.button4 setEnabled:YES];
        } else {
            [movieListCell.button4 setTitle:@"평가대기" forState:UIControlStateNormal];
            [movieListCell.button4 setEnabled:NO];
        }
        
        
        [movieListCell.button4 setBackgroundImage:[UIImage imageNamed:@"btn_bg_jaju"] forState:UIControlStateNormal];
    } else {
        [movieListCell.button4 setTitle:@"댓글보기" forState:UIControlStateNormal];
        [movieListCell.button4 setBackgroundImage:[UIImage imageNamed:@"btn_bg_yellow"] forState:UIControlStateNormal];
    }
    
    
    
    //
    /*
     if(interview.regdate){
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateStyle:NSDateFormatterShortStyle];
     NSString *messageDate = [formatter stringFromDate:interview.regdate];
     movieListCell.titleLabel.text = messageDate;
     [formatter release];
     }
     */
    
    int seconds = [[NSString stringWithFormat:@"%@",[interview objectForKey:@"duration"]] intValue];
    NSNumber *fileSize = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[interview objectForKey:@"size"]] intValue]];
    NSString *fileInfoString = [NSString stringWithFormat:@"%@ (%@)", [Utils convertTimeFromSeconds:seconds], [NSNumber displayFileFormat:fileSize]];
    movieListCell.infoLabel2.text = fileInfoString;
    
    movieListCell.delegate = self;
}

#pragma mark -
#pragma mark MovieListCell Delegate

//동영상 재생
- (void)movieListCellButton1Click:(MovieListCell *)cell {
    NSLog(@"button1Click");
    
}

//영상등록
- (void)movieListCellButton2Click:(MovieListCell *)cell {
    NSLog(@"button2Click");
    //i.putExtra("filepath", Constant.VOD_SERVER + "/"+folder+"/"+item.getHierarchy()+"/mp4:"+item.getFileName());
    NSString *folder = [cell.data valueForKey:@"folder"];
    NSString *url = [NSString stringWithFormat:@"%@/vod/%@/%@/mp4:%@/playlist.m3u8", kVodServer, [folder substringToIndex:4], folder, [cell.data valueForKey:@"tmpname"]];
    NSLog(@"url = %@", url);
    [[[AppDelegate sharedAppDelegate] mainViewController] switchMoviePlayer:url];
    
    
    //MovieViewController *movie = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    //movie.movieUrl = cell.interview.fileUrl;
    //[self presentModalViewController:movie animated:YES];
    //[movie release];
}

//면접질문
- (void)movieListCellButton3Click:(MovieListCell *)cell {
    NSLog(@"button3Click");
    InterviewQuestionViewController *question = [[InterviewQuestionViewController alloc] initWithNibName:@"InterviewQuestionViewController" bundle:nil];
    question.serverInterviewData = cell.data;
    question.isLocal = NO;
    
    [self.navigationController pushViewController:question animated:YES];
    [question release];
    
}

//파일삭제
- (void)movieListCellButton4Click:(MovieListCell *)cell {
    NSLog(@"button4Click");
    
    EvaluateViewController *evaluate = [[EvaluateViewController alloc] initWithNibName:@"EvaluateViewController" bundle:nil];
    evaluate.interview = cell.interview;
    evaluate.interviewUid = cell.tag;
    [self.navigationController pushViewController:evaluate animated:YES];
    
    [evaluate release];
}



@end
