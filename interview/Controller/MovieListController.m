//
//  MovieListController.m
//  interview
//
//  Created by 김규완 on 12. 7. 31..
//  Copyright (c) 2012년 김규완. All rights reserved.
//

#import "MovieListController.h"
#import "AppDelegate.h"
#import "MovieListCell.h"
#import "Interview.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "Utils.h"
#import "NSNumber+NSNumber_Helpers.h"
#import "UIImage+Round.h"
#import "Constant.h"
#import "AlertUtils.h"
#import "ImageCache.h"
#import "MovieViewController.h"
#import "MainViewController.h"
#import "InterviewQuestionViewController.h"

#define kMovieListCellHeight    115

@interface MovieListController () <MovieListCellDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@interface MovieListController ()
@property NSMutableDictionary *imageCache;
@end

@implementation MovieListController {
    dispatch_queue_t imageQueue;
}

@synthesize table, imageCache;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    imageQueue = dispatch_queue_create("com.coelsoft.interview.imageQueue", NULL);
    imageCache = [[NSMutableDictionary alloc] init];
    self.navigationItem.title = @"영상보기";
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[addButton setTitle:@"추가" forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"20-gear"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    [addButton release];
    
    
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    //fetch
    [self reloadFetch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.fetchedResultsController = nil;
    self.imageCache = nil;
    dispatch_release(imageQueue);
}

- (void)dealloc {
    [_fetchedResultsController release];
    [imageCache release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Custom Method
- (void)deleteAll:(id)sender {
    NSLog(@"DeleteAll");
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"InterviewQuestion" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interviewQuestion=%@", item);
        [self.managedObjectContext deleteObject:item];
    }
    
    entiryDescription = [NSEntityDescription entityForName:@"Interview" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];

    items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    [request release];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interview=%@", item);
        [self.managedObjectContext deleteObject:item];

    }
    
    [self reloadFetch];
    [self.table reloadData];
    
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
    }
    
    
}

- (void)reloadFetch {
    NSLog(@"performFetch");
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)deleteInterview:(MovieListCell *)cell {

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", cell.interview.filename];
    NSLog(@"destinationPath=%@", destinationPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];

    Interview *interview = [[self fetchedResultsController] objectAtIndexPath:[self.table indexPathForCell:cell]];
    NSError *error = nil;

    if ([fileManager fileExistsAtPath:destinationPath]) {
        NSLog(@"file exist");
        if ([fileManager removeItemAtPath:destinationPath error:&error] != YES) {
            NSLog(@"Unable to delete file %@", [error localizedDescription]);
        } else {
            
            NSLog(@"delete start1");
            [self.managedObjectContext deleteObject:interview];
            [self reloadFetch];
            [self.table reloadData];
            if (![self.managedObjectContext save:&error])
            {
                NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
            }
            NSLog(@"delete end1");
        }
        
    } else {
        NSLog(@"file not exist");
        [self.managedObjectContext deleteObject:interview];
        [self reloadFetch];
        [self.table reloadData];
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
        }
        NSLog(@"delete end2");
    }
}

