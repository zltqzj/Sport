//
//  KAThread.h
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSqlite.h"
#import "CSPausibleTimer.h"
#import "Activity.h"
#import "FileManager.h"
#import "NetUtils.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@interface KAThread : NSThread<CLLocationManagerDelegate>
{
     CSqlite *m_sqlite;
}

@property(strong,nonatomic) CLLocation* currentLocation; // 我当前的位置

@property(strong,nonatomic) CSPausibleTimer* timer;  // 划线定时器
@property(strong,nonatomic) CSPausibleTimer* timercal;  // 划线定时器
@property (nonatomic, retain) CLLocationManager* locationManager; // 定位对象
@property (strong,nonatomic) CLGeocoder* myGeocoder;// 地理编码对象
@property (nonatomic, retain) NSMutableArray* points; // 临时收集点的数组

@property(nonatomic,strong) NetUtils* netUtil ;
@property (nonatomic, retain) Activity* activities; // 活动的对象

@property(assign,nonatomic) NSString* total_distance; // 总公里数，要传给定时器页面显示的
@property(strong,nonatomic) NSDictionary* dict_total_distance; // 存放传到主线程的两个值：实时的总公里数和实时配速

@property(assign,nonatomic) double main_total_distance;
@property(assign,nonatomic) float calories;

@property(assign,nonatomic) BOOL beginCollect;// 点击开始此值变为YES

@property (strong,nonatomic) NSDictionary* lastlocal_meta_data;// 记录上一个点的信息，为求时间间隔

@property(strong,nonatomic) NSMutableArray* pointsToDraw;// 实际划线的点

@property(assign,nonatomic) BOOL isCancelled; // 取消线程

@property (strong,nonatomic) FileManager* file_manager;  // 文件管理类

@property(strong,nonatomic) NSMutableArray* splist_array;// 分段数据的数组

@property (strong,nonatomic)  NSMutableDictionary* lastpoint;// 计算配速用到的第n段的第一个点

@property(weak,nonatomic) ASIFormDataRequest* request ;

+ (id)sharedManager; // 暂时不用，本想用作单例

 
- (void)stopRunLoop;  //收到暂停消息触发的事件

- (void)startRunLoop; // 收到开始消息触发的事件

-(void)resumeRunLoop;  // 收到resume消息触发的事件
-(void)switchMainTab:(NSNumber*)number; // 暂时不用

-(void)finishActivity; // 点击停止按钮触发的事件

-(void)mapDidLoad; //用于mapview激活的时候需要看是否要画图

// 计算卡路里的函数


@end
