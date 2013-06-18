//
//  SettingsController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "SettingsController.h"
#import "SettingProperties.h"
#import "Utils.h"
#import "SettingsEditViewController.h"

@interface SettingsController ()
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) SettingProperties *settings;
@end

@implementation SettingsController
@synthesize table, settings;

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
    self.navigationItem.title = @"설정";
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.settings = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindSettings];
}

- (void)dealloc {
    [settings release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark Custom Method 
- (void)bindSettings {
    NSLog(@"bindSettings");
    self.settings = [Utils settingProperties];
    NSLog(@"setting answerTerm = %@", self.settings.answerTerm);
    if(self.settings == nil){
        NSLog(@"settings properites nil");
        settings = [[SettingProperties alloc] init];
    }
    
    [self.table reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {//면접설정정보
        return 1;
    } else if(section == 1) {//기본정보
        return 7;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
    /*
    if([indexPath section] == 0) {//과제명
        return 42;
    } else if([indexPath section] == 1) {//제출기한
        return 65;
    } else if([indexPath section] == 2) {//
        return 42;
    } else if ([indexPath section] == 3) {
        return 42;
    } else {
        return 42;
    }
    */
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return @"면접설정정보";
    } else {
        return @"기본정보";
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
    
    if(section == 0) {
        label.text = @"면접설정정보";
        
    } else if(section == 1) {
        label.text = @"기본정보";
        
    } else {
        //label.text =  @"";
    }
    
    //label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    label.textColor = UIColorFromRGB(0x0656a7);
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    //if (section == 0)
    //    [headerView setBackgroundColor:[UIColor redColor]];
    //else
    //    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"CustomLectureCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
    if(cell == nil){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									   reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
	if ([indexPath section] == 0) {
	
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = [NSString stringWithFormat:@"면접답변시간 : %@초", self.settings.answerTerm];
        
    } else if([indexPath section] == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"이름";
            //cell.textLabel.text = [NSString stringWithFormat:@"이름 : %@", self.settings.userName];
            cell.detailTextLabel.text = self.settings.userName;
        } else if ([indexPath row] == 1) {
            cell.textLabel.text = @"성별";
            cell.detailTextLabel.text = self.settings.userSex;
            //cell.textLabel.text = [NSString stringWithFormat:@"성별 : %@", self.settings.userSex];
        } else if ([indexPath row] == 2) {
            cell.textLabel.text = @"나이";
            cell.detailTextLabel.text = self.settings.userAge;
            //cell.textLabel.text = [NSString stringWithFormat:@"나이 : %@", self.settings.userAge];
        } else if ([indexPath row] == 3) {
            cell.textLabel.text = @"생년월일";
            //cell.textLabel.text = [NSString stringWithFormat:@"생년월일 : %@", self.settings.birthDay];
            cell.detailTextLabel.text = self.settings.birthDay;
        } else if ([indexPath row] == 4) {
            cell.textLabel.text = @"학교";
            cell.detailTextLabel.text = self.settings.schoolName;
            //cell.textLabel.text = [NSString stringWithFormat:@"학교 : %@", self.settings.schoolName];
        } else if ([indexPath row] == 5) {
            cell.textLabel.text = @"전공";
            cell.detailTextLabel.text = self.settings.majorName;
            //cell.textLabel.text = [NSString stringWithFormat:@"전공 : %@", self.settings.majorName];
        } else if ([indexPath row] == 6) {
            cell.textLabel.text = @"지원분야";
            cell.detailTextLabel.text = self.settings.applyField;
            //cell.textLabel.text = [NSString stringWithFormat:@"지원분야 : %@", self.settings.applyField];
        }
        
	}
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([indexPath section] == 0){
        if ([indexPath row] == 0) {
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"answerTerm";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        }
    } else if ([indexPath section] == 1){
        if ([indexPath row] == 0) {
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"userName";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 1){
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"userSex";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 2){
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"userAge";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 3){
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"birthDay";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 4){
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"schoolName";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 5){
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"majorName";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        } else if([indexPath row] == 6) {
            SettingsEditViewController *edit = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            edit.settingField = @"applyField";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
        }
    }
}


@end
