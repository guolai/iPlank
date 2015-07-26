//
//  RankingView.m
//  iplank
//
//  Created by bob on 1/18/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "RankingView.h"

@implementation RankingView
@synthesize arrayData;


- (id)initWithFrame:(CGRect)frame withRows:(int)iRow
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        float fWidth = frame.size.width;
        float fPading = 2;
        float fHeight = (frame.size.height - iRow * fPading) / iRow;
        for (int i = 0; i < iRow; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (fPading + fHeight) * i,  fWidth, fHeight)];
            [imgView setBackgroundColor:[UIColor clearColor]];
            UILabel *lbl  = [[UILabel alloc] init];
            CGRect rct  = CGRectMake(0, (fHeight - 20) / 2, 20, 20);
            [lbl setFrame:rct];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setText:[NSString stringWithFormat:@"%d", i]];
            [imgView addSubview:lbl];
            
            rct.origin.x = rct.origin.x + rct.size.width + 10;
            rct.origin.y = 0;
            rct.size.width = fHeight;
            rct.size.height = fHeight;
            UIImageView *avatarView = [[UIImageView alloc] initWithFrame:rct];
            [avatarView setImage:[UIImage imageNamed:@"profile.png"]];
            [imgView addSubview:avatarView];
            
            rct.origin.x = rct.origin.x + rct.size.width + 10;
            rct.origin.y = (fHeight - 20) / 2;
            rct.size.width = fWidth - rct.origin.x;
            rct.size.height = 20;
            UILabel *lblScore = [[UILabel alloc] initWithFrame:rct];
            [lblScore setTextAlignment:NSTextAlignmentCenter];
            [lblScore setBackgroundColor:[UIColor clearColor]];
            [lblScore setTextColor:[UIColor redColor]];
            [lblScore setText:[NSString stringWithFormat:@"%d", i * 10]];
            [imgView addSubview:lblScore];
            
            [_arrayImageViews  addObject:imgView];
            [self addSubview:imgView];
        }
    }
    return self;
}

@end
