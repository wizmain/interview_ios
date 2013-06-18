//
//  ScrapPopoverViewController.m
//  interview
//
//  Created by 김규완 on 13. 3. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "ScrapPopoverViewController.h"
#import "UIPopoverController+iPhone.h"
#import "InterviewQuestionViewController.h"

@interface ScrapPopoverViewController ()
@property (nonatomic, retain) IBOutlet UITableView *table;
@end

@implementation ScrapPopoverViewController

@synthesize parent;
@synthesize selectedScrapNo;

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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
}

/*
- (void)dealloc {
    
    [_table release];
    [super dealloc];
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"ScrapCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        UIImage *img = [UIImage imageNamed:@"15-tags"];
		cell.imageView.image = img;
        [img release];
	}
    int row = [indexPath row];
	if (row == 0) {
        cell.textLabel.text = @"스크랩 1";
    } else if(row == 1) {
        cell.textLabel.text = @"스크랩 2";
    } else if( row == 2) {
        cell.textLabel.text = @"스크랩 3";
    }
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate
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
    NSLog(@"didSelectRowAtIndexPath");
    self.selectedScrapNo = [indexPath row] + 1;
    if([self.parent respondsToSelector:@selector(dismissPopover:)]) {
        [self.parent dismissPopover:self.selectedScrapNo];
    }
    //[self dismissModalViewControllerAnimated:YES];
}


@end
