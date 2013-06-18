//
//  MovieListCell.h
//  interview
//
//  Created by 김규완 on 13. 3. 14..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interview;
@protocol MovieListCellDelegate;

@interface MovieListCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel1;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel2;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) Interview *interview;
@property (nonatomic, retain) NSDictionary *data;

@property (nonatomic,assign) id <NSObject,MovieListCellDelegate> delegate;

- (IBAction)button1Click:(id)sender;
- (IBAction)button2Click:(id)sender;
- (IBAction)button3Click:(id)sender;
- (IBAction)button4Click:(id)sender;

+ (id)cellWithNib;
@end


@protocol MovieListCellDelegate <NSObject>
@optional
- (void)movieListCellButton1Click:(MovieListCell *)cell;
- (void)movieListCellButton2Click:(MovieListCell *)cell;
- (void)movieListCellButton3Click:(MovieListCell *)cell;
- (void)movieListCellButton4Click:(MovieListCell *)cell;
@end