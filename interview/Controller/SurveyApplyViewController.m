//
//  SurveyApplyViewController.m
//  interview
//
//  Created by 김규완 on 13. 4. 26..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "SurveyApplyViewController.h"
#import "HttpManager.h"
#import "AlertUtils.h"
#import "JSON.h"

@interface SurveyApplyViewController () <HttpManagerDelegate>
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextView *questionTextView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *questionInfoButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSMutableArray *questionList;
@property (nonatomic, retain) NSMutableArray *exampleList;
@property (nonatomic, retain) HttpManager *httpManager;
@property (nonatomic, assign) int currentQNo;
@property (nonatomic, assign) int totalQCnt;
@property (nonatomic, assign) int selectedRow;
@property (nonatomic, assign) int surveyNo;
@property (nonatomic, retain) NSIndexPath *lastSelected;
@property (nonatomic, retain) UIImage *uncheckedImage;
@property (nonatomic, retain) UIImage *checkedImage;

- (IBAction)bindNextQuestion:(id)sender;
- (IBAction)bindPrevQuestion:(id)sender;
@end

@implementation SurveyApplyViewController

@synthesize table, surveyInfo, questionList, exampleList, questionTextView, nextButton, prevButton, currentQNo, questionInfoButton;
@synthesize lastSelected, uncheckedImage, checkedImage, activityView;

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
    self.httpManager = [HttpManager sharedManager];
    _totalQCnt = 0;
    _selectedRow = 0;
    self.questionInfoButton.title = @"0/0";
    UIImage *uncheck = [UIImage imageNamed:@"unchecked"];
    UIImage *check = [UIImage imageNamed:@"check"];
    self.uncheckedImage = uncheck;
    self.checkedImage = check;
    [uncheck release];
    [check release];
    
    if(self.surveyInfo){
        self.navigationItem.title = [self.surveyInfo valueForKey:@"subject"];
        
        _surveyNo = [[NSString stringWithFormat:@"%@",[self.surveyInfo valueForKey:@"uid"]] intValue];
        NSLog(@"surveyNo=%d",_surveyNo);
        [self.httpManager requestSurveyQuestion:_surveyNo];
        [self.httpManager setDelegate:self];
    }
        
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
    self.surveyInfo = nil;
    self.questionList = nil;
    self.exampleList = nil;
    self.questionTextView = nil;
    self.nextButton = nil;
    self.prevButton = nil;
    self.questionInfoButton = nil;
    self.uncheckedImage = nil;
    self.checkedImage = nil;
}

- (void)bindQuestion:(int)qNo {
    NSLog(@"bindQuestion qNo=%d ", qNo);
    if(self.questionList != nil){
        if (self.questionList.count < qNo || qNo < 1) {
            return;
        }
        
        currentQNo = qNo;
        NSDictionary *q = [self.questionList objectAtIndex:qNo-1];
        //NSLog(@"questionInfo=%@", q);
        self.questionTextView.text = [NSString stringWithFormat:@"%d. %@",qNo, [q valueForKey:@"subject"]];
        //NSLog(@"subject=%@", [q valueForKey:@"subject"]);
        
        id JSON = [q objectForKey:@"example"];
        //NSLog(@"example=%@", ex);
        NSMutableArray *resultList = [[NSMutableArray alloc] init];
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"uid"], @"uid",
                                 [entry valueForKeyPath:@"itemName"], @"itemName",
                                 [entry valueForKeyPath:@"questionUid"], @"questionUid",
                                 [entry valueForKeyPath:@"itemOrder"], @"itemOrder", nil];
            //NSLog(@"subject = %@", [entry valueForKeyPath:@"subject"]);
            [resultList addObject:dic];
            
        }
        
        //SBJsonParser *jsonParser = [SBJsonParser new];
        //self.exampleList = (NSMutableArray*)[jsonParser objectWithString:ex];
        //[self.table reloadData];
        self.exampleList = resultList;
        [self.table reloadData];
        [resultList release];
        self.questionInfoButton.title = [NSString stringWithFormat:@"%d/%d", qNo, _totalQCnt];
        
    }
}

- (IBAction)bindNextQuestion:(id)sender {
    
    if ((currentQNo + 1) > _totalQCnt) {
        AlertWithMessage(@"다음 질문이 없습니다");
        return;
    } else {
        [self bindQuestion:currentQNo+1];
    }
}

- (IBAction)bindPrevQuestion:(id)sender {
    if ((currentQNo - 1) < 1) {
        AlertWithMessage(@"이전 질문이 없습니다");
        return;
    } else {
        [self bindQuestion:currentQNo-1];
    }
}

- (void)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)bindSurveyQuestion:(NSMutableArray *)questionData {
    NSLog(@"bindSurveyQuestion %@", questionData);
    self.questionList = questionData;
    
    if(self.questionList){
        if(self.questionList.count > 0){
            //NSDictionary *q = [self.questionList objectAtIndex:0];
            //int questionUid = [[NSString stringWithFormat:@"%@",[q valueForKey:@"uid"]] intValue];
            _totalQCnt = self.questionList.count;
            [self bindQuestion:1];
        }
    }

}

- (void)surveyQuestionSetAnswerResult:(NSString *)result {
    NSLog(@"surveyQuestionSetAnswerResult : %@", result);
    self.activityView.hidden = YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.exampleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"SurveyQuestion2Cell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        
        //UIImage *img = [UIImage imageNamed:@"unchecked"];
		//cell.imageView.image = img;
        //[img release];
        cell.imageView.image = self.uncheckedImage;
        cell.imageView.highlightedImage = self.checkedImage;
        
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
    NSUInteger row = [indexPath row];
	
	if (self.exampleList != nil) {
        if(self.exampleList.count > 0){
			NSDictionary *a = [self.exampleList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"itemName"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"itemName"];
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
    NSDictionary *q = [self.questionList objectAtIndex:currentQNo -1];
	NSDictionary *a = [self.exampleList objectAtIndex:row];
    
    _selectedRow = row;
    /*
    if(self.lastSelected == indexPath) {
        return;
    } else {
        
        UITableViewCell *old = [self.table cellForRowAtIndexPath:self.lastSelected];
        old.imageView.image = self.uncheckedImage;
        
        UITableViewCell *selected = [self.table cellForRowAtIndexPath:indexPath];
        selected.imageView.image = self.checkedImage;
        
        self.lastSelected = indexPath;
    }
    //[self.table reloadData];
    */
    self.activityView.hidden = NO;
    int qUid = [[NSString stringWithFormat:@"%@",[q valueForKey:@"uid"]] intValue];
    NSString *answer = [NSString stringWithFormat:@"%@", [a valueForKey:@"uid"]];
    NSLog(@"_surveyNo=%d qUid=%d answer=%@", _surveyNo, qUid, answer);
    
    [self.httpManager surveyQuestionSetAnswer:_surveyNo questionUid:qUid answer:answer];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    float height = 20;
    
    if (self.exampleList) {
		
		if([self.exampleList count] > 0){
			NSDictionary *ex = [self.exampleList objectAtIndex:row];
			NSString *cellText = [ex valueForKey:@"itemName"];
            
            UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            
            height = labelSize.height + 20;
		}
	}
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
	label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"보기 총%d개", self.exampleList.count];
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
	view.backgroundColor = RGB(101, 169, 239);
    [view autorelease];
    [view addSubview:label];
	
    return view;
}


@end
