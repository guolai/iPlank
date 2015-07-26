//
//  Constant.h
//  jyy
//
//  Created by bob on 12/15/13.
//  Copyright (c) 2013 jyy. All rights reserved.
//

#ifndef jyy_Constant_h
#define jyy_Constant_h


typedef enum {
    e_Rslt_Face,
    e_Rslt_Normal,
    e_Rslt_flight
}T_Result;


#define OS_VERSION  [[UIDevice currentDevice].systemVersion floatValue]
#define ISEMPTY(x) (!x || [x isEqual:[NSNull null]] || [x isEqualToString:@""])

#define isIphone3Dot5 (([BBMisc screenHeight] == 480) ? YES : NO)
#define isIphone4Dot (([BBMisc screenHeight] == 568) ? YES : NO)
#define isPhone6 (([BBMisc screenHeight] >= 667) ? YES : NO)
#define isIphone4Dot7 (([BBMisc screenHeight] == 667) ? YES : NO)
#define isIphone5Dot5 (([BBMisc screenHeight] == 736) ? YES : NO)

#define fScr_Scale ([BBAutoSize getResizeScale])

#define SCR_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCR_HEIGHT ([[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCR_HEIGHT_P  ([[UIScreen mainScreen] bounds].size.height)


#define SCR_STATUS_BAR ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCR_TOPBAR (self.navigationController.navigationBar.bounds.size.height)
#define MYAPPID @"788815341"


//有米
#define kAdID @"1104082446"
#define kADBannerID @"7080309131920007"
#define kADChaPingID @"4010204153735506"
#define KGuangGaoSecret @"64adf2b31f68e3cd"
#define guanggaoevent1 @"youmiguanggao1"
#define guanggaoevent2 @"youmiguanggao2"
#define guangGaoShowOK @"showOK"
#define guangGaoShowFailed @"showFailed"
#define guanggaoClick @"guanggaoClick"
#define guanggaoAbort @"guanggaoAbort"


//#define    DEBUG_ENABLE
#ifdef DEBUG_ENABLE
#define DEBUGINFO(fmt, ...)          NSLog(@"[%@:%d]"fmt, \
[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], \
__LINE__, \
##__VA_ARGS__)
#define DEBUGDEALLOC() NSLog(@"*******dealloc%@: %@*****", NSStringFromSelector(_cmd), self);
#define DEBUGLOG() NSLog(@"%s, %d",__PRETTY_FUNCTION__, __LINE__)
#else
#define DEBUGINFO(fmt, ...) ((void)0)
#define DEBUGDEALLOC() ((void)0)
#define DEBUGLOG() ((void)0)
#endif

#endif
