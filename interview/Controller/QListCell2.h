//
//  QListCell2.h
//  interview
//
//  Created by 김규완 on 13. 3. 29..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QListCell2 : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *numberLabel;
@property (nonatomic, retain) IBOutlet UITextView *questionText;

+ (id)cellWithNib;

@end
