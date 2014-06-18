//
//  RecordViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SplitsViewController.h"
#import "MapViewController.h"
#import "SUNSlideSwitchView.h"
#import "MyManager.h"
#import "StatsViewController.h"
@class MapViewController;
@interface RecordViewController : UIViewController<SUNSlideSwitchViewDelegate>
 

@property(strong,nonatomic) IBOutlet SUNSlideSwitchView* slideSwitchView;

@property(strong,nonatomic) UIViewController* stats_vc1;
@property(strong,nonatomic) UIViewController* split_vc2;
@property(strong,nonatomic) MapViewController* map_vc3;
-(void)save;
@end
