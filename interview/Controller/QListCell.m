//
//  QListCell.m
//  interview
//
//  Created by 김규완 on 13. 3. 22..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "QListCell.h"

@implementation QListCell

@synthesize questionText, checkboxView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected) {
        [self.checkboxView setImage:[UIImage imageNamed:@"checked2_on"]];
    } else {
        [self.checkboxView setImage:[UIImage imageNamed:@"checked2"]];
    }
}

+ (id)cellWithNib
{
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"QListCell" bundle:nil];
    QListCell *cell = (QListCell *)controller.view;
    
    cell.questionText.contentInset = UIEdgeInsetsMake(-10.0f, -8.0f, 0.0f, -10.0f);
    [cell.questionText addObserver:cell forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    [controller release];
    
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //Bottom vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    //topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

@end
