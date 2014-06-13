//
//  config.h
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#ifndef Sport_config_h
#define Sport_config_h

// 唐巧
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define MAX_POINT 10
// 数值转为字符串
#define valueToString(_value) [@(_value) stringValue]

#define PI 3.14159265358979323846264338327950288

#pragma mark - 判断设备
// 屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

// IPHONE
#define IS_IPHONE [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone

// IPAD
#define IS_IPAD [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad

// 判断是否为IPHONE5
# define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// 判断设备版本
// 版本等于
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

// 版本高于
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// 版本高于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 版本小于
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

// 版本小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 判断是否大于7
#define ISIOS7  [[[UIDevice currentDevice] systemVersion] floatValue]>=7

// 上传设备
#define UPLOAD_DEVICE @"http://weixin.jsptz.com/map.php?action=uploadDeviceToken&username=zhaojian"

// 下载IPA
#define DOWNLOAD @"itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/hnu4brntx7eeoig/location.plist"

// 检查是否有更新
#define UPDATE @"http://weixin.jsptz.com/map/app/ipa_version.php"

// 注册
#define REGIST @"http://run.yyzhao.com/m/reg"

// 登陆
#define LOGIN @"http://run.yyzhao.com/m/userlogin"


// 查询所有人的坐标
#define ALL_LOCATION @"http://weixin.jsptz.com/map.php?action=getAllUserLocaltion&userid=45"

// 上传我的坐标
#define  UPLOAD_LOCATION @"http://weixin.jsptz.com/map.php?action=uploadMyLocation"


#define IS_LOGIN @"is_login"


#define SHADOW_COLOR [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.5f]

#define WHAT_NEW @" 测试中 "

#define viewOnSb(identifer)  [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:identifer]



/*
 UIViewAutoresizingNone就是不自动调整。
 UIViewAutoresizingFlexibleLeftMargin 自动调整与superView左边的距离，保证与superView右边的距离不变。
 UIViewAutoresizingFlexibleRightMargin 自动调整与superView的右边距离，保证与superView左边的距离不变。
 UIViewAutoresizingFlexibleTopMargin 自动调整与superView顶部的距离，保证与superView底部的距离不变。
 UIViewAutoresizingFlexibleBottomMargin 自动调整与superView底部的距离，也就是说，与superView顶部的距离不变。
 UIViewAutoresizingFlexibleWidth 自动调整自己的宽度，保证与superView左边和右边的距离不变。
 UIViewAutoresizingFlexibleHeight 自动调整自己的高度，保证与superView顶部和底部的距离不变。
 UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin 自动调整与superView左边的距离，保证与左边的距离和右边的距离和原来距左边和右边的距离的比例不变。比如原来距离为20，30，调整后的距离应为68，102，即68/20=102/30。
 
 */

/*
 // 是否wifi
 - (BOOL) IsEnableWIFI{
 return([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
 }
 // 是否3G
 - (BOOL) IsEnable3G{
 return([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
 }
 
 */


/*  判断是否越狱
 @interface UIDevice (Helper)
 - (BOOL)isJailbroken;
 @end
 
 @implementation UIDevice (Helper)
 - (BOOL)isJailbroken {
 BOOL jailbroken = NO;
 NSString *cydiaPath = @"/Applications/Cydia.app";
 NSString *aptPath = @"/private/var/lib/apt/";
 if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
 jailbroken = YES;
 }
 if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
 jailbroken = YES;
 }
 return jailbroken;
 }
 @end
 
 
 */

/*  设置导航栏颜色IOS6 IOS7
 
 if ([self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
 [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
 
 }
 
 if (ISIOS7) {
 [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
 }
 
 */
#endif