#pragma mark -
#pragma mark Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Interview" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"regdate" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"name" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    // Memory management.
    
    [fetchRequest release];
    [dateDescriptor release];
    [sortDescriptors release];
    
    return _fetchedResultsController;
}

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.table beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.table insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            NSString *sectionKeyPath = [controller sectionNameKeyPath];
            if (sectionKeyPath == nil)
                break;
            NSManagedObject *changedObject = [controller objectAtIndexPath:indexPath];
            NSArray *keyParts = [sectionKeyPath componentsSeparatedByString:@"."];
            id currentKeyValue = [changedObject valueForKeyPath:sectionKeyPath];
            for (int i = 0; i < [keyParts count] - 1; i++) {
                NSString *onePart = [keyParts objectAtIndex:i];
                changedObject = [changedObject valueForKey:onePart];
            }
            sectionKeyPath = [keyParts lastObject];
            NSDictionary *committedValues = [changedObject committedValuesForKeys:nil];
            
            if ([[committedValues valueForKeyPath:sectionKeyPath] isEqual:currentKeyValue])
                break;
            
            NSUInteger tableSectionCount = [self.table numberOfSections];
            NSUInteger frcSectionCount = [[controller sections] count];
            if (tableSectionCount != frcSectionCount) {
                // Need to insert a section
                NSArray *sections = controller.sections;
                NSInteger newSectionLocation = -1;
                for (id oneSection in sections) {
                    NSString *sectionName = [oneSection name];
                    if ([currentKeyValue isEqual:sectionName]) {
                        newSectionLocation = [sections indexOfObject:oneSection];
                        break;
                    }
                }
                if (newSectionLocation == -1)
                    return; // uh oh
                
                if (!((newSectionLocation == 0) && (tableSectionCount == 1) && ([self.table numberOfRowsInSection:0] == 0)))
                    [self.table insertSections:[NSIndexSet indexSetWithIndex:newSectionLocation] withRowAnimation:UITableViewRowAnimationFade];
                NSUInteger indices[2] = {newSectionLocation, 0};
                newIndexPath = [[[NSIndexPath alloc] initWithIndexes:indices length:2] autorelease];
            }
        }
        case NSFetchedResultsChangeMove:
            if (newIndexPath != nil) {
                
                NSUInteger tableSectionCount = [self.table numberOfSections];
                NSUInteger frcSectionCount = [[controller sections] count];
                if (frcSectionCount > tableSectionCount)
                    [self.table insertSections:[NSIndexSet indexSetWithIndex:[newIndexPath section]] withRowAnimation:UITableViewRowAnimationNone];
                else if (frcSectionCount < tableSectionCount && tableSectionCount > 1)
                    [self.table deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationNone];
                
                
                [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.table insertRowsAtIndexPaths: [NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation: UITableViewRowAnimationRight];
                
            }
            else {
                [self.table reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            if (!((sectionIndex == 0) && ([self.table numberOfSections] == 1)))
                [self.table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            if (!((sectionIndex == 0) && ([self.table numberOfSections] == 1) ))
                [self.table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.table endUpdates];
    
    //[self.table reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    numberOfRows = [sectionInfo numberOfObjects];
    return numberOfRows;
}

#pragma mark -
#pragma mark Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"MovieListCell";
    MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
	if (cell == nil) {
        cell = [MovieListCell cellWithNib];
	}
	
	//NSUInteger row = [indexPath row];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell to show the book's title
    Interview *interview = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //NSLog(@"configureCell %@", interview);
    
    
    MovieListCell *movieListCell = (MovieListCell *)cell;
    movieListCell.titleLabel.text = interview.name;
    movieListCell.infoLabel1.text = interview.applyField;
    movieListCell.interview = interview;
    //
    /*
    if(interview.regdate){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        NSString *messageDate = [formatter stringFromDate:interview.regdate];
        movieListCell.titleLabel.text = messageDate;
        [formatter release];
    }
    */
    NSLog(@"fileUrl=%@",interview.fileUrl);
    
    //도큐먼트 디렉토리
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileUrl = [NSURL URLWithString:interview.fileUrl];
    
    //Thumbnail
    /*
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    [asset release];
    CMTime thumbTime = CMTimeMakeWithSeconds(0,1);
    
    //CGSize maxSize = CGSizeMake(320, 180);
    CGSize maxSize = CGSizeMake(80, 80);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        //[button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
        //UIImage *thumbImg = [[UIImage imageWithCGImage:im] retain];

        //image radius
        //[movieListCell.thumbnailImageView setImage:[[UIImage imageWithCGImage:im] imageScaledToSize:maxSize]];
        [movieListCell.thumbnailImageView setImage:[UIImage imageWithCGImage:im]];
        [generator release];
    };
    
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    */
    
    
    //썸네일 이미지 미리 저장된 이미지로
    NSString *thumbPath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, interview.filename];
    NSLog(@"thumbPath=%@", thumbPath);
    //UIImage *thumbImg = [UIImage imageWithContentsOfFile:thumbPath];
    //[movieListCell.thumbnailImageView setImage:thumbImg];
    //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbPath]];
    
    //if ([[ImageCache sharedImageCache] isExist:interview.filename]) {
    if ([self.imageCache objectForKey:interview.filename] != nil) {
        //UIImage *thumbImg = [[ImageCache sharedImageCache] getImage:interview.filename];
        UIImage *thumbImg = [self.imageCache objectForKey:interview.filename];
        [movieListCell.thumbnailImageView setImage:thumbImg];
        NSLog(@"use cache");
    } else {
        NSLog(@"use image load");
        dispatch_async(imageQueue, ^{
            UIImage *thumbImg = [UIImage imageWithContentsOfFile:thumbPath];
            //[[ImageCache sharedImageCache] addImage:interview.filename image:thumbImg];
            [self.imageCache setValue:thumbImg forKey:interview.filename];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [movieListCell.thumbnailImageView setImage:thumbImg];
                //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
        
    
    //동영상파일 시간알아내기
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileUrl];
    
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    NSLog(@"duration: %.2f", seconds);
    
    //NSURL *f = [NSURL URLWithString:interview.fileUrl];
    //NSNumber *fileSize = [Utils fileSize:[f.filePathURL absoluteString]];
    
    
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", interview.filename];
    NSNumber *fileSize = [Utils fileSize:destinationPath];
    
    NSString *fileInfoString = [NSString stringWithFormat:@"%@ (%@)", [Utils convertTimeFromSeconds:seconds], [NSNumber displayFileFormat:fileSize]];
    movieListCell.infoLabel2.text = fileInfoString;
    
    movieListCell.delegate = self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    NSLog(@"setEditing");
    //[self.talkTable reloadData];
    if(editing == YES){
        
        for (UITableViewCell *cell in [self.table visibleCells]) {
            //NSIndexPath *path = [self.talkTable indexPathForCell:cell];
            //cell.selectionStyle = (self.editing && (path.row > 1 || path.section == 0)) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
            /*
            [UIView beginAnimations:@"cell shift" context:nil];
            TalkRoomCell *talkRoomCell = (TalkRoomCell *)cell;
            CGRect titleLabelRect = talkRoomCell.titleLabel.frame;
            titleLabelRect.size.width = titleLabelRect.size.width - kCellShiftWidth;
            talkRoomCell.titleLabel.frame = titleLabelRect;
            
            CGRect lastMessageRect = talkRoomCell.lastMessageLabel.frame;
            lastMessageRect.size.width = lastMessageRect.size.width - kCellShiftWidth;
            talkRoomCell.lastMessageLabel.frame = lastMessageRect;
            
            CGRect lastDateRect = talkRoomCell.lastMessageDateLabel.frame;
            lastDateRect.origin.x = lastDateRect.origin.x - kCellShiftWidth;
            talkRoomCell.lastMessageDateLabel.frame = lastDateRect;
            
            [UIView commitAnimations];
            */
            
        }
        
    } else {
        for (UITableViewCell *cell in [self.table visibleCells]) {
            //NSIndexPath *path = [self.talkTable indexPathForCell:cell];
            //cell.selectionStyle = (self.editing && (path.row > 1 || path.section == 0)) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
            /*
            [UIView beginAnimations:@"cell shift" context:nil];
            TalkRoomCell *talkRoomCell = (TalkRoomCell *)cell;
            CGRect titleLabelRect = talkRoomCell.titleLabel.frame;
            titleLabelRect.size.width = titleLabelRect.size.width + kCellShiftWidth;
            talkRoomCell.titleLabel.frame = titleLabelRect;
            
            //CGRect thumbImageRect = talkRoomCell.thumbnailImageView.frame;
            //thumbImageRect.origin.x = thumbImageRect.origin.x + 20;
            //talkRoomCell.thumbnailImageView.frame = thumbImageRect;
            //CGRect unreadMessageRect = talkRoomCell.unreadMessageCntButton.frame;
            //unreadMessageRect.origin.x = unreadMessageRect.origin.x + 20;
            //talkRoomCell.unreadMessageCntButton.frame = unreadMessageRect;
            CGRect lastMessageRect = talkRoomCell.lastMessageLabel.frame;
            lastMessageRect.size.width = lastMessageRect.size.width + kCellShiftWidth;
            talkRoomCell.lastMessageLabel.frame = lastMessageRect;
            
            CGRect lastDateRect = talkRoomCell.lastMessageDateLabel.frame;
            lastDateRect.origin.x = lastDateRect.origin.x + kCellShiftWidth;
            talkRoomCell.lastMessageDateLabel.frame = lastDateRect;
            
            [UIView commitAnimations];
            */
        }
    }
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:YES];
    
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSLog(@"TalkListController didSelectedRow");
	//NSUInteger row = [indexPath row];
    
    //TalkRoom *talkRoom = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
	
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	
	//NSDictionary *item = [self.friendList objectAtIndex:row];
	//NSInteger friendUid = [[NSString stringWithFormat:@"%@",[item objectForKey:@"uid"]] intValue];
	/*
     LectureItemDetailController *itemDetail = [[LectureItemDetailController alloc] initWithNibName:@"LectureItemDetailController" bundle:[NSBundle mainBundle]];
     itemDetail.lectureNo = lectureNo;
     itemDetail.itemNo = itemNo;
     itemDetail.itemName = [item objectForKey:@"itemNm"];
     [self.navigationController pushViewController:itemDetail animated:YES];
     [itemDetail release];
     itemDetail = nil;
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMovieListCellHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // remove the row here.
        NSLog(@"Delete Click");
        Interview *interview = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:interview];

    }
}

#pragma mark -
#pragma mark MovieListCell Delegate

//동영상 재생
- (void)movieListCellButton1Click:(MovieListCell *)cell {
    NSLog(@"button1Click");
    
    [[[AppDelegate sharedAppDelegate] mainViewController] switchMoviePlayer:cell.interview.fileUrl];
    
    
    //MovieViewController *movie = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    //movie.movieUrl = cell.interview.fileUrl;
    //[self presentModalViewController:movie animated:YES];
    //[movie release];
}

//영상등록
- (void)movieListCellButton2Click:(MovieListCell *)cell {
    NSLog(@"button2Click");
}

//면접질문
- (void)movieListCellButton3Click:(MovieListCell *)cell {
    NSLog(@"button3Click");
    
    InterviewQuestionViewController *qView = [[InterviewQuestionViewController alloc] initWithNibName:@"InterviewQuestionViewController" bundle:nil];
    qView.interview = cell.interview;
    [self.navigationController pushViewController:qView animated:YES];
    [qView release];
}

//파일삭제
- (void)movieListCellButton4Click:(MovieListCell *)cell {
    NSLog(@"button4Click");
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@", cell.interview.filename];
    NSLog(@"destinationPath=%@", destinationPath);
    
    Interview *interview = [[self fetchedResultsController] objectAtIndexPath:[self.table indexPathForCell:cell]];
    
    if ([fileManager fileExistsAtPath:destinationPath]) {
        NSLog(@"file exist");
        if ([fileManager removeItemAtPath:destinationPath error:&error] != YES) {
            NSLog(@"Unable to delete file %@", [error localizedDescription]);
        } else {
            
            [self.managedObjectContext deleteObject:interview];
            
            [self reloadFetch];
            [self.table reloadData];
            
        }
        
    } else {
        
        [self.managedObjectContext deleteObject:interview];
        [self reloadFetch];
        [self.table reloadData];
    }
    
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entiryDescription = [NSEntityDescription entityForName:@"InterviewQuestion" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entiryDescription];

    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    [request release];
    
    for(NSManagedObject *item in items) {
        
        NSLog(@"delete interviewQuestion=%@", item);
        [self.managedObjectContext deleteObject:item];
    }
    */
    
    
    
    //[self.managedObjectContext deleteObject:interview];
    //[self.table reloadData];
    
    NSLog(@"Document directory: %@", [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"삭제"]) {

        if(buttonIndex == 0){
            
        } else if(buttonIndex == 1) {
            
        } else if(buttonIndex == 2) {
            
        }
    }
}
@end
