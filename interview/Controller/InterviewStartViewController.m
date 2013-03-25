//
//  InterviewStartViewController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "InterviewStartViewController.h"
#import "Constant.h"
#import "HTTPRequest.h"
#import "Category.h"
#import "InterviewInfoViewController.h"
#import "InterviewListController.h"

@interface InterviewStartViewController ()
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *categoryList;
@end

@implementation InterviewStartViewController

@synthesize table;
@synthesize categoryList;

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
    self.navigationItem.title = @"면접분야선택";
    
    [self bindCategory];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.categoryList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Custom Method
- (void) bindCategory {
    Category *category1 = [[Category alloc] init];
    category1.cid = @"ROOT";
    category1.name = @"표준";
    Category *category2 = [[Category alloc] init];
    category2.cid = @"A";
    category2.name = @"유형별";
    Category *category3 = [[Category alloc] init];
    category3.cid = @"B";
    category3.name = @"업직종";
    Category *category4 = [[Category alloc] init];
    category4.cid = @"C";
    category4.name = @"공무원";
    
    self.categoryList = [NSArray arrayWithObjects:category1, category2, category3, category4, nil];
    
    [category1 release];
    [category2 release];
    [category3 release];
    [category4 release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"CategoryCell";
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
	
	if (self.categoryList != nil) {
		
		if(categoryList.count > 0){
			Category *category = [self.categoryList objectAtIndex:row];
            if(category) {
                cell.textLabel.text = category.name;
            }
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    NSLog(@"tableView row = %d", row);
	Category *category = [self.categoryList objectAtIndex:row];
    
    if(row == 0 || row == 3) {
        InterviewInfoViewController *v = [[InterviewInfoViewController alloc] initWithNibName:@"InterviewInfoViewController" bundle:[NSBundle mainBundle]];
        v.categoryID = category.cid;
        
        [self.navigationController pushViewController:v animated:YES];
        //[self.navigationController pushViewController:articleReadController animated:YES];
        //UINavigationController *navi = [[[UINavigationController alloc] initWithRootViewController:v] autorelease];
        //[self presentModalViewController:navi animated:YES];
        
        [v release];
	} else {
        InterviewListController *v = [[InterviewListController alloc] initWithNibName:@"InterviewListController" bundle:nil];
        v.categoryID = category.cid;
        v.categoryName = category.name;
        [self.navigationController pushViewController:v animated:YES];
        [v release];
    }
}

@end
