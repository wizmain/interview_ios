//
//  SettingsEditViewController.h
//  interview
//
//  Created by 김규완 on 13. 4. 15..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsEditViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSString *settingField;

@end
