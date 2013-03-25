//
//  MovieListController.h
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MovieListController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
