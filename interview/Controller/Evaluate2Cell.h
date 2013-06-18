//
//  Evaluate2Cell.h
//  interview
//
//  Created by 김규완 on 13. 4. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Evaluate2Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextView *questionText;
@property (nonatomic, retain) IBOutlet UITextView *evaluateText;

+ (id)cellWithNib;

@end
