//
//  SettingViewController.m
//  iplank
//
//  Created by bob on 6/14/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import <MessageUI/MessageUI.h>
#import "ExampleViewController.h"
#import "WebViewController.h"
#import "PodLibViewController.h"
#import "FileManagerController.h"
#import "BBPlayer.h"
#import "NSDate+String.h"
#import "MobClick.h"


typedef enum {
    eSection1,
    eSection0
}T_Section;


@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) NSArray *arrayData;
@end

@implementation SettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    int iCurDate = [[NSDate date] getFloatNumOfYearMonthDay];
    NSString *strValue = NSLocalizedString(@"Support our work1", nil) ;
    int iMod = iCurDate % 3;
    if(iMod == 1)
    {
        strValue = NSLocalizedString(@"Support our work2", nil) ;
    }
    else if (iMod == 2)
    {
        strValue = NSLocalizedString(@"Support our work3", nil) ;
    }
    [self showBackButton:nil style:e_Nav_Green action:nil];
    [self showTitle:NSLocalizedString(@"Setting", nil) style:e_Nav_Green];
    self.arrayData = @[@[NSLocalizedString(@"Fead back", nil), NSLocalizedString(@"Give a review", nil), NSLocalizedString(@"More apps", nil), strValue,  NSLocalizedString(@"See you", nil)],@[NSLocalizedString(@"Music", nil),NSLocalizedString(@"Remove all music", nil), NSLocalizedString(@"How to plank", nil), NSLocalizedString(@"Why to plank", nil)]];

}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    NSString *strBg = [NSString stringWithFormat:@"chat_bg_%.2d.jpg", (int)(arc4random() % 11)];
    //    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:strBg]]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:strBg]];
    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
    
    float viewHeight = self.height;

    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, fTop, self.width - 10.0f, viewHeight) style:UITableViewStyleGrouped];
    //    self.tblView.separatorStyle = UITableViewCellAccessoryNone;
    if(OS_VERSION  >= 7.0)
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setBackgroundView:nil];
    }
    [self.view addSubview:self.tblView];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [self footView];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section != 1) {
//        return 0.0f;
//    }
//    return 30.0f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section != 1)
//        return nil;
//    DEBUGINFO(@"------------%d", section);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 30)];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
//    [lbl  setTextColor:[UIColor redColor]];
//    [lbl setFont:[UIFont boldSystemFontOfSize:14]];
//    [lbl  setBackgroundColor:[UIColor clearColor]];
//    [lbl setText:@"欢迎加入平板运动交流群 154887779"];
//    [view addSubview:lbl];
//    return view;
//}

- (UIView *)footView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    [lbl  setTextColor:[UIColor redColor]];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    [lbl  setBackgroundColor:[UIColor clearColor]];
    [lbl setText:NSLocalizedString(@"Come on to join us now! QQ Group:154887779", nil)];
    [view addSubview:lbl];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *array = [self.arrayData objectAtIndex:section];
    if(section == 0)
    {
        NSDate *date = [NSDate date];
        NSInteger fNumber = [date getFloatNumOfYearMonthDay];
        if(fNumber < 20150715)
            return array.count - 2;
    }
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.arrayData objectAtIndex:indexPath.section];
    
    static NSString *strCell = @"settextcell";
    
    SetTextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if(!cell)
    {
        cell = [[SetTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
   
    cell.lblName.text = [array objectAtIndex:indexPath.row];
    cell.lblText.text = nil;
    if((indexPath.section == eSection1) && (indexPath.row == 3 || indexPath.row == 4))
    {
        [cell.lblName setTextColor:[UIColor redColor]];
    }
    else
    {
        [cell.lblName setTextColor:[UIColor blackColor]];
    }
    return cell;
 
}


#pragma mark table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == eSection0)
    {
        switch (indexPath.row) {
            case 0:
            {
                PodLibViewController *vc = [[PodLibViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 1:
            {
                [self showProgressHUD];
                
                [FileManagerController removeFile:[[BBPlayer shareInstance] podLibrary]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissProgressHUD];
                });
                break;
            }
            case 2:
            {
                ExampleViewController *vc = [[ExampleViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                WebViewController *vc = [[WebViewController alloc] init];
                vc.webType = ewebWhyToPlank;
                [self.navigationController  pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == eSection1)
    {
        switch (indexPath.row) {
            case 0:
            {
                if(![MFMailComposeViewController canSendMail])
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please set your email account", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:nil];
                    [alertView show];
                    return;
                }
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
           
                
                [mc setSubject:NSLocalizedString(@"Feed back(iplank)", nil)];
                [mc setMessageBody:@"" isHTML:NO];
                [mc setToRecipients:@[@"554094074@qq.com"]];
                [self presentViewController:mc animated:YES completion:NULL];
            }
                break;
                case 1:
            {
                NSString *strMyid = [NSString stringWithFormat:
                                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MYAPPID];
                DEBUGINFO(@"myid %@", strMyid);
                if(OS_VERSION >= 7.0)
                {
                    strMyid = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zine/id%@?ls=1&mt=8", MYAPPID];
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];

            }
                break;
                case 2:
            {
                 NSString *strMyid = @"https://itunes.apple.com/cn/artist/laiguo/id563990126?l=en";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];
            }
                break;
                case 3:
            {
                WebViewController *vc = [[WebViewController alloc] init];
                vc.webType = ewebDonate;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                WebViewController *vc = [[WebViewController alloc] init];
                vc.webType = ewebGirl;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            Vlog(@"Mail cancelled");
            //            break;
        case MFMailComposeResultSaved:
            //   Vlog(@"Mail saved");
        case MFMailComposeResultFailed:
            //         Vlog(@"Mail sent failure: %@", [error localizedDescription]);
            [self showProgressHUDWithStr:NSLocalizedString(@"Mail send failed", nil) hideafterDelay:2.0];
            break;
        case MFMailComposeResultSent:
            [self showProgressHUDWithStr:NSLocalizedString(@"Mail send success", nil) hideafterDelay:2.0];
            break;
            
            
            break;
        default:
            break;
    }    
}

@end
