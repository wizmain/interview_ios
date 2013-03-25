//
//  RecordReadyController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "RecordReadyController.h"
#import "AppDelegate.h"
#import "InterviewRecordViewController.h"
#import "UITextFieldCell.h"
#import "UITextViewCell.h"
#import "SettingProperties.h"
#import "Utils.h"
#import "AVCamViewController.h"
#import "InterviewRecord2ViewController.h"
#import "TestViewController.h"

@interface RecordReadyController ()
@property (nonatomic, retain) IBOutlet UIButton *recordStartButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *resignTextFieldButton;
@property (nonatomic, retain) UIBarButtonItem *contentEditDoneButton;
@property (nonatomic, retain) SettingProperties *setting;
@property (nonatomic, assign) int selectedSection;
@property (nonatomic, retain) UITextField *userNameText;
@property (nonatomic, retain) UITextField *userSexText;
@property (nonatomic, retain) UITextField *userAgeText;
@property (nonatomic, retain) UITextField *userSchoolText;
@property (nonatomic, retain) UITextField *userMajorText;
@property (nonatomic, retain) UITextField *applyFieldText;

- (IBAction)recordStart:(id)sender;
@end

@implementation RecordReadyController

@synthesize table;
@synthesize recordStartButton, contentEditDoneButton;
@synthesize setting;
@synthesize selectedSection;
@synthesize categoryID;
@synthesize userNameText, userSexText, userAgeText, userMajorText, applyFieldText, userSchoolText;

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
    //[[AppDelegate sharedAppDelegate] setRotate:YES];
    /*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInterview:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    [closeButton release];
    
    contentEditDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(contentEditDone:)];
    
    
    self.navigationItem.rightBarButtonItem = contentEditDoneButton;
    [contentEditDoneButton release];
    */
    
    self.navigationItem.title = @"인터뷰정보";
    self.setting = [Utils settingProperties];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.recordStartButton = nil;
    self.contentEditDoneButton = nil;
    self.setting = nil;
    self.categoryID = nil;
    
    self.userSchoolText = nil;
    self.userNameText = nil;
    self.userAgeText = nil;
    self.userSexText = nil;
    self.applyFieldText = nil;
    self.userMajorText = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    
    /*
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        return YES;
    }
    else {
        return NO;
    }
    */
    

}
    
#pragma mark -
#pragma mark Custom Method

- (void)cancelInterview:(id)sender
{
    
    //[self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)recordStart:(id)sender
{
    
    SettingProperties *s = [[SettingProperties alloc] init];
    
    s.userName = userNameText.text;
    s.userAge = userAgeText.text;
    s.userSex = userSexText.text;
    s.majorName = userMajorText.text;
    s.applyField = applyFieldText.text;
    s.schoolName = userSchoolText.text;
    
    [Utils saveSettingProperties:s];
    
    InterviewRecordViewController *interview = [[InterviewRecordViewController alloc] initWithNibName:@"InterviewRecordViewController" bundle:nil];
    interview.categoryID = self.categoryID;
    //TestViewController *interview = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    [self presentModalViewController:interview animated:NO];
    [interview release];
    
    //AVCamViewController *a = [[AVCamViewController alloc] initWithNibName:@"AVCamViewController" bundle:nil];
    //[self presentModalViewController:a animated:YES];
    //[a release];
}

#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
    //[table reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    selectedSection = textField.tag;
    NSLog(@"textFieldDidBeginEditing selectedSection = %d", selectedSection);
    
	//[self.view bringSubviewToFront:resignTextFieldButton];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	selectedSection = 0;
	[textField resignFirstResponder];
    
    /*
    if ([textField.text isEqualToString:@"#%#"]) {
        [NSException raise:@"Test exception" format:@"Nothing bad, actually"];
    }
	*/
	//[table reloadData];
}

#pragma mark -
#pragma mark UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"textViewDidBeginEditing");
    /*
	selectedSection = 4;
	
    UITableViewCell *cell = (UITableViewCell*) [[textView superview] superview];
    [self.table scrollToRowAtIndexPath:[table indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	NSLog(@"scrollToRowAtIndexPath:%@", [table indexPathForCell:cell]);
    
    self.navigationItem.rightBarButtonItem = contentEditDoneButton;
    */
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    /*
	NSLog(@"textViewDidEndEditing");
	
	selectedSection = 0;
	
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			contentText = [(UITextView *)subview retain];
			break;
		}
	}
	
	[self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	[textView resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    */
	//[table reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;//몇개의 섹션으로 이루어져 있다
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int result = 1;
	
    /*
	switch (section) {
		case 0://title섹션일때 테이블 row 수
			result = 1;
			break;
		case 1://내용 섹션일 때 테이블 row 수
			result = 2;
			break;
        case 2:
            result = 1;
		default:
			break;
	}
	*/
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int result = 45;
	/*
	switch (indexPath.section) {
		case 0:
			result = 45;
			break;
        case 1:
            result = 45;
            break;
		case 2:
			result = 45;
			break;
		default:
			break;
	}
	*/
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//타이틀
	UITextFieldCell *textCell = (UITextFieldCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
	if (textCell == nil) {
        textCell = [UITextFieldCell createNewTextCellFromNib];
    }
	
	//내용
	UITextViewCell *contentCell = (UITextViewCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
	if (contentCell == nil) {
        contentCell = [UITextViewCell createNewTextCellFromNib];
    }
        
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"이름";
					textCell.textField.placeholder = @"이름";
					textCell.textField.tag = 1;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
					
					if(self.setting)
						textCell.textField.text = self.setting.userName;
					
                    userNameText = [textCell.textField retain];
                    
					cell = textCell;
					break;
				default:
					break;
			}
			
			break;
        case 1:
        {
            switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"성별";
					textCell.textField.placeholder = @"성별";
					textCell.textField.tag = 2;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.setting){
                        textCell.textField.text = self.setting.userSex;
                    }
					userSexText = [textCell.textField retain];
					cell = textCell;
					break;
                    
				default:
					break;
			}
			
			break;
            
            
        }
		case 2:
        {
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"나이";
					textCell.textField.placeholder = @"나이";
					textCell.textField.tag = 3;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.setting){
                        textCell.textField.text = self.setting.userSex;
                    }
					userAgeText = [textCell.textField retain];
					cell = textCell;
					break;
                    
				default:
					break;
			}
			
			break;
        }
        case 3:
        {
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"학교";
					textCell.textField.placeholder = @"학교";
					textCell.textField.tag = 3;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.setting){
                        textCell.textField.text = self.setting.schoolName;
                    }
					userSchoolText = [textCell.textField retain];
					cell = textCell;
					break;
                    
				default:
					break;
			}
			
			break;
        }
        case 4:
        {
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"전공";
					textCell.textField.placeholder = @"전공";
					textCell.textField.tag = 4;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.setting){
                        textCell.textField.text = self.setting.majorName;
                    }
					userMajorText = [textCell.textField retain];
					cell = textCell;
					break;
                    
				default:
					break;
			}
			
			break;
        }
        case 5:
        {
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"지원분야";
					textCell.textField.placeholder = @"지원분야";
					textCell.textField.tag = 5;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.setting){
                        textCell.textField.text = self.setting.applyField;
                    }
					applyFieldText = [textCell.textField retain];
					cell = textCell;
					break;
                    
				default:
					break;
			}
			
			break;
        }
            
		default:
			break;
	}
    
    //[textCell release];
    //[contentCell release];
    
    return cell;
}


@end
