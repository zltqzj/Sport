//
//  StatsViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//  待解决问题：异步，地图界面右滑按钮。定时判断是否开启。 

#import "StatsViewController.h"

static int b = 0;
typedef NS_ENUM(NSInteger, kTTCounter){
    kTTCounterRunning = 0,
    kTTCounterStopped,
    kTTCounterReset,
    kTTCounterEnded
};
@interface StatsViewController ()

@end

@implementation StatsViewController

-(void)beginActivity{     // 定时器开始触发的方法
    
    NSLog(@"cs定时器走没走%@",[NSString stringWithFormat:@"%d",b]);
    _whole_second =[NSString stringWithFormat:@"%d",++b];
    [[MyManager sharedManager] setWhole_time:_whole_second];
        [self calculate_h_m_s:_whole_second];
    
        if (_cs_timer.isPaused) {
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectPoint" object:self userInfo:nil];
        }
    
}


-(void)calculate_h_m_s:(NSString*)wholeSecond{  // 显示-时-分-秒 方法
    
    int  w_second = [wholeSecond doubleValue];
    int hour = w_second / 3600;
    int minute = w_second % 3600 /60;
    int second = w_second %3600 %60;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hour<10) {
            _lblHour.text = [NSString stringWithFormat:@"0%d",hour];
        }else{
            _lblHour.text = [NSString stringWithFormat:@"%d",hour];
        }
        
        if (minute<10) {
            _lblMinite.text = [NSString stringWithFormat:@"0%d",minute];
        }else{
            _lblMinite.text = [NSString stringWithFormat:@"%d",minute];
            
        }
        
        if (second<10) {
            _lblSeconds.text = [NSString stringWithFormat:@"0%d",second];
        }else{
            _lblSeconds.text = [NSString stringWithFormat:@"%d",second];
        }

    });
    
    
}


-(IBAction)end:(id)sender{     // 点击停止触发的事件
    NSLog(@"完成");
    [_cs_timer pause];
    [[MyManager sharedManager] setSection:0];
     [_myThread performSelector:@selector(finishActivity) onThread:_myThread withObject:nil waitUntilDone:NO];
 
}

-(IBAction)resume:(id)sender{    // 点击开始（恢复）触发的事件
   
        if (b == 0) {
            _cs_timer = [CSPausibleTimer timerWithTimeInterval:1 target:self selector:@selector(beginActivity) userInfo:nil repeats:YES];
            NSLog(@"第一次启动");
           // _myThread.beginCollect = YES;
           // [self performSelector:@selector(doOtherTask) onThread:(_myThread) withObject:nil waitUntilDone:NO];
             [_myThread performSelector:@selector(startRunLoop) onThread:_myThread withObject:nil waitUntilDone:NO];
        
                     
            [_resume_pause_time_point_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"begin", nil]];
            [[MyManager sharedManager] setSection:[[MyManager sharedManager] section]+1];
            [_cs_timer start];
        }
        else if (b!=0 && [_cs_timer isPaused]){
            [_cs_timer start];
            [[MyManager sharedManager] setSection:[[MyManager sharedManager] section]+1];
               NSLog(@"恢复");
            [_myThread performSelector:@selector(resumeRunLoop) onThread:_myThread withObject:nil waitUntilDone:NO];
             [_resume_pause_time_point_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"resume", nil]];
        }
        else{
            [_cs_timer pause];
               NSLog(@"暂停");
            [_myThread performSelector:@selector(stopRunLoop) onThread:_myThread withObject:nil waitUntilDone:NO];
             [_resume_pause_time_point_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"pause", nil]];
            // 把5秒那个定时器也关掉
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stop_collectPoint" object:self userInfo:nil];
            [[MyManager sharedManager] setIfDrawLine:NO];
        }
 
    
    
    NSLog(@"****%@",_resume_pause_time_point_array);
    
}


// 显示总公里数
-(void)show_total_distance:(NSNotification*)info{
    NSLog(@"----%@",info);
    NSString* str = [info.userInfo objectForKey:@"_total_distance"];
    double  d = [str doubleValue]/1000;
    _lblTotalDistance.text = [NSString stringWithFormat:@"%.2f",d];
    str = [info.userInfo objectForKey:@"current_split_pace"];
    _lbsplitpace.text = [NSString stringWithFormat:@"%@",str];

}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show_total_distance:) name:@"_total_distance" object:nil];
    _resume_pause_time_point_array = [[NSMutableArray alloc] initWithCapacity:10];
    
   
    [PSLocationManager sharedLocationManager].delegate = self;
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
  
}


-(void)initSubThread{   // 初始化线程对象（在recordviewcontroller里调用）
    _myThread = [[KAThread alloc] init];
    [_myThread start];
}


#pragma mark --- PSLocationManagerDelegate GPS强度

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    NSString *strengthText;
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        strengthText = NSLocalizedString(@"Weak", @"");
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        strengthText = NSLocalizedString(@"Strong", @"");
    } else {
        strengthText = NSLocalizedString(@"...", @"");
    }
    
   // self.strengthLabel.text = strengthText;
  
     _strength.text = strengthText;
     
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    //self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
    debugLog(NSLocalizedString(@"Consistently Weak", @""));
    _strength.text = @"Consistently Weak";
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
   // self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"meters", @"")];
  
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
   // self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
}

#pragma mark - Others 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
