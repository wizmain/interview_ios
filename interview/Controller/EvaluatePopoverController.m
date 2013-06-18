//
//  EvaluatePopoverController.m
//  interview
//
//  Created by 김규완 on 13. 4. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "EvaluatePopoverController.h"

@interface EvaluatePopoverController ()
@property (nonatomic, retain) IBOutlet UITableView *table;
@end

@implementation EvaluatePopoverController

@synthesize selectedRow, table, parent;

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
    self.table = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"PopoverCell";
    
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
        cell.textLabel.text = @"종합의견";
    } else if(row == 1) {
        cell.textLabel.text = @"태도진단";
    } else if( row == 2) {
        cell.textLabel.text = @"체크리스트";
    } else if( row == 3) {
        cell.textLabel.text = @"답변평가";
    }
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSLog(@"didSelectRowAtIndexPath");
    self.selectedRow = [indexPath row] + 1;
    if([self.parent respondsToSelector:@selector(dismissPopover:)]) {
        [self.parent dismissPopover:self.selectedRow];
    }
    //[self dismissModalViewControllerAnimated:YES];
}


@end
