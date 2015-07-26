//
//  ProfileCell.m
//  Zine
//
//  Created by bob on 13-9-14.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "ProfileCell.h"


@implementation ProfileCell
@synthesize frndType = _frndType;

- (id)initWithReuseIdentifier:(NSString *)strIndefi;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndefi];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        int iSpace = 20;
        int iFontSize = 16;
        int iAvatarWidth = 52;
        int iTotalWidht = 280;
        int iTopsapce = (kProfileCellHeight - iAvatarWidth) / 2;
        
        _lblRank = [[UILabel alloc] init];
        [_lblRank setFrame:CGRectMake(iSpace, (kProfileCellHeight - 40) / 2, 40, 40)];
        [_lblRank setTextColor:[UIColor redColor]];
        [_lblRank setBackgroundColor:[UIColor clearColor]];
        [_lblRank setFont:[UIFont boldSystemFontOfSize:30]];
        [self addSubview:_lblRank];
        
        iSpace += 40;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iSpace, (kProfileCellHeight - iAvatarWidth) / 2, iAvatarWidth, iAvatarWidth)];
        _imgView.clipsToBounds = YES;
        [_imgView setBackgroundColor:[UIColor lightGrayColor]];
        _imgView.layer.borderColor=[[UIColor whiteColor] CGColor];
        _imgView.layer.borderWidth=1.5;
        _imgView.layer.cornerRadius= _imgView.frame.size.width / 2;
        [self addSubview:_imgView];
        
        iFontSize = 26;
        iSpace += iAvatarWidth + 6;
        iTopsapce += 3;
        _lblScore = [[UILabel alloc] initWithFrame:CGRectMake(iSpace, iTopsapce, 120, iFontSize)];
        [_lblScore setFont:[UIFont systemFontOfSize:iFontSize]];
        [_lblScore setTextColor:[UIColor darkGrayColor]];
        [_lblScore setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lblScore];
        
        iTopsapce += iFontSize;
        iFontSize = 16;
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(iSpace, iTopsapce , 120, iFontSize)];
        [_lblName setFont:[UIFont systemFontOfSize:iFontSize]];
        [_lblName setTextColor:[UIColor grayColor]];
        [_lblName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lblName];
        
 
        iSpace += 120;
        _btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnInvite setFrame:CGRectMake(iSpace, (kProfileCellHeight - 40) / 2, 60, 40)];
        [_btnInvite.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnInvite setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _btnInvite.layer.borderWidth = 1.0;
        _btnInvite.layer.borderColor = [UIColor grayColor].CGColor;
//        _btnInvite.hidden = YES;
        [_btnInvite addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
 
        [self addSubview:_btnInvite];
        

        
//        UIImage *img = [UIImage imageNamed:@"setting_access.png"];
//        UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(iTotalWidht, iTopsapce, img.size.width, img.size.height)];
//        [accessView setImage:img];
//        [self addSubview:accessView];
        
        _lblRank.text = @"1";
        _lblName.text = @"bob";
        _lblScore.text = @"100\"";
        [_btnInvite setTitle:NSLocalizedString(@"Inactive", Nil) forState:UIControlStateNormal];
//        [_btnInvite setBackgroundColor:[UIColor redColor]];
        [_imgView setImage:[UIImage imageNamed:@"Icon.png"]];
    }
    return self;
}


- (void)btnPressed:(id)sender
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didPressedBtn:)]) {
        [self.cellDelegate didPressedBtn:nil];
    }
}

@end

