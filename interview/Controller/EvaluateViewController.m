//
//  EvaluateViewController.m
//  interview
//
//  Created by 김규완 on 13. 4. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "EvaluateViewController.h"
#import "Interview.h"
#import "HttpManager.h"
#import "UIButton+Position.h"
#import "Evaluate1Cell.h"
#import "Evaluate2Cell.h"

@interface EvaluateViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;
@property (nonatomic, retain) IBOutlet UILabel *label5;
@property (nonatomic, retain) IBOutlet UITextView *totalOpinionText;
@property (nonatomic, retain) HttpManager *httpManager;
@property (nonatomic, retain) UIBarButtonItem *evaluateButton;
@property (nonatomic, retain) EvaluatePopoverController *evaluatePopover;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *page1;
@property (nonatomic, retain) IBOutlet UIView *page2;
@property (nonatomic, retain) IBOutlet UITableView *table1;
@property (nonatomic, retain) IBOutlet UITableView *table2;
@property (nonatomic, retain) NSArray *questionList;
@property (nonatomic, retain) NSArray *table1Array;

- (IBAction)changePage:(id)sender;

@end

@implementation EvaluateViewController

@synthesize label1, label2, label3, label4, label5, totalOpinionText;
@synthesize interview, httpManager, interviewUid, evaluateButton;
@synthesize evaluatePopover, popover, pageControl;
@synthesize page1, page2, table1, table2, questionList, table1Array;


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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"종합의견";
    
    UIButton *eButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[addButton setTitle:@"추가" forState:UIControlStateNormal];
    [eButton setBackgroundImage:[UIImage imageNamed:@"big_btn_bg_blue"] forState:UIControlStateNormal];
    [eButton setImage:[UIImage imageNamed:@"259-list"] forState:UIControlStateNormal];
    [eButton addTarget:self action:@selector(otherEvaluateClick:) forControlEvents:UIControlEventTouchUpInside];
    [eButton setTitle:@"더보기" forState:UIControlStateNormal];
    [eButton centerButtonAndImageWithSpacing:5];
    eButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    eButton.frame = CGRectMake(0, 0, 80, 34);
    self.evaluateButton = [[UIBarButtonItem alloc] initWithCustomView:eButton];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    self.navigationItem.rightBarButtonItem = self.evaluateButton;
    [eButton release];
    
    [self initData];
    
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    
    if(interviewUid > 0) {
        
        [self.httpManager requestEvaluateResult:interviewUid];
        
        [self.httpManager requestInterviewQuestion:interviewUid];
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    int height=460;
    if (IS_iPhone_5) {
        height = 548;
        CGRect page1Frame = self.page1.frame;
        CGRect page2Frame = self.page2.frame;
        CGRect table1Frame = self.table1.frame;
        CGRect table2Frame = self.table2.frame;
        page1Frame.size.height = height;
        page2Frame.size.height = height;
        table1Frame.size.height = height;
        table2Frame.size.height = height;
        self.page1.frame = page1Frame;
        self.page2.frame = page2Frame;
        self.table1.frame = table1Frame;
        self.table2.frame = table2Frame;
    } else {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = 380;
        self.pageControl.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(320*4, height-50);
    self.table1.tag = 1;
    self.table2.tag = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.totalOpinionText = nil;
    self.httpManager = nil;
    self.interview = nil;
    self.questionList = nil;
    self.table1Array = nil;
    self.evaluateButton = nil;
    self.evaluatePopover = nil;
    self.popover = nil;
    self.pageControl = nil;
    self.scrollView = nil;
    self.page1 = nil;
    self.page2 = nil;
    self.table1 = nil;
    self.table2 = nil;
    
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (void)initData {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"자기소개를 하는 내용이 적절한가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"자기소개를 할 때 표정이 밝고 여유가 있는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"자기소개를 하는 동안 손동작은 자연스러운가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"자기소개를 할때의 목소리는 맑은가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"면접관이 질문할 때 시선은 자유로운가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"질문이 주어졌을 때, 잠시 생각하는 시간을 갖는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"질문에 대해 긍정적인 반응을 보였는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic8 = [[NSDictionary alloc] initWithObjectsAndKeys:@"결론부터 얘기하고, 그에 대한 근거를 설명하는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic9 = [[NSDictionary alloc] initWithObjectsAndKeys:@"답변이 명쾌하고 간결한가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic10 = [[NSDictionary alloc] initWithObjectsAndKeys:@"답변의 내용이 창의적인가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic11 = [[NSDictionary alloc] initWithObjectsAndKeys:@"모르는 질문에 대해 솔직하게 모른다고 답하였는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic12 = [[NSDictionary alloc] initWithObjectsAndKeys:@"대답하는 동안 시선은 안정을 유지하였는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic13 = [[NSDictionary alloc] initWithObjectsAndKeys:@"제스처는 자연스러운가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic14 = [[NSDictionary alloc] initWithObjectsAndKeys:@"불필요하거나 어색한 행동을 하지 않는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic15 = [[NSDictionary alloc] initWithObjectsAndKeys:@"표정은 자연스러운가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic16 = [[NSDictionary alloc] initWithObjectsAndKeys:@"면접관의 질문에 경청하는 자세를 보였는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic17 = [[NSDictionary alloc] initWithObjectsAndKeys:@"잘 모르거나 실수를 했더라도 거기에 연연하지 않고 다음 질문에 최선을 다하는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic18 = [[NSDictionary alloc] initWithObjectsAndKeys:@"입사하고자 하는 열의가 보이는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic19 = [[NSDictionary alloc] initWithObjectsAndKeys:@"부자연스럽거나 부적절한 표현을 사용하지 않는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic20 = [[NSDictionary alloc] initWithObjectsAndKeys:@"끝까지 최선을 다하는가?", @"title", @"보통", @"value", nil];
    NSDictionary *dic21 = [[NSDictionary alloc] initWithObjectsAndKeys:@"회사에 대해 궁금한 점을 준비해서 물어 보았는가?", @"title", @"보통", @"value", nil];
    
    NSArray *array = [[NSArray alloc] initWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8, dic9, dic10, dic11, dic12, dic13, dic14, dic15, dic16, dic17, dic18, dic19, dic20, dic21, nil];
    
    self.table1Array = array;
    
    [array release];
}

- (void)bindEvaluateResult:(NSDictionary *)resultData {
    //NSLog(@"bindEvaluateResult resultData=%@", resultData);
    NSLog(@"mentor_name=%@",[resultData valueForKeyPath:@"mentor_name"]);
    
    self.label1.text = [resultData valueForKeyPath:@"mentor_name"];
    self.label2.text = [resultData valueForKeyPath:@"name"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    //[formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [NSString stringWithFormat:@"%@", [resultData valueForKeyPath:@"E_REGIS"]];
    NSDate *regDate = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    self.label3.text = [formatter stringFromDate:regDate];
    [formatter release];
    
    self.label4.text = [resultData valueForKeyPath:@"applyField"];
    self.label5.text = [resultData valueForKeyPath:@"TOTAL_GRADE"];
    self.totalOpinionText.text = [resultData valueForKeyPath:@"TOTAL_DESCRIPT"];
    
}

- (void)bindInterviewQuestion:(NSMutableArray*)questionData {
    self.questionList = questionData;
    NSLog(@"bindInterviewQuestion count=%d", self.questionList.count);
    [self.table2 reloadData];
}

- (void)otherEvaluateClick:(id)sender {
    EvaluatePopoverController *menu = [[EvaluatePopoverController alloc] initWithNibName:@"EvaluatePopoverController" bundle:nil];
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:menu];
    [pop setDelegate:self];
    //[pop presentPopoverFromRect:self.scrapButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    pop.popoverContentSize = CGSizeMake(400, 280);
    
    menu.parent = self;
    [pop presentPopoverFromBarButtonItem:self.evaluateButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.popover = pop;
    self.evaluatePopover = menu;
    [menu release];
    [pop release];
}

- (void)dismissPopover:(int)selectedRow {
    [self.popover dismissPopoverAnimated:YES];
    
    self.pageControl.currentPage = selectedRow-1;
    int page = self.pageControl.currentPage;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = 320 * page;
    //frame.origin.y = 0;
    NSLog(@"frame.origin.x=%f", frame.origin.x);
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    if (selectedRow == 1) {
    
    } else if(selectedRow == 2) {
        
    } else if(selectedRow == 3) {
        
    }
}

- (IBAction)changePage:(id)sender {
    NSLog(@"changePage");
    int page = self.pageControl.currentPage;
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width *page;
    frame.origin.y = 0;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {

    CGFloat pageWidth=self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = page;
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1) {
        return self.table1Array.count;
    } else {
        return self.questionList.count;
    }

}

#pragma mark -
#pragma mark Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    if (tableView.tag == 1) {//
        static NSString *normalCellIdentifier = @"Evaluate1Cell";
        Evaluate1Cell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        
        if (cell == nil) {
            cell = [Evaluate1Cell cellWithNib];
        }
        
        //NSUInteger row = [indexPath row];
        
        [self configureCell1:cell atIndexPath:indexPath];
        
        return cell;
    } else {
        static NSString *normalCellIdentifier = @"Evaluate2Cell";
        Evaluate2Cell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        
        if (cell == nil) {
            cell = [Evaluate2Cell cellWithNib];
        }
        
        //NSUInteger row = [indexPath row];
        
        [self configureCell2:cell atIndexPath:indexPath];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 44;
    } else {
        //return [self cellHeight:[indexPath row]];
        return 87;
    }
}

#define PADDING 10.0f
- (CGFloat)cellHeight:(int)row {
    
    NSDictionary *a = [self.questionList objectAtIndex:row];
    NSString *aText = [NSString stringWithFormat:@"%@",[a valueForKey:@"Q_TITLE"]];
    CGSize textSize = [aText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table2.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    NSString *eText = @"";
    CGSize textSize2 = [eText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table2.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    if(textSize.height + textSize2.height > 60) {
        return textSize.height + PADDING * 3 - 10 + textSize2.height;
    } else {
        return textSize.height + PADDING * 3 - 3 + textSize2.height;
    }
    
}


- (void)configureCell1:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell to show the book's title
    NSDictionary *i = [[self table1Array] objectAtIndex:[indexPath row]];
    NSLog(@"configureCell %@", i);
    
    if (self.table1Array != nil) {
        if(self.table1Array.count > 0){
    
            Evaluate1Cell *c = (Evaluate1Cell *)cell;
            c.titleLabel.text = [i objectForKey:@"title"];
            c.valueLabel.text = [i objectForKey:@"value"];
        }
    }
    
}

- (void)configureCell2:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell to show the book's title
    
    if (self.questionList != nil) {
        if(self.questionList.count > 0){
    
            NSDictionary *question = [[self questionList] objectAtIndex:[indexPath row]];
            NSLog(@"configureCell %@", question);
            
            Evaluate2Cell *c = (Evaluate2Cell *)cell;
            c.questionText.text = [question valueForKey:@"Q_TITLE"];
            c.evaluateText.text = @"";
            
        }
    }
    
}


/*
 item.setUid(o.getInt("UID"));
 item.setInterviewUid(o.getInt("INTERVIEW_UID"));
 String dateString = o.getString("E_REGIS");
 Date d = DateTimeUtil.getDateFromString(dateString, "yyyyMMddHHmmss");
 item.setRegDate(d.getTime());
 dateString = o.getString("evaluate_date");
 d = DateTimeUtil.getDateFromString(dateString, "yyyyMMddHHmmss");
 item.setEvaluateDate(d.getTime());
 dateString = o.getString("evaluate_edate");
 d = DateTimeUtil.getDateFromString(dateString, "yyyyMMddHHmmss");
 item.setEvaluateEDate(d.getTime());
 item.setMentorID(o.getString("mentor_id"));
 item.setMentorName(o.getString("mentor_name"));
 item.setTotalGrade(o.getString("TOTAL_GRADE"));
 item.setTotalDescript(o.getString("TOTAL_DESCRIPT"));
 item.setItemHealth(o.getString("ITEM_HEALTH"));
 item.setItemClothes(o.getString("ITEM_CLOTHES"));
 item.setItemAttitude(o.getString("ITEM_ATTITUDE"));
 item.setItemYouth(o.getString("ITEM_YOUTH"));
 item.setItemExpression(o.getString("ITEM_EXPRESSION"));
 item.setItemCollaborate(o.getString("ITEM_COLLABORATE"));
 item.setItemConversation(o.getString("ITEM_CONVERSATION"));
 item.setItemGoodFeel(o.getString("ITEM_GOODFEEL"));
 item.setItemDescript(o.getString("ITEM_DESCRIPT"));
 item.setCheckScore1(o.getString("CHECK_SCORE_1"));
 item.setCheckScore2(o.getString("CHECK_SCORE_2"));
 item.setCheckScore3(o.getString("CHECK_SCORE_3"));
 item.setCheckScore4(o.getString("CHECK_SCORE_4"));
 item.setCheckScore5(o.getString("CHECK_SCORE_5"));
 item.setCheckScore6(o.getString("CHECK_SCORE_6"));
 item.setCheckScore7(o.getString("CHECK_SCORE_7"));
 item.setCheckScore8(o.getString("CHECK_SCORE_8"));
 item.setCheckScore9(o.getString("CHECK_SCORE_9"));
 item.setCheckScore10(o.getString("CHECK_SCORE_10"));
 item.setCheckScore11(o.getString("CHECK_SCORE_11"));
 item.setCheckScore12(o.getString("CHECK_SCORE_12"));
 item.setCheckScore13(o.getString("CHECK_SCORE_13"));
 item.setCheckScore14(o.getString("CHECK_SCORE_14"));
 item.setCheckScore15(o.getString("CHECK_SCORE_15"));
 item.setCheckScore16(o.getString("CHECK_SCORE_16"));
 item.setCheckScore17(o.getString("CHECK_SCORE_17"));
 item.setCheckScore18(o.getString("CHECK_SCORE_18"));
 item.setCheckScore19(o.getString("CHECK_SCORE_19"));
 item.setCheckScore20(o.getString("CHECK_SCORE_20"));
 item.setCheckScore21(o.getString("CHECK_SCORE_21"));
 item.setCheckDescript(o.getString("CHECK_DESCRIPT"));
 item.setQuestionDescript(o.getString("QUESTION_DESCRIPT"));
 item.setUserName(o.getString("name"));
 item.setUserSex(o.getString("sex"));
 item.setApplyField(o.getString("applyField"));
 item.setAge(o.getInt("age"));
 item.setInterviewCategory(o.getString("interview_category"));
 item.setMajor(o.getString("major"));
 item.setEvaluateState(o.getString("evaluate_state"));
*/
@end
