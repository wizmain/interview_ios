//
//  HomeViewController.m
//  interview
//
//  Created by 김규완 on 13. 2. 25..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "InterviewStartViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@property (nonatomic, retain) IBOutlet UIButton *mainButton1;
@property (nonatomic, retain) IBOutlet UIButton *mainButton2;
@property (nonatomic, retain) IBOutlet UIButton *mainButton3;
@property (nonatomic, retain) IBOutlet UIButton *mainButton4;
@property (nonatomic, retain) IBOutlet UIButton *mainButton5;
@property (nonatomic, retain) IBOutlet UIButton *mainButton6;
@property (nonatomic, retain) IBOutlet UIButton *mainButton7;
@property (nonatomic, retain) IBOutlet UIButton *mainButton8;
@property (nonatomic, retain) IBOutlet UIButton *mainButton9;
@property (nonatomic, retain) IBOutlet UIButton *mainButton10;


- (IBAction)buttonClick:(id)sender;

@end

@implementation HomeViewController

@synthesize mainButton1, mainButton2, mainButton3, mainButton4, mainButton5, mainButton6, mainButton7, mainButton8, mainButton9, mainButton10;
@synthesize managedObjectContext;

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
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    //self.view.backgroundColor = [UIColor blueColor];
    self.managedObjectContext = [[AppDelegate sharedAppDelegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.mainButton1 = nil;
    self.mainButton2 = nil;
    self.mainButton3 = nil;
    self.mainButton4 = nil;
    self.mainButton5 = nil;
    self.mainButton6 = nil;
    self.mainButton7 = nil;
    self.mainButton8 = nil;
    self.mainButton9 = nil;
    self.mainButton10 = nil;
    self.managedObjectContext = nil;
}

#pragma mark -
#pragma mark Custom Method
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSLog(@"sender tag = %d", button.tag);
    
    if(button.tag == 1){
        //InterviewStartViewController *start = [[InterviewStartViewController alloc] initWithNibName:@"InterviewStartViewController" bundle:nil];
        [[[AppDelegate sharedAppDelegate] mainViewController] switchTabView:2];
    } else if(button.tag == 2){
        [self deleteAll];
    }
}

- (void)deleteAll {
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
    
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Problem deleting destination: %@", [error localizedDescription]);
    }
    
    
}


@end
