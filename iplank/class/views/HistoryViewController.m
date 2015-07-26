//
//  ProfileViewController.m
//  Zine
//
//  Created by bob on 13-9-14.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "HistoryViewController.h"

#import "FileManagerController.h"

//#import "ShareWeibo.h"
#import "DataModel.h"
#import "UserDefault.h"
#import "CoutView.h"
#import "MobClick.h"


@interface HistoryViewController ()
{

}
@property (nonatomic, strong)CoutView *countView;
@property(nonatomic, retain)NSArray *listArray;

@end

@implementation HistoryViewController
@synthesize listArray;
@synthesize countView;



- (void)dealloc
{
    self.listArray = nil;


    
}

- (void)didReceiveMemoryWarning
{

    self.listArray = nil;

    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showBackButton:nil style:e_Nav_Green action:nil];
    [self showTitle:NSLocalizedString(@"History data", nil) style:e_Nav_Green];
 /*for test 
  
  */
#if 0
  
    for (int i = 0; i < 10; i++) {
        float fValue = (float)(arc4random() % 120);
        DEBUGINFO(@"%f", fValue);
        [DataModel saveResult:fValue type:e_Rslt_Face];
    }
    
#endif
    self.countView.countType = e_Count_Times;
    [MobClick event:@"historydata"];
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
        rct = CGRectMake(0, self.navBarHeight, self.width, self.height - self.navBarHeight - SCR_STATUS_BAR);
    }
    UIView *view = [[UIView alloc] initWithFrame:rct];
    self.view = view;
   
    UISegmentedControl *toggle = [[UISegmentedControl alloc] initWithItems:@[ NSLocalizedString(@"Year", nil), NSLocalizedString(@"Month", nil),  NSLocalizedString(@"Week", nil),  NSLocalizedString(@"Day", nil),NSLocalizedString(@"Times", nil)]];
    toggle.segmentedControlStyle = UISegmentedControlStyleBar;
    toggle.selectedSegmentIndex = 4;
    toggle.tintColor = [UIColor redColor];
    CGRect toggleRct = CGRectMake((SCR_WIDTH - 200) /2, rct.size.height - SCR_WIDTH - 60, 200, 40);
    toggle.frame = toggleRct;
    [toggle addTarget:self action:@selector(changeToggleSelectedItem:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:toggle];
    
    
    CGRect coutrct = CGRectMake(0, rct.size.height - SCR_WIDTH, SCR_WIDTH, SCR_WIDTH);
    self.countView = [[CoutView alloc] initWithFrame:coutrct];
    [self.countView setUserInteractionEnabled:YES];
    [self.view addSubview:self.countView];
    
}


- (void)changeToggleSelectedItem:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    T_Count countType = control.selectedSegmentIndex;
    DEBUGINFO(@"%d", countType);
    self.countView.countType = countType;
}

@end
