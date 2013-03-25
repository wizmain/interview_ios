//
//  InterviewQuestionViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 20..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "InterviewQuestionViewController.h"
#import "Interview.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"
#import "NSNumber+NSNumber_Helpers.h"
#import "Constant.h"
#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "InterviewQuestion.h"
#import "QListCell.h"
#import "CoreText/CoreText.h"
#import "UIButton+Position.h"
#import "UIPopoverController+iPhone.h"
#import "ScrapPopoverViewController.h"
#import "Scrap.h"

@interface InterviewQuestionViewController ()

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel1;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel2;
@property (nonatomic, retain) IBOutlet UIImageView *thumbImage;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *questionList;
@property (nonatomic, retain) UIBarButtonItem *scrapButton;
@property (nonatomic, retain) UIPopoverController *scrapPopover;
@property (nonatomic, retain) ScrapPopoverViewController *scrapViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)scrapButtonClick:(id)sender;

@end

@implementation InterviewQuestionViewController

@synthesize scrapButton, titleLabel, infoLabel1, infoLabel2, thumbImage, table;
@synthesize interview, questionList;
@synthesize scrapPopover, scrapViewController;

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
    self.navigationItem.title = @"면접질문";
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
    if(self.interview) {
        [self bindInterviewInfo];
    }
        
    [self initScrapData];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[addButton setTitle:@"추가" forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"big_btn_bg_blue"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"scrap_star_small_on"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(scrapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"스크랩" forState:UIControlStateNormal];
    [addButton centerButtonAndImageWithSpacing:5];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    addButton.frame = CGRectMake(0, 0, 80, 34);
    self.scrapButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    self.navigationItem.rightBarButtonItem = self.scrapButton;
    [addButton release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrapButton = nil;
    self.titleLabel = nil;
    self.infoLabel1 = nil;
    self.infoLabel2 = nil;
    self.thumbImage = nil;
    self.table = nil;
    self.questionList = nil;
    self.scrapPopover = nil;
}

- (void)dealloc {
    
    [scrapButton release];
    [titleLabel release];
    [infoLabel1 release];
    [infoLabel2 release];
    [thumbImage release];
    [table release];
    [questionList release];
    [scrapPopover release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)bindInterviewInfo {
    self.titleLabel.text = self.interview.name;
    self.infoLabel1.text = self.interview.applyField;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileUrl = [NSURL URLWithString:interview.fileUrl];
    
    //동영상파일 시간알아내기
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileUrl];
    
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    NSLog(@"duration: %.2f", seconds);
    
    //NSURL *f = [NSURL URLWithString:interview.fileUrl];
    //NSNumber *fileSize = [Utils fileSize:[f.filePathURL absoluteString]];
    
    
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", interview.filename];
    NSNumber *fileSize = [Utils fileSize:destinationPath];
    
    NSString *fileInfoString = [NSString stringWithFormat:@"%@ (%@)", [Utils convertTimeFromSeconds:seconds], [NSNumber displayFileFormat:fileSize]];
    self.infoLabel2.text = fileInfoString;
    
    self.questionList = [self.interview.interviewQuestion allObjects];
    NSLog(@"questionList =%d", self.questionList.count);
}

- (void)dismissPopover:(int)selectedRow {
    NSLog(@"dismissPopover");
    [self.scrapPopover dismissPopoverAnimated:YES];
    
    //데이타
    
}

- (void)initScrapData {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"Scrap" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    BOOL isExist = NO;
    if(items){
        if (items.count > 0) {
            isExist = YES;
        }
    }
    
    if (isExist == NO) {
        
        for (int i=0; i<3; i++) {
            Scrap *s = [NSEntityDescription insertNewObjectForEntityForName:@"Scrap" inManagedObjectContext:self.managedObjectContext];
            s.name = [NSString stringWithFormat:@"Scrap %d", i+1];
            
            [self.managedObjectContext save:&error];
        }
    }
}


#define PADDING 10.0f
- (CGFloat)cellHeight:(int)row {
    InterviewQuestion *a = [self.questionList objectAtIndex:row];
    CGSize textSize = [a.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    if(textSize.height > 30) {
        return textSize.height + PADDING * 3 - 10;
    } else {
        return textSize.height + PADDING * 3 - 3;
    }
}

- (IBAction)scrapButtonClick:(id)sender {
    /*
    int selectedCount = [[self.table indexPathsForSelectedRows] count];
    NSLog(@"scrapButton selected rows= %d", selectedCount);
    NSArray *selectedRows = [self.table indexPathsForSelectedRows];
    for (int i=0; i<selectedCount; i++) {
        NSLog(@"select object=%@",[selectedRows objectAtIndex:i]);
        
        InterviewQuestion *q = [self.questionList objectAtIndex:[[selectedRows objectAtIndex:i] row]];
        
    }
    */
    ScrapPopoverViewController *scrap = [[ScrapPopoverViewController alloc] initWithNibName:@"ScrapPopoverViewController" bundle:nil];
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:scrap];
    [pop setDelegate:self];
    //[pop presentPopoverFromRect:self.scrapButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    pop.popoverContentSize = CGSizeMake(300, 280);
    
    scrap.parent = self;
    [pop presentPopoverFromBarButtonItem:self.scrapButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.scrapPopover = pop;
    self.scrapViewController = scrap;
    [scrap release];
    [pop release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.questionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"QListCell";
    
    QListCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
        cell = [QListCell cellWithNib];
    }
	
	NSUInteger row = [indexPath row];
	
	if (self.questionList != nil) {
        if(self.questionList.count > 0){
			InterviewQuestion *a = [self.questionList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                /*
                NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                [style setAlignment: NSTextAlignmentJustified];//kCTJustifiedTextAlignment
                
                NSAttributedString * subText1 = [[NSAttributedString alloc] initWithString:a.title attributes:@{
                                                            NSParagraphStyleAttributeName : style
                                                 }];
                
                cell.questionText.attributedText = subText1;
                */
                cell.questionText.text = a.title;
                CGRect checkBoxFrame = cell.checkboxView.frame;
                int rowHeight = [self cellHeight:row];
                checkBoxFrame.origin.y = (rowHeight/2)-(checkBoxFrame.size.height/2);
                cell.checkboxView.frame = checkBoxFrame;
            }
        }
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    InterviewQuestion *a = [self.questionList objectAtIndex:indexPath.row];
    CGSize textSize = [a.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
    
    if(textSize.height > 30) {
        return textSize.height + PADDING * 3 - 10;
    } else {
        return textSize.height + PADDING * 3 - 3;
    }
    */
    return [self cellHeight:[indexPath row]];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
	NSUInteger row = [indexPath row];
	NSDictionary *a = [self.questionList objectAtIndex:row];
    
	InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:nil];
    v.categoryID = self.categoryID;
    v.subCategoryID = [a objectForKey:@"CATEGORY_ID"];
    v.subCategoryName = [a objectForKey:@"CATEGORY_NAME"];
    
	[self.navigationController pushViewController:v animated:YES];
    [v release];
    */
    
}

#pragma mark -
#pragma mark UIPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControlerDidDismissPopover");
    NSLog(@"scrapNo=%d",[popoverController.contentViewController selectedScrapNo]);
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControllerShouldDismissPopover");

    return YES;
}
@end
