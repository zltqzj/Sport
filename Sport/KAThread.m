//
//  KAThread.m
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//  split 卡路里，save

#import "KAThread.h"
#import "KANullInputSource.h"
#import "MapViewController.h"
#import "AppDelegate.h"
@implementation KAThread

@synthesize file_manager = _file_manager;
#pragma mark - 自定义方法 CustomFunction

+ (id)sharedManager{   // 暂时不用，本想用作单例
    static KAThread *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)main {   // 线程启动
    m_sqlite = [[CSqlite alloc]init];
    [m_sqlite openSqlite];
    _file_manager = [[FileManager alloc] init];
    _splist_array = [[NSMutableArray alloc] initWithCapacity:5];
    //[_splist_array addObject:@"null"];
    _points = [[NSMutableArray alloc] initWithCapacity:5];
    _pointsToDraw = [[NSMutableArray alloc] initWithCapacity:5];
    [[[KANullInputSource alloc] init] addToCurrentRunLoop] ;
  
 
    _timer =   [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(didTimer) userInfo:nil repeats:YES];
    [_timer start];
    
    _timercal =   [CSPausibleTimer timerWithTimeInterval:2 target:self selector:@selector(didTimerCal) userInfo:nil repeats:YES];
   // [_timercal start];
    
    [self initMap];
    [[NSRunLoop currentRunLoop] addTimer:_timer.timer forMode:NSDefaultRunLoopMode];
    //CFRunLoopRun();
    while (!self.isCancelled) {
        BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"after runloop counting.........: %d", ret);

    }
}

- (void)stopRunLoop {   //收到暂停消息触发的事件
   
    NSLog(@"收到暂停消息");
    _beginCollect = NO;
    [_timer pause];
}

-(void)resumeRunLoop{    // 收到resume消息触发的事件
    _beginCollect = YES;
    NSLog(@"收到resume消息");
    [_timer start];
}

-(void)startRunLoop{   // 收到开始消息触发的事件
    NSLog(@"收到start消息");
    _beginCollect = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[_file_manager fileName]  error:nil];

}

-(void)finishActivity{   // 点击停止按钮触发的事件
    [_timer pause];
    
   _lastlocal_meta_data = nil;
   NSMutableArray*   _tempArray = [[NSMutableArray alloc] initWithCapacity:10];
   _tempArray = [_file_manager searchPointFromFile];
    
    
    
   if (_tempArray.count == 0)
       _tempArray = [NSMutableArray arrayWithArray:_points];
   else
       [_tempArray addObjectsFromArray:_points];

 NSData* data =  [NSKeyedArchiver archivedDataWithRootObject:_tempArray];
   [data writeToFile:[_file_manager fileName] atomically:YES];
   __block  double sum_whole = 0;
    __block  double sum_sport = 0;
    __block  double sum_disactive = 0;
    __block  NSString * last_section;

  [_tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

       sum_whole +=  [[obj objectForKey:@"time_span"] doubleValue];
       if (idx > 0)
       {
            if ([last_section isEqualToString: [obj objectForKey:@"section"]]) //当section无变化的时候，累计时间间隔
            {
                sum_sport += [[obj objectForKey:@"time_span"] doubleValue];
            }
           else{   //当section有变化的时候，此时间间隔不算
               sum_disactive += [[obj objectForKey:@"time_span"] doubleValue];
            }

      }
       last_section = [obj objectForKey:@"section"];
    }];
 
   
   [_tempArray removeAllObjects];
    
    [_points removeAllObjects];

}


-(void)didTimer{   // 定时器触发的方法
    
    if ([[[MyManager sharedManager] ifDrawLine] isEqualToString:@"YES"] && _beginCollect ==YES &&_points.count!=0) {
        _pointsToDraw = [_file_manager searchPointFromFile];
        if (_pointsToDraw.count == 0)
            _pointsToDraw = [NSMutableArray arrayWithArray:_points];
        else
            [_pointsToDraw addObjectsFromArray:_points];
       
        
        
        //通知主线程UpdateUI
        AppDelegate*   delegate = [AppDelegate sharedAppDelegate];
        [delegate performSelectorOnMainThread:@selector(UPDateMainMap:) withObject:_pointsToDraw waitUntilDone:NO];
        
      
    }
}

