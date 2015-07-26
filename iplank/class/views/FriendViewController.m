//
//  FriendViewController.m
//  iplank
//
//  Created by bob on 1/1/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "FriendViewController.h"

#import "FileManagerController.h"
#import "AppDelegate.h"

//#import "ShareWeibo.h"
#import "ProfileCell.h"


@interface FriendViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SwitchBtnStateChanged>
{
 
}
@property (nonatomic, retain) UITableView *tblView;

@property(nonatomic, retain)NSArray *listArray;

@end

@implementation FriendViewController
@synthesize tblView;
@synthesize listArray;


- (void)dealloc
{
    self.listArray = nil;
    self.tblView = nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    self.tblView = nil;
    self.listArray = nil;
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tblView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self showBackButton:nil style:e_Nav_Green action:@selector(dismissCurrentView)];
    [self showTitle:NSLocalizedString(@"Profile", nil)
          textColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
           fontSize:18
         fontFamily:NSLocalizedString(@"Title font", nil)];
    
    NSArray *array1 = @[@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1"];
    NSArray *array2 = @[@"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2", @"2"];
    self.listArray = @[array1, array2];
}

- (void)dismissCurrentView
{
   if(self.presentDelegate && [self.presentDelegate respondsToSelector:@selector(presentViewCtrDidCancel:)])
   {
       [self.presentDelegate presentViewCtrDidCancel:nil];
   }
}

- (void)loadView
{
    CGRect rct = CGRectMake(0, 0, self.width, self.height);
    if(OS_VERSION < 7.0)
    {
        rct = CGRectMake(0, 0, self.width, self.height - self.navBarHeight);
    }
    UIView *view = [[UIView alloc] initWithFrame:rct];
    self.view = view;
    
    self.tblView = [[UITableView alloc] initWithFrame:rct style:UITableViewStyleGrouped];
    
    //self.tblView.separatorStyle = UITableViewCellAccessoryNone;
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    [self.view addSubview:self.tblView];
    if(OS_VERSION  >= 7.0)
    {
        [self.tblView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setBackgroundView:nil];
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
    }

}


#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listArray  objectAtIndex:section] count];
}



//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return kProfileCellHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(section == 3)
//    {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(10, 6, 300, 40);
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor colorWithRed:(76.0f / 255.0f) green:(86.0f / 255.0f) blue:(108.0f / 255.0f) alpha:0.3];
//        label.shadowColor = [UIColor whiteColor];
//        label.shadowOffset = CGSizeMake(0.0, 1.0);
//        label.font = [UIFont systemFontOfSize:14];
//        label.numberOfLines = 2;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.lineBreakMode = NSLineBreakByTruncatingTail;
//        
//        label.text = @"DESIGNED BY AURA MARKER STUDIO";
//        
//        // Create header view and add label as a subview
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//        [view addSubview:label];
//        
//        return view;
//    }
//    return nil;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kProfileCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.listArray objectAtIndex:indexPath.section];
 
    static NSString *strProfileCell = @"profileCell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:strProfileCell];
    if(!cell)
    {
        cell = [[ProfileCell alloc] initWithReuseIdentifier:strProfileCell];
    }
    cell.cellDelegate = self;
    return cell;
}


#pragma mark table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DEBUGLOG();
}





- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark -- cell delegate
- (void)didPressedBtn:(id)sender
{
    DEBUGLOG();
}

@end