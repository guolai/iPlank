//
//  ProfileCell.h
//  Zine
//
//  Created by bob on 13-9-14.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    e_Frnd_Register,
    e_Frnd_Other,
    e_Swt_Max
}T_Friend;

#define kProfileCellHeight 90

@protocol SwitchBtnStateChanged <NSObject>
@optional
//- (void)didSwitchBtnStateChangedTo:(BOOL)bValue type:(T_SwitchState)type;
- (void)didPressedBtn:(id)sender;
@end


@interface ProfileCell : UITableViewCell
{
    UILabel *_lblName;
//    UILabel *_lblEmail;
    UILabel *_lblRank;
    UIImageView *_imgView;
    UILabel *_lblScore;
    UIButton *_btnInvite;
    T_Friend _frndType;
}
@property (nonatomic, weak) id<SwitchBtnStateChanged> cellDelegate;
@property (nonatomic, assign) T_Friend frndType;
- (id)initWithReuseIdentifier:(NSString *)strIndefi;

@end

