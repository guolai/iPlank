//
//  UIViewController+BackButton.h
//  M6s
//
//  Created by zhuhb on 13-4-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    e_Nav_Green,
    e_Nav_Gray,
    e_Nav_White
}T_Nav_Style;

@interface UIViewController (BackButton)
- (void)showBackButton:(NSString *)strBack style:(T_Nav_Style)style action:(SEL)action;
- (void)showLeftButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg style:(T_Nav_Style)style andEvent:(SEL)action;
- (void)showRigthButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg style:(T_Nav_Style)style fontsize:(float)fFontSize andEvent:(SEL)action;
- (void)showTitle:(NSString *)strTitle style:(T_Nav_Style)style;
- (void)showTitle:(NSString *)strTitle textColor:(UIColor *)color fontSize:(CGFloat)size fontFamily:(NSString *)fontName;

@end
