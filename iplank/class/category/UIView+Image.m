//
//  UIView+Image.m
//  Zine
//
//  Created by bob on 9/18/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "UIView+Image.h"

@implementation UIView (Image)
- (UIImage *)translateToImage
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale = 2.0;
        }
    }
    
    if(scale > 1.5)
    {
        CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(self.bounds.size);
    }

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return fullimage;
}

- (UIImage *)translateToImageInRect:(CGRect)rct
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale = 2.0;
        }
    }
    
    if(scale > 1.5)
    {
        CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        rct = CGRectMake(rct.origin.x * scale, rct.origin.y * scale,  rct.size.width * scale, rct.size.height * scale);
    }
    else
    {
        UIGraphicsBeginImageContext(self.bounds.size);
    }

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGImageRef imageRef=CGImageCreateWithImageInRect(fullimage.CGImage, rct);
    UIImage *retImage =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return retImage;
}

@end

@implementation UIScrollView(scrview)

- (UIImage *)translateToImage
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale = 2.0;
        }
    }
    
    if(scale > 1.5)
    {
        CGSize size = CGSizeMake(self.contentSize.width * scale, self.contentSize.height * scale);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(self.contentSize);
    }
    //CGRect rct = self.bounds;
    //
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();
    //DEBUGINFO(@"1111%@", NSStringFromCGSize(fullimage.size));
    UIGraphicsEndImageContext();
    return fullimage;
    //    CGImageRef imgRef = CGImageCreateWithImageInRect(fullimage.CGImage, rct);
    //    UIImage *clipedImg = [UIImage imageWithCGImage:imgRef];
}


@end