-(void)didTimerCal{   // 定时器触发的方法
    
    //通知主线程UpdateUI
//    AppDelegate*   delegate = [AppDelegate sharedAppDelegate];
//    [delegate performSelectorOnMainThread:@selector(UPMainStats:) withObject:_dict_total_distance waitUntilDone:NO];
}

-(void)mapDidLoad //用于mapview激活的时候需要看是否要画图
{
    _pointsToDraw = [_file_manager searchPointFromFile];
    if (_pointsToDraw.count == 0)
        _pointsToDraw = [NSMutableArray arrayWithArray:_points];
    else
        [_pointsToDraw addObjectsFromArray:_points];
    
    
    if (_pointsToDraw.count>0) {
        //通知主线程UpdateUI
        AppDelegate*   delegate = [AppDelegate sharedAppDelegate];
        [delegate performSelectorOnMainThread:@selector(UPDateMainMap:) withObject:_pointsToDraw waitUntilDone:NO];

    }
}

-(void)switchMainTab:(NSNumber*)number{   // 暂时不用
    NSLog(@"主页面切换");
    if ([number isEqualToNumber:[NSNumber numberWithInteger:2]] ) {
        [self mapDidLoad];
    }
}


-(void)initMap{  // 初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyNearestTenMeters; // 跑步和骑车区分
    _locationManager.distanceFilter  = 5.0f;
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    [_locationManager startUpdatingLocation];
    
}

