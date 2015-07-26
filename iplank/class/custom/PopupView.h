//
//  PopupView.h
//  Zine
//
//  Created by bob on 5/15/14.
//  Copyright (c) 2014 aura marker stdio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    e_Popup_Done,
    e_Popup_Cancle
}T_PopupEvent;

@protocol PopUpViewDelegate <NSObject>

- (void)popupViewDidPressed:(T_PopupEvent)event;

@end

@interface PopupView : UIView
{
    UIView *_bgView;
    UIImageView *_shareView;
}
@property (nonatomic, weak) id<PopUpViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withScore:(int)iValue;
-(void)fadeOut;
-(void)fadeIn;
@end
