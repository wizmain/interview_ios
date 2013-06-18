//
//  SettingsEditViewController.m
//  interview
//
//  Created by 김규완 on 13. 4. 15..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "SettingsEditViewController.h"
#import "Utils.h"
#import "SettingProperties.h"

@interface SettingsEditViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textfield;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) SettingProperties *settings;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *sexPicker;
@end

@implementation SettingsEditViewController
@synthesize textfield, label, saveButton, settingField, settings, actionSheet, datePicker, sexPicker;

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
    
    self.navigationItem.title = @"설정내용수정";
    CGRect frameRect = textfield.frame;
    frameRect.size.height = 40;
    textfield.frame = frameRect;
    
    textfield.delegate = self;
    
    self.settings = [Utils settingProperties];
    
    if (self.settings == nil) {
        NSLog(@"settings nil");
        settings = [[SettingProperties alloc] init];
    }
        
    if ([self.settingField isEqualToString:@"userName"]) {
        self.label.text = @"이름";
        self.textfield.text = self.settings.userName;
    } else if ([self.settingField isEqualToString:@"schoolName"]) {
        self.label.text = @"학교";
        self.textfield.text = self.settings.schoolName;
    } else if ([self.settingField isEqualToString:@"majorName"]) {
        self.label.text = @"전공";
        self.textfield.text = self.settings.majorName;
    } else if ([self.settingField isEqualToString:@"hakbun"]) {
        self.label.text = @"학번";
        self.textfield.text = self.settings.hakbun;
        [self.textfield setKeyboardType:UIKeyboardTypeNumberPad];
    } else if ([self.settingField isEqualToString:@"applyField"]) {
        self.textfield.text = self.settings.applyField;
        self.label.text = @"지원분야";
    } else if ([self.settingField isEqualToString:@"userSex"]) {
        self.label.text = @"성별";
        self.textfield.text = self.settings.userSex;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        sexPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        sexPicker.dataSource = self;
        sexPicker.delegate = self;
        
        [actionSheet addSubview:sexPicker];
        UIToolbar *actionSheetToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        actionSheetToolbar.barStyle = UIBarStyleBlackOpaque;
        [actionSheetToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:spacer];
        [spacer release];
        
        /*
         UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
         [barItems addObject:cancel];
         [cancel release];
         */
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideDatePicker:)];
        [barItems addObject:done];
        [done release];
        
        [actionSheetToolbar setItems:barItems];
        [barItems release];
        
        [actionSheet addSubview:actionSheetToolbar];
    } else if ([self.settingField isEqualToString:@"userAge"]) {
        self.label.text = @"나이";
        self.textfield.text = self.settings.userAge;
        [self.textfield setKeyboardType:UIKeyboardTypeNumberPad];
    } else if ([self.settingField isEqualToString:@"answerTerm"]) {
        [self.textfield setKeyboardType:UIKeyboardTypeNumberPad];
        self.label.text = @"면접답변시간(초단위)";
        self.textfield.text = self.settings.answerTerm;
    } else if ([self.settingField isEqualToString:@"birthDay"]) {
        self.label.text = @"생일";
        self.textfield.text = self.settings.birthDay;
        //날짜 설정용 datePicker설정
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date = [[NSDate alloc] init];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [actionSheet addSubview:datePicker];
        
        UIToolbar *actionSheetToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        actionSheetToolbar.barStyle = UIBarStyleBlackOpaque;
        [actionSheetToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:spacer];
        [spacer release];
        
        /*
         UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
         [barItems addObject:cancel];
         [cancel release];
         */
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideDatePicker:)];
        [barItems addObject:done];
        [done release];
        
        [actionSheetToolbar setItems:barItems];
        [barItems release];
        
        [actionSheet addSubview:actionSheetToolbar];
    } else if ([self.settingField isEqualToString:@"userAge"]) {
        self.label.text = @"나이";
        self.textfield.text = self.settings.hakbun;
        [self.textfield setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    [self.saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.textfield = nil;
    self.label = nil;
    self.saveButton = nil;
}

- (void)saveButtonClick:(id)sender {
    
    SettingProperties *s = [[SettingProperties alloc] init];
    
    s.userName = self.settings.userName;
    s.schoolName = self.settings.schoolName;
    s.majorName = self.settings.majorName;
    s.hakbun = self.settings.hakbun;
    s.applyField = self.settings.applyField;
    s.userSex = self.settings.userSex;
    s.userAge = self.settings.userAge;
    s.answerTerm = self.settings.answerTerm;
    s.birthDay = self.settings.birthDay;
    
    if ([self.settingField isEqualToString:@"userName"]) {
        [s setUserName:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"schoolName"]) {
        [s setSchoolName:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"majorName"]) {
        [s setMajorName:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"hakbun"]) {
        [s setHakbun:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"applyField"]) {
        [s setApplyField:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"userSex"]) {
        [s setUserSex:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"userAge"]) {
        [s setUserAge:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"answerTerm"]) {
        [s setAnswerTerm:self.textfield.text];
    } else if ([self.settingField isEqualToString:@"birthDay"]) {
        [s setBirthDay:self.textfield.text];
    }
    
    NSLog(@"answerTerm=%@ s = %@", self.self.textfield.text, s.answerTerm);
    
    [Utils saveSettingProperties:s];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showDatePicker:(id)sender {
    
    //UITextField *textField = (UITextField *)sender;
    
    [actionSheet bringSubviewToFront:datePicker];
    
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    //[actionSheet showFromTabBar:super.view.tabBarController];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 500)];
    
}

- (void)hideDatePicker:(id)sender {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dateChanged:(id)sender {
    NSLog(@"dateChanged");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"date = %@",[formatter stringFromDate:[datePicker date]]);
    
    self.textfield.text = [formatter stringFromDate:[datePicker date]];
    [formatter release];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([self.settingField isEqualToString:@"birthDay"]) {
    
        [textField resignFirstResponder];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = self.textfield.text;
        if ([Utils isNullString:dateString]) {
            NSDate *today = [NSDate date];
            
            dateString = [NSString stringWithFormat:@"%@", [dateFormater stringFromDate:today]];
        } else {
            dateString = self.textfield.text;
        }
        
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormater dateFromString:dateString];
        
        datePicker.date = dateFromString;
        
        [dateFormater release];
        
        [self showDatePicker:textField];
    } else if ([self.settingField isEqualToString:@"userSex"]) {
        [textField resignFirstResponder];
        [self showDatePicker:textField];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.textfield resignFirstResponder];
    
}

// 필수 사용메소드 2개 : 이 작업을 하면 피커에 데이터가 들어간다.
// 피커를 사용하기 위해 반드시 사용되어야 할 필수 메소드이다.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// 피커를 사용하기 위해 반드시 사용되어야 할 필수 메소드이다.
- (NSInteger)pickerView:(UIPickerView *) pickerView numberOfRowsInComponent : (NSInteger)component{
	if (component == 0) {
		return 2;
	} else {
        return 2;
    }
}

// 피커를 사용하기 위해 반드시 사용되어야 할 필수 델리게이트이다.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component{
	if (row == 0) {
        return @"남";
    } else {
        return @"여";
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.textfield.text = @"남";
    } else if (row == 1){
        self.textfield.text = @"여";
    }
}


@end
