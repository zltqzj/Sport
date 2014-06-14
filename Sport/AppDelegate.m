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

+(AppDelegate *)sharedAppDelegate
{
    static AppDelegate *thePTAppDelegate = nil;
    @synchronized(self){
        if (thePTAppDelegate == nil)
        {
            thePTAppDelegate = [[AppDelegate alloc] init];
        }
        return thePTAppDelegate;
    }
}

-(void)reachabilityChanged:(NSNotification*)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错了……" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


-(void)UPDateMainMap:(NSMutableArray* )parry{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:parry,@"parry", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDateMainMap" object:nil userInfo:dict];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
    _netUtil = [[NetUtils alloc] init];
    
    /*
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
        TabbarViewController* tab  = viewOnSb(@"tabbar");
        [tab.tabBar setBackgroundColor:[UIColor blackColor]];
        self.window.rootViewController = tab;
        [tab.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
        if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
            
        }else{
            //ios6导航栏的处理
        }
    }
    else{
        RegistViewController* regist = viewOnSb(@"regist");
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:regist];
        self.window.rootViewController  = nav;
    }
    */
  
     
  
    
    /*
    RegistViewController* regist = viewOnSb(@"regist");
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:regist];
    self.window.rootViewController  = nav;
   */
  
    /*
    LoginViewController* login = viewOnSb(@"login");
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController  = nav;
     
     */
    
    /*
    ViewController* view = viewOnSb(@"view");
    self.window.rootViewController = view;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [_hostReach startNotifier];
     */
     
    
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
    [[MyManager sharedManager] setIfDrawLine:@"NO"];
    MapViewController* map = viewOnSb(@"map");
    
    [map.timer pause];
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
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
   
    [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:@"token"];
    
    
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
