//
//  ScrapViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 26..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "ScrapViewController.h"
#import "QListCell2.h"
#import "ScrapQuestion.h"
#import "Scrap.h"
#import "AppDelegate.h"
#import "CoreText/CoreText.h"
#import "UIButton+Position.h"
#import "UIPopoverController+iPhone.h"
#import "ScrapPopoverViewController.h"
#import "InterviewRecordViewController.h"

@interface ScrapViewController ()
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *questionList;
@property (nonatomic, assign) int scrapNo;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *scrapButton;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIPopoverController *scrapPopover;
@property (nonatomic, retain) ScrapPopoverViewController *scrapViewController;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) UIButton *deleteCustom;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *interviewStartButton;

@end

@implementation ScrapViewController

@synthesize table, questionList, managedObjectContext, scrapButton;
@synthesize scrapPopover, scrapViewController;
@synthesize deleteButton, editButton, deleteCustom;

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
    
    _scrapNo = 1;
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
    self.navigationItem.title = [NSString stringWithFormat:@"스크랩 %d", _scrapNo];
    /*
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[addButton setTitle:@"추가" forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"big_btn_bg_blue"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"259-list"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(scrapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[addButton setTitle:@"스크랩선택" forState:UIControlStateNormal];
    [addButton centerButtonAndImageWithSpacing:5];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    addButton.frame = CGRectMake(0, 0, 50, 34);
    self.scrapButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    //self.navigationItem.rightBarButtonItem = self.scrapButton;
    [addButton release];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"big_btn_bg_blue"] forState:UIControlStateNormal];
    //[closeButton setImage:[UIImage imageNamed:@"259-list"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"닫기" forState:UIControlStateNormal];
    [closeButton centerButtonAndImageWithSpacing:5];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    closeButton.frame = CGRectMake(0, 0, 50, 34);
    */
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    //[closeButton release];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[UIBarButtonItem appearance] setTintColor:[UIColor greenColor]];
    /*
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"삭제" style:UIBarButtonItemStyleBordered target:self action:@selector(editScrap:)];
    self.editButton = edit;
    [edit release];
    UIButton *deleteB = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteB setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forState:UIControlStateNormal];
    [deleteB addTarget:self action:@selector(deleteScrap:) forControlEvents:UIControlEventTouchUpInside];
    [deleteB setTitle:@"완료" forState:UIControlStateNormal];
    [deleteB centerButtonAndImageWithSpacing:5];
    deleteB.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    deleteB.frame = CGRectMake(0, 0, 50, 34);
    self.deleteCustom = deleteB;
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithCustomView:self.deleteCustom];
    self.deleteButton = delete;
    [deleteB release];
    [delete release];
    self.navigationItem.rightBarButtonItem = self.editButton;
    */
    
    //스크랩데이타바인드
    [self bindScrapQuestion];
    
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
    self.table = nil;
    self.questionList = nil;
    self.editButton = nil;
    self.deleteButton = nil;
    self.scrapButton = nil;
    self.scrapPopover = nil;
    self.scrapViewController = nil;
    self.managedObjectContext = nil;
    self.deleteCustom = nil;
}

