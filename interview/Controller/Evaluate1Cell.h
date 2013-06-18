//
//  Evaluate1Cell.h
//  interview
//
//  Created by 김규완 on 13. 4. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Evaluate1Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

+ (id)cellWithNib;

@end
