//
//  Evaluate1Cell.m
//  interview
//
//  Created by 김규완 on 13. 4. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "Evaluate1Cell.h"

@implementation Evaluate1Cell

@synthesize titleLabel, valueLabel;

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
}

+ (id)cellWithNib
{
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"Evaluate1Cell" bundle:nil];
    Evaluate1Cell *cell = (Evaluate1Cell *)controller.view;
        
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