#pragma  mark - 定位的代理方法 CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"改变权限");
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    static int nClear = 0;
    nClear++;
    if (_beginCollect == YES) { // 定时器开启就开始收集所有的点
        NSMutableDictionary* loc_meta_data = [[NSMutableDictionary alloc] initWithCapacity:10];
        CLLocation *location = [locations lastObject];
    
        NSLog(@"角度%f",location.course);
        NSLog(@"我的高度%f",location.altitude);
        NSLog(@"我的速度%f",location.speed);
        NSLog(@"时间戳%@",location.timestamp);
        // check the zero point
        if  (location.coordinate.latitude == 0.0f ||
             location.coordinate.longitude == 0.0f)
            return;
        if (location.speed < MIN_DISTANCE)  // 当速度小于最小值，返回
            return;
            
        
        NSTimeInterval inteval_time = 0;
        if (nil != _points) { // 计算时间间隔
            NSDate* time = [_lastlocal_meta_data objectForKey:@"time"];
            if (time == nil)
                inteval_time = 0 ;
            else
                inteval_time = [location.timestamp timeIntervalSinceDate:time];
            
        }
        CLLocationCoordinate2D trans = [self zzTransGPS:location.coordinate]; // 校正坐标
        
        int xsection = (int)(_main_total_distance/1000+1);// 按每公里算段数

        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",trans.latitude] forKey:@"latitude"];//1
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",trans.longitude] forKey:@"logitude"];//2
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.speed] forKey:@"speed"];//3
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.altitude] forKey:@"altitude"];//4
        [loc_meta_data setValue:location.timestamp forKey:@"time"];//5
        [loc_meta_data setValue:[[MyManager sharedManager] whole_time]  forKey:@"interval"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%ld",(long)[[MyManager sharedManager] section]] forKey:@"section"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%d",xsection] forKey:@"section_by_distance"];
        [loc_meta_data setValue:[NSNumber numberWithDouble:inteval_time] forKey:@"time_span"];
        if (_points.count > 0) {
            CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
            NSLog(@"距离%f",distance);
            _main_total_distance = _main_total_distance + distance;
            
            if (nClear >= 3)
            {
            //计算分段信息
                NSMutableDictionary* lastpoint = [self getSectionFristPoint:xsection];
      
                float total_interval  = [[[MyManager sharedManager] whole_time] floatValue];
                float last_dis =[[lastpoint objectForKey:@"dis"] floatValue];
                float last_interval =[[lastpoint objectForKey:@"interval"] floatValue];
                
                // 第xsection段的距离，第xsection段的时间
                float n_distance = _main_total_distance-last_dis;
                float n_time = total_interval- last_interval;
                
                float pace = [self count_split_pace:n_distance interval:n_time];// 某时刻的配速
                
                NSString* pace_string = [self get_pace_string:(int)pace];
                NSLog(@"第%d段,已走总长度：%f,第n段第一个点的总长度： %f,第n段第一个点的总时间： %f,浮点型配速： %f,字符串配速： %@",xsection,_main_total_distance,last_dis,last_interval,pace,pace_string);
        
                _total_distance = [NSString stringWithFormat:@"%.2f",_main_total_distance];
                // 准备传到status界面的值
                _dict_total_distance = [NSDictionary dictionaryWithObjectsAndKeys:_total_distance,@"_total_distance",pace_string,@"current_split_pace",nil];// 字典，包括要传过去的“总距离”和“配速”
                nClear = 0;
                
                
                
                // 准备传到split界面的值
                NSDictionary* xsection_info = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",xsection],@"xsection",[NSString stringWithFormat:@"%@",pace_string],@"pace_string", nil];
                NSLog(@"%@",xsection_info);
                // 在数组中查找，如果第xsection项有，就replace ,如果没有则addobject（注意数组下标越界）
                if (_splist_array.count == xsection-1) {
                    [_splist_array addObject:xsection_info];
                    NSLog(@"%@",_splist_array);
                }
                else if (_splist_array.count == xsection){
                    [_splist_array setObject:xsection_info atIndexedSubscript:xsection-1];
                }

                AppDelegate*   delegate = [AppDelegate sharedAppDelegate];
                [delegate performSelectorOnMainThread:@selector(updateSplitData:) withObject:_splist_array waitUntilDone:NO];
                [delegate performSelectorOnMainThread:@selector(UPMainStats:) withObject:_dict_total_distance waitUntilDone:NO];
            }
          
            [loc_meta_data setValue:_total_distance forKey:@"distance"];//6
            
        }
        
        _currentLocation = location;
        
        
        // 判断_points.count 个数
        if (_points.count ==  MAX_POINT ) {
            
            NSMutableArray*   _tempArray = [[NSMutableArray alloc] initWithCapacity:10];
            _tempArray = [_file_manager searchPointFromFile];
            if (_tempArray.count == 0)
                _tempArray = [NSMutableArray arrayWithArray:_points];
            else
                [_tempArray addObjectsFromArray:_points];
            
            NSData* data =  [NSKeyedArchiver archivedDataWithRootObject:_tempArray];
            [data writeToFile:[_file_manager fileName] atomically:YES];
            [_tempArray removeAllObjects];
            
            [_points removeAllObjects];
            
        }
        
        [_points addObject:loc_meta_data];
        _lastlocal_meta_data =  loc_meta_data;
       
        
    }
    
}
// 返回第n段的第一个点的总距离和总时间
- (NSMutableDictionary*) getSectionFristPoint:(int)Section{
    NSMutableDictionary* point = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    if(Section==1){
        
        [point setValue:@"0" forKey:@"dis"];
        [point setValue:@"0" forKey:@"interval"];
        
    }
    else{
        
        NSMutableArray* _xpoints = [[NSMutableArray alloc] initWithCapacity:5];
        _xpoints = [_file_manager searchPointFromFile];
        if (_xpoints.count == 0)
            _xpoints = [NSMutableArray arrayWithArray:_points];
        else
            [_xpoints addObjectsFromArray:_points];
        
        for(int i=0;i<_xpoints.count;i++){
        
            NSDictionary* obj = (NSDictionary*)_xpoints[i];
           
            float current_distance = [[obj objectForKey:@"distance"] floatValue];
            float current_interval = [[obj objectForKey:@"interval"] floatValue];
            
            if(current_distance>=(Section-1)*1000){
               
                
              [point setValue:[NSString stringWithFormat:@"%f",current_distance] forKey:@"dis"];
              [point setValue:[NSString stringWithFormat:@"%f",current_interval] forKey:@"interval"];
              
              return point;
            }
        
        }
        
        [_xpoints removeAllObjects];
        
        
    
    }
    
    
    return  point;
    
}

//计算每公里的配速
- (float) count_split_pace:(float)dis interval:(float)interval {
    float pace_sec = (float)interval*1000/dis;
    
    return pace_sec;
    
}

// 返回配速的字符串值
- (NSString*) get_pace_string:(int)pace_interval {
    
    int hour = pace_interval / 3600;
    int minute = pace_interval % 3600 /60;
    int second = pace_interval %3600 %60;
    NSString* pace_string = nil;
    if (hour > 0 ) {
          pace_string =   [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }
    else{
          pace_string =   [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
       return pace_string;
    
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    // [TSMessage showNotificationInViewController:self title:@"定位失败" subtitle:@"定位失败" type:TSMessageNotificationTypeWarning];
    
}



// 火星坐标转换
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
   
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
    
    
}

 @end
