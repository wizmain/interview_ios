//
//  UIButton+UIButton_Position.m
//  interview
//
//  Created by 김규완 on 13. 3. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "UIButton+Position.h"

@implementation UIButton (ImageTitleCentering)

-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

@end
