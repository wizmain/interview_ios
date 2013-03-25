//
//  QListCell.h
//  interview
//
//  Created by 김규완 on 13. 3. 22..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *checkboxView;
@property (nonatomic, retain) IBOutlet UITextView *questionText;

+ (id)cellWithNib;

@end
