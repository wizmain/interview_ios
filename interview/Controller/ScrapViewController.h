//
//  ScrapViewController.h
//  interview
//
//  Created by 김규완 on 13. 3. 26..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapPopoverViewController.h"

@interface ScrapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, PopoverClose, NSFetchedResultsControllerDelegate>
- (void)dismissPopover:(int)selectedRow;
@end
