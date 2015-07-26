//
//  UIViewController+BackButton.m
//  M6s
//
//  Created by zhuhb on 13-4-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "UIViewController+BackButton.h"
#import "UIImage+Extensions.h"

@implementation UIViewController (BackButton)

- (void)showBackButton:(NSString *)strBack style:(T_Nav_Style)style action:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        int iNavBarH = 44;
        int iImgHeight = 33;
        NSString *str = strBack;
        if(ISEMPTY(str))
        {
            str = NSLocalizedString(@"Back", nil);
        }
        str = [NSString stringWithFormat:@"   %@", str];
        UIImage *img = nil;// = [UIImage imageNamed:@"nav_back_green.png"];
        UIImage *hlImg = nil;//= [UIImage imageNamed:@"nav_back_green_hl.png"];
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = [str sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
        [btn setFrame:CGRectMake(0, (iNavBarH - iImgHeight) / 2, size.width, iImgHeight)];
        [btn.titleLabel setFont:font];
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [btn setTitle:str forState:UIControlStateNormal];
        switch (style) {
            case e_Nav_Green:
            {
                //iImgHeight = 28;
                img = [UIImage imageNamed:@"nav_back_green.png"];
                hlImg = [UIImage imageNamed:@"nav_back_green_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
            case e_Nav_Gray:
            {
                img = [UIImage imageNamed:@"nav_back_gray.png"];
                hlImg = [UIImage imageNamed:@"nav_back_gray_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
            case e_Nav_White:
            {
                img = [UIImage imageNamed:@"nav_back_white.png"];
                hlImg = [UIImage imageNamed:@"nav_back_white_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
            default:
            {
                img = [UIImage imageNamed:@"nav_back_green"];
                hlImg = [UIImage imageNamed:@"nav_back_green_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
        }
        if(action)
        {
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showLeftButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg style:(T_Nav_Style)style andEvent:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(ISEMPTY(strTitle) && ISEMPTY(strImg))
            return;
        if(!ISEMPTY(strTitle))
        {
            switch (style) {
                case e_Nav_Green:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                case e_Nav_Gray:
                {
   
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                case e_Nav_White:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                default:
                {
                    [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            [btn.titleLabel setFont:font];
            [btn setTitle:strTitle forState:UIControlStateNormal];
            CGSize size = [strTitle sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
            [btn  setFrame:CGRectMake(0, 0, size.width, 44)];
        }
        if(!ISEMPTY(strImg))
        {
            UIImage *img = [UIImage imageNamed:strImg];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if(!ISEMPTY(strHlImg))
            {
                [btn setBackgroundImage:[UIImage imageNamed:strHlImg] forState:UIControlStateHighlighted];
            }
            [btn  setFrame:CGRectMake(0, (44 - img.size.height) / 2, img.size.width, img.size.height)];
        }
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)showRigthButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg style:(T_Nav_Style)style fontsize:(float)fFontSize andEvent:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(ISEMPTY(strTitle) && ISEMPTY(strImg))
            return;
        if(!ISEMPTY(strTitle))
        {
            switch (style) {
                case e_Nav_Green:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                case e_Nav_Gray:
                {
                    
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                case e_Nav_White:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                default:
                {
                    [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            if(fFontSize > 10)
                font = [UIFont systemFontOfSize:fFontSize];
            [btn.titleLabel setFont:font];
            [btn setTitle:strTitle forState:UIControlStateNormal];
            CGSize size = [strTitle sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
            [btn  setFrame:CGRectMake(0, 0, size.width, 44)];
        }
        if(!ISEMPTY(strImg))
        {
            UIImage *img = [UIImage imageNamed:strImg];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if(!ISEMPTY(strHlImg))
            {
                [btn setBackgroundImage:[UIImage imageNamed:strHlImg] forState:UIControlStateHighlighted];
            }
            [btn  setFrame:CGRectMake(0, (44 - img.size.height) / 2, img.size.width, img.size.height)];
        }
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
}


- (void)showTitle:(NSString *)strTitle style:(T_Nav_Style)style
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    switch (style) {
        case e_Nav_Green:
        {
            label.textColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        }
            break;
        case e_Nav_Gray:
        {
            
            label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];

        }
            break;
        case e_Nav_White:
        {
            label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];

        }
            break;
        default:
        {
            label.textColor = [UIColor colorWithRed:46/255.0 green:166/255.0 blue:155/255.0 alpha:1.0];

        }
            break;
    }
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:NSLocalizedString(@"Title font", nil) size:18];
    label.text = strTitle;
    self.navigationItem.titleView = label;
}

- (void)showTitle:(NSString *)strTitle textColor:(UIColor *)color fontSize:(CGFloat)size fontFamily:(NSString *)fontName
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, size + 4)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = strTitle;
    self.navigationItem.titleView = label;
}


- (void)showUserProfile:(NSString *)strFileName action:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(ISEMPTY(strFileName))
        {
            return;
        }
        UIImage *img = [UIImage imageNamed:strFileName];
        [btn setFrame:CGRectMake(16, (44 - img.size.width) / 2, img.size.width, img.size.height)];
 
        btn.layer.borderColor=[[UIColor whiteColor] CGColor];
        btn.layer.borderWidth=1.5;
        btn.layer.cornerRadius= btn.frame.size.width / 2;
        [btn setImage:img forState:UIControlStateNormal];
        btn.clipsToBounds=YES;
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController.navigationBar addSubview:btn];
    }

}

- (UIImage *)getImageFrom:(NSString *)strName withTitle:(NSString *)strTitle fontSize:(int)fontSize height:(int)iHeight leftMargin:(int)iMargin//strname 不能带.png后缀
{
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize * 2];
    CGSize size = [strTitle sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", strName]];
    if(!img)
    {
//        assert(false);
        img = [UIImage imageNamed:strName];
    }
    int  fHeight = iHeight * 2;
    float fMargin = iMargin * 2;
    int fWidth = img.size.width + size.width + fMargin * 2;
    int iByteCount;
    int iBytesPerRow;
    iBytesPerRow  = fWidth * 4;
    iByteCount = iBytesPerRow * fHeight;
    void *bitmapData = malloc(iByteCount);
    if(bitmapData == NULL)
    {
        DEBUGINFO(@"malloc bitmapdata space failed!");
//        assert(false);
        return img;
    }
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(bitmapData, fWidth, fHeight, 8, iBytesPerRow, colorRef, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorRef);
    if(context == NULL)
    {
        DEBUGINFO(@"CGBitmapContextCreate failed!");
//        assert(false);
        return img;
    }
    UIGraphicsPushContext(context);
    CGContextTranslateCTM(context, 0, fHeight);
    CGContextScaleCTM(context, 1, -1);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, fWidth, fHeight));
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    UIImage *alphaImg = [UIImage imageNamed:@"alpha@2x.png"];
    alphaImg = [alphaImg stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    CGContextDrawImage(context, CGRectMake(0, 0, fWidth, fHeight), alphaImg.CGImage);
    [img drawInRect:CGRectMake(fMargin, (fHeight - img.size.height) / 2, img.size.width, img.size.height)];
    
    [strTitle drawInRect:CGRectMake(fMargin + img.size.width, (fHeight - size.height) / 2, size.width, size.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *bgimg = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    UIGraphicsPopContext();
    CGContextRelease(context);
    free(bitmapData);
    
    return bgimg;
}





@end