- (void)dealloc {
    
    [table release];
    [questionList release];
    [deleteButton release];
    [editButton release];
    [scrapPopover release];
    [scrapViewController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)bindScrapQuestion {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"Scrap" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scrapNo == %d", _scrapNo];
    [request setPredicate:predicate];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(items){
        if(items.count > 0) {
            Scrap *s = [items objectAtIndex:0];
            NSSet *q = [s scrapQuestion];
            
            NSSortDescriptor *seqDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seq" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:seqDescriptor, nil];
            self.questionList = (NSMutableArray *)[[q allObjects] sortedArrayUsingDescriptors:sortDescriptors];
            //questionList = [[NSMutableArray arrayWithArray:[q allObjects]] retain];
        }
    }
    
    [self.table reloadData];
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
    pop.popoverContentSize = CGSizeMake(400, 280);
    
    scrap.parent = self;
    [pop presentPopoverFromBarButtonItem:self.scrapButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    self.scrapPopover = pop;
    self.scrapViewController = scrap;
    [scrap release];
    [pop release];
}

- (IBAction)interviewStart:(id)sender {
    
    NSMutableArray *qList = [[NSMutableArray alloc] initWithCapacity:self.questionList.count];
    if (self.questionList) {
        for (int i=0;i<self.questionList.count; i++) {
            ScrapQuestion *sq = [self.questionList objectAtIndex:i];
            NSString *qNoStr = [NSString stringWithFormat:@"%d", [sq.qno intValue]];
            NSString *elapsedTimeStr = [NSString stringWithFormat:@"%d", [sq.elapsedTime intValue]];
            NSDictionary *q = [NSDictionary dictionaryWithObjectsAndKeys:sq.title, @"Q_TITLE", qNoStr, @"Q_NO", sq.filename, @"Q_FILENAME", sq.categoryID, @"CATEGORY_ID", elapsedTimeStr, @"ELAPSED_TIME", nil];
            [qList insertObject:q atIndex:i];
        }
    }
    
    InterviewRecordViewController *interview = [[InterviewRecordViewController alloc] initWithNibName:@"InterviewRecordViewController" bundle:nil];
    interview.questionList = qList;
    [self presentModalViewController:interview animated:NO];
    [interview release];
    
    //인터뷰시작 작업 mainview에서 시작하는 걸로 변경
}

- (void)dismissPopover:(int)selectedRow {
    _scrapNo = selectedRow;
    self.navigationItem.title = [NSString stringWithFormat:@"스크랩 %d", _scrapNo];
    [self.scrapPopover dismissPopoverAnimated:YES];
    [self bindScrapQuestion];

}


- (void)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)editScrap:(id)sender {
    _isEditing = YES;
    self.navigationItem.rightBarButtonItem = self.deleteButton;
    
    [self.table reloadData];

}

- (void)deleteScrap:(id)sender {
    int selectedCount = [[self.table indexPathsForSelectedRows] count];
    NSLog(@"deleteScrap selected rows= %d", selectedCount);
    
    NSArray *selectedRows = [self.table indexPathsForSelectedRows];
    
    for (int i=0; i<selectedCount; i++) {
        NSLog(@"select object=%@",[selectedRows objectAtIndex:i]);
        
        ScrapQuestion *q = [self.questionList objectAtIndex:[[selectedRows objectAtIndex:i] row]];
        
        [self.managedObjectContext deleteObject:q];
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    self.navigationItem.rightBarButtonItem = self.editButton;
    _isEditing = NO;
    
    [self bindScrapQuestion];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.questionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"QListCell2";
    
    QListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
        cell = [QListCell2 cellWithNib];
    }
    NSUInteger row = indexPath.row;
    
	if (self.questionList != nil) {
        if(self.questionList.count > 0){
			ScrapQuestion *a = [self.questionList objectAtIndex:row];
            NSLog(@"a=%@", a);

            if(a){
                cell.questionText.text = a.title;
                cell.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
                CGRect checkBoxFrame = cell.numberLabel.frame;
                int rowHeight = [self cellHeight:indexPath.row];
                checkBoxFrame.origin.y = (rowHeight/2)-(checkBoxFrame.size.height/2);
                cell.numberLabel.frame = checkBoxFrame;
                
            }
        }
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    NSLog(@"setEditing");
    
    _isEditing = editing;
    
    [super setEditing:editing animated:animated];
    
    [self.table setEditing:editing animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // remove the row here.
        NSLog(@"Delete Click");
        NSUInteger row = [indexPath row];
        
        
        
        ScrapQuestion *item = [self.questionList objectAtIndex:row];
        NSLog(@"delete item = %@", item);
        
        
        //실제 삭제
        [self.managedObjectContext deleteObject:item];
        
        // Save
        NSError *error;
        if ([self.managedObjectContext save:&error] == NO) {
            // Handle Error.
        }
        
        
        [self bindScrapQuestion];

        //[self.questionList removeObject:item];
        //[self.table reloadData];

    }
}

#define PADDING 10.0f
- (CGFloat)cellHeight:(int)row {
    int minusWidth = 20;
    
    ScrapQuestion *a = [self.questionList objectAtIndex:row];
    CGSize textSize = [a.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - minusWidth) - PADDING * 3, 1000.0f)];
    
    if(textSize.height > 30) {
        return textSize.height + PADDING * 3 - 10;
    } else {
        return textSize.height + PADDING * 3 - 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ScrapQuestion *a = [self.questionList objectAtIndex:indexPath.row];
    CGSize textSize = [a.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake((self.table.frame.size.width - 20) - PADDING * 3, 1000.0f)];
     
    if(textSize.height > 30) {
        return textSize.height + PADDING * 3 - 10;
    } else {
        return textSize.height + PADDING * 3 - 3;
    }
    
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        // Delete row from tableView.
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark UIPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControlerDidDismissPopover");
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControllerShouldDismissPopover");
    
    return YES;
}

@end
