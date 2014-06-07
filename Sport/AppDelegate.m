//
//  AppDelegate.m
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "AppDelegate.h"
#import "EMPerson.h"

@implementation AppDelegate
@synthesize netUtil = _netUtil;

-(void)reachabilityChanged:(NSNotification*)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错了……" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
    _netUtil = [[NetUtils alloc] init];
    ViewController* view = viewOnSb(@"view");
    self.window.rootViewController = view;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [_hostReach startNotifier];
    
    /*
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        TabbarViewController* tab = viewOnSb(@"tabbar");
        // 加上导航
        self.window.rootViewController = tab;
    }else{
        FirstViewController* first = viewOnSb(@"first");
        self.window.rootViewController  = first;
    }
    */
    // 推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //检查更新
//    if (_netUtil) {
//        [_netUtil getUpdate:nil];
//    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"nsdata:%@\n 字符串token: %@",deviceToken, newToken);
   // 此处修改UPLOAD_DEVICE值
    [_netUtil requestContentWithUrl:UPLOAD_DEVICE para:nil withSuccessBlock:^(id returnData) {
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    
    
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"RegistFail%@",error);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
}


@end
