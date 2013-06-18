//
//  MovieListCell.m
//  interview
//
//  Created by 김규완 on 13. 3. 14..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MovieListCell.h"
#import "AlertUtils.h"
#import "Constant.h"

@implementation MovieListCell

@synthesize thumbnailImageView;
@synthesize titleLabel;
@synthesize infoLabel1, infoLabel2;
@synthesize button1, button2, button3, button4;
@synthesize delegate;
@synthesize interview;
@synthesize data;

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
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"MovieListCell" bundle:nil];
    MovieListCell *cell = (MovieListCell *)controller.view;
    
    [controller release];
    
    return cell;
}


- (void)dealloc
{
    self.thumbnailImageView = nil;
    self.titleLabel = nil;
    self.infoLabel1 = nil;
    self.infoLabel2 = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.interview = nil;

    [thumbnailImageView release];
    [titleLabel release];
    [infoLabel1 release];
    [infoLabel2 release];
    [button1 release];
    [button2 release];
    [button3 release];
    [button4 release];
    
    [super dealloc];
    
}

- (IBAction)button1Click:(id)sender {
    if ([delegate respondsToSelector:@selector(movieListCellButton1Click:)]) {
        [delegate movieListCellButton1Click:self];
    }
}

- (IBAction)button2Click:(id)sender {
    if ([delegate respondsToSelector:@selector(movieListCellButton2Click:)]) {
        [delegate movieListCellButton2Click:self];
    }
}

- (IBAction)button3Click:(id)sender {
    if ([delegate respondsToSelector:@selector(movieListCellButton3Click:)]) {
        [delegate movieListCellButton3Click:self];
    }
}

- (IBAction)button4Click:(id)sender {
    //AlertWithMessageAndDelegate(kAppName, @"삭제하시겠습니까?", self);
    if ([delegate respondsToSelector:@selector(movieListCellButton4Click:)]) {
        [delegate movieListCellButton4Click:self];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%d", buttonIndex);
        
        if(buttonIndex == 0){
            
        } else if(buttonIndex == 1) {
            if ([delegate respondsToSelector:@selector(movieListCellButton4Click:)]) {
                [delegate movieListCellButton4Click:self];
            }
        } else if(buttonIndex == 2) {
            
        }
    
}
@end
