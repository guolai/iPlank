//
//  NSString+UIColor.h
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UIColor)
- (UIColor *)getColorFromString;
- (UIColor *)getColorFromRGBA;
- (UIColor *)getColorFromHexString;

@end
