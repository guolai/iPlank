//
//  RankingView.h
//  iplank
//
//  Created by bob on 1/18/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingView : UIView
{
    NSMutableArray *_arrayImageViews;
}

@property (nonatomic, strong) NSArray *arrayData;

- (id)initWithFrame:(CGRect)frame withRows:(int)iRow;

@end
