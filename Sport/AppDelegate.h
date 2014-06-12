//
//  AppDelegate.h
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "TabbarViewController.h"
#import "ViewController.h"
#import "Reachability.h"
#import "MyManager.h"
#import "MapViewController.h"
#import "RegistViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic) Reachability* hostReach;

@property(strong,nonatomic) NetUtils* netUtil;

@end
