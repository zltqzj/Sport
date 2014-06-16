//
//  StatsViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSLocationManager.h"


#import "SaveViewController.h"
#import "RecordViewController.h"

@interface StatsViewController : UIViewController <PSLocationManagerDelegate>

@property(strong,nonatomic) IBOutlet UILabel* lblHour; // 小时标签
@property(strong,nonatomic) IBOutlet UILabel* lblMinite;// 分钟标签
@property(strong,nonatomic) IBOutlet UILabel* lblSeconds;// 秒标签
@property(strong,nonatomic) IBOutlet UILabel* lblTotalDistance;// 总公里数标签
@property(strong,nonatomic) IBOutlet UILabel* lbsplitpace;// 秒标签

@property(nonatomic,strong) IBOutlet UILabel* strength;// gps强度标签

@property(strong,nonatomic) CSPausibleTimer* cs_timer;// 总定时器

@property(strong,nonatomic) NSString* whole_second;// 总秒数-字符串类型

@property(strong,nonatomic) NSMutableArray* resume_pause_time_point_array;// 点击开始（恢复）记录时间点（数组）
@property(strong,nonatomic) KAThread* myThread; // 多线程对象

-(IBAction)end:(id)sender; // 点停止按钮触发事件
-(IBAction)resume:(id)sender;// 点击开始（恢复）按钮触发事件

-(void)initSubThread; // 初始化线程对象




@end
