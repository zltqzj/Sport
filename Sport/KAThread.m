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
    // 测试一下卡路里算法
    _lastpoint = [[NSMutableDictionary alloc] initWithCapacity:5];
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

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)finishActivity{   // 点击停止按钮触发的事件
    [self stopRunLoop];
 
   _lastlocal_meta_data = nil;
   NSMutableArray*   _tempArray = [[NSMutableArray alloc] initWithCapacity:10];
   _tempArray = [_file_manager searchPointFromFile];
   if (_tempArray.count == 0)
       _tempArray = [NSMutableArray arrayWithArray:_points];
   else
       [_tempArray addObjectsFromArray:_points];
    //NSArray* list_location = [NSArray arrayWithArray:_tempArray];
 NSData* data =  [NSKeyedArchiver archivedDataWithRootObject:_tempArray];
   [data writeToFile:[_file_manager fileName] atomically:YES];
    
    
    
  //  NSDictionary* dict =[act activityDictWithID:@"1" user_id:@"1" flag:@"1" start_date:@"" start_date_local:@"" time_zone:@"" location_city:@"" location_province:@"" location_country:@"" start_latitude:@"" start_longitude:@"" end_latitude:@"" end_logitude:@"" moving_time:@"" elapsed_time:@"" name:@"" description:@"" tag:@"" type:@"" total_elevation_gain:@"" total_distance:@"" manual:@"" private_flag:@"" average_speed:@"" average_pace:@"" max_speed:@"" average_heartrate:@"" max_heartrate:@"" calories:@"" brocast:@"" like_count:@"" comments_count:@"" awards_count:@"" device:@"" lastsynctime:@"" list:list_location];
    
  //  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"va",@"k", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"va",@"k", nil],nil],@"list_location", nil];
    
//    for (int i=0; i<2; i++) {
//        NSDictionary* dict = [_tempArray objectAtIndex:i];
//        
//    }
    
    
//    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"list_location", nil];
//    NSLog(@"%@",dict);
//    
//    NSString* value = [dd JSONString];
//    NSLog(@"%@,%@",_tempArray, value );
    
 
//    NSString *str = nil;
//    NSArray *firstArr = [NSArray arrayWithObjects:@"first",@"second", nil];
//    //基本数据类型转换成NSNumber类型
//    NSArray *secondArr = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil],[NSNumber numberWithBool:NO], nil];
//    //加到字典中
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:firstArr,@"first",secondArr,@"second", nil];
//    //转化成json格式
//    NSLog(@"%@",dic);
//    str = [dic JSONString];
//    NSLog(@"%@",str);
//    NSString *str2 = [NSString stringWithString:str];
//    NSLog(@"str3:%@",str2);
    
    /*
    ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_ACTIVITY]];
    _request = req;
    [_request setResponseEncoding:NSUTF8StringEncoding];
   // [_request setPostValue:value forKey:@"activitydata"];
    [_request startAsynchronous];
    [_request setCompletionBlock:^{
        NSLog(@"返回值%@",[_request responseString]);
    }];
    [_request setFailedBlock:^{
          NSLog(@"%@",[_request responseString]);
    }];
     */
    
     _netUtil  = [[NetUtils alloc] init];
    
    
     // 测试一下json
     Activity* act = [[Activity alloc] init];
     NSDictionary* dict =[act activityDictWithID:@"1" user_id:@"1" flag:@"1" start_date:@"" start_date_local:@"" time_zone:@"" location_city:@"" location_province:@"" location_country:@"" start_latitude:@"" start_longitude:@"" end_latitude:@"" end_logitude:@"" moving_time:@"" elapsed_time:@"" name:@"" description:@"" tag:@"" type:@"" total_elevation_gain:@"" total_distance:@"" manual:@"" private_flag:@"" average_speed:@"" average_pace:@"" max_speed:@"" average_heartrate:@"" max_heartrate:@"" calories:@"" brocast:@"" like_count:@"" comments_count:@"" awards_count:@"" device:@"" lastsynctime:@"" list:_tempArray];
     SBJsonWriter *writer = [[SBJsonWriter alloc] init];
     NSLog(@"Start Create JSON!");
     NSString *value = [writer stringWithObject: dict];
     NSLog(@"%@",value);
     
     ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_ACTIVITY]];
     [request setPostValue:value forKey:@"activitydata"];
     _request = request;
     [_request startAsynchronous];
     [_request setCompletionBlock:^{
     NSLog(@"返回值%@",[_request responseString]);
     }];
     [_request setFailedBlock:^{
     NSLog(@"返回值%@",[_request responseString]);
     }];
    

    
   __block  int sum_whole = 0;
    __block  int sum_sport = 0;
    __block  int sum_disactive = 0;
    __block  NSString * last_section;

  [_tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

       sum_whole +=  [[obj objectForKey:@"time_span"] intValue];
       if (idx > 0)
       {
            if ([last_section isEqualToString: [obj objectForKey:@"section"]]) //当section无变化的时候，累计时间间隔
            {
                sum_sport += [[obj objectForKey:@"time_span"] intValue];
            }
           else{   //当section有变化的时候，此时间间隔不算
               sum_disactive += [[obj objectForKey:@"time_span"] intValue];
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
            
        
        int  inteval_time = 0;
        if (nil != _points) { // 计算时间间隔
            NSDate* time = [DayManagement dateFromeStringWithTime:[_lastlocal_meta_data objectForKey:@"time"]] ;
            if (time == nil)
                inteval_time = 0 ;
            else
                inteval_time = [location.timestamp timeIntervalSince1970] -[time timeIntervalSince1970];
            
        }
        CLLocationCoordinate2D trans = [self zzTransGPS:location.coordinate]; // 校正坐标
        
        int xsection = (int)(_main_total_distance/1000+1);// 按每公里算段数

        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",trans.latitude] forKey:@"LATITUDE"];//1
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",trans.longitude] forKey:@"LONGITUDE"];//2
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.speed] forKey:@"SPEED"];//3
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.altitude] forKey:@"ALTITUDE"];//4
        [loc_meta_data setValue:[[MyManager sharedManager] whole_time]  forKey:@"INTERVAL"];
       [loc_meta_data setValue:@""  forKey:@"HEARTRATE"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%ld",(long)[[MyManager sharedManager] section]] forKey:@"section"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%d",xsection] forKey:@"SECTION"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%d",inteval_time] forKey:@"time_span"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%@",location.timestamp]  forKey:@"TIME"];
        if (_points.count > 0) {
            CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
            NSLog(@"距离%f",distance);
            _main_total_distance = _main_total_distance + distance;
            
            //算卡路里需要的两个值（两点间的距离间隔和时间间隔）
             float cal = [self calculate_caloriesWithActivity_type:@"run" weight:@"50" distance:[NSString stringWithFormat:@"%f",distance] seconds:[NSString stringWithFormat:@"%d",inteval_time]];
            _calories+= cal;
            NSLog(@"%f",_calories);
            
            if (nClear >= 3)
            {
            //计算分段信息
                [self getSectionFristPoint:xsection];
      
                float total_interval  = [[[MyManager sharedManager] whole_time] floatValue];
                float last_dis =[[_lastpoint objectForKey:@"dis"] floatValue];
                float last_interval =[[_lastpoint objectForKey:@"interval"] floatValue];
                
                // 第xsection段的距离，第xsection段的时间
                float n_distance = _main_total_distance-last_dis;
                float n_time = total_interval- last_interval;
                
                float pace = [self count_split_pace:n_distance interval:n_time];// 某时刻的配速
                
                NSString* pace_string = [self get_pace_string:(int)pace];
                NSLog(@"第%d段,已走总长度：%f,第n段第一个点的总长度： %f,第n段第一个点的总时间： %f,浮点型配速： %f,字符串配速： %@",xsection,_main_total_distance,last_dis,last_interval,pace,pace_string);
        
                _total_distance = [NSString stringWithFormat:@"%.2f",_main_total_distance];
                // 准备传到status界面的值
                _dict_total_distance = [NSDictionary dictionaryWithObjectsAndKeys:_total_distance,@"_total_distance",pace_string,@"current_split_pace",[NSString stringWithFormat:@"%.2f",_calories],@"calories",nil];// 字典，包括要传过去的“总距离”和“配速”
                nClear = 0;
                
                
                
                // 准备传到split界面的值
                NSDictionary* xsection_info = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",xsection],@"xsection",[NSString stringWithFormat:@"%@",pace_string],@"pace_string",[NSString stringWithFormat:@"%f",pace],@"pace", nil];
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
          
            [loc_meta_data setValue:_total_distance forKey:@"DISTANCE"];//6
            
        }
        else{
            [loc_meta_data setValue:@"0" forKey:@"distance"];
             [loc_meta_data setValue:@"0"  forKey:@"interval"];
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
-(void) getSectionFristPoint:(int)Section{
    
    if(Section==1){
        
        [_lastpoint setValue:@"0" forKey:@"dis"];
        [_lastpoint setValue:@"0" forKey:@"interval"];
        [_lastpoint setValue:@"0" forKey:@"lastIdx"];
        
    }
    else{
        
        NSMutableArray* _xpoints = [[NSMutableArray alloc] initWithCapacity:5];
        _xpoints = [_file_manager searchPointFromFile];
        if (_xpoints.count == 0)
            _xpoints = [NSMutableArray arrayWithArray:_points];
        else
            [_xpoints addObjectsFromArray:_points];
        
        for(int i=[[_lastpoint objectForKey:@"lastIdx"] intValue];i<_xpoints.count;i++){
        
            NSDictionary* obj = (NSDictionary*)_xpoints[i];
           
            float current_distance = [[obj objectForKey:@"distance"] floatValue];
            float current_interval = [[obj objectForKey:@"interval"] floatValue];
            
            if(current_distance>=(Section-1)*1000){
               
                
              [_lastpoint setValue:[NSString stringWithFormat:@"%f",current_distance] forKey:@"dis"];
              [_lastpoint setValue:[NSString stringWithFormat:@"%f",current_interval] forKey:@"interval"];
              [_lastpoint setValue:[NSString stringWithFormat:@"%d",i]   forKey:@"lastIdx"];
              break ;
            }
        
        }
        
        [_xpoints removeAllObjects];

    
    }
    
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


-(float)calculate_caloriesWithActivity_type:(NSString*)activity_type weight:(NSString*)weight distance:(NSString*)distance seconds:(NSString*)seconds   { // 体重（公斤）  距离（千米） 时间间隔（秒）
    float MET = 3.5;
    float weight_d = [weight floatValue];
    float distance_d = [distance floatValue];
    float seconds_d = [seconds floatValue];
    float hours = seconds_d / 3600;
    float total_dis_mile = distance_d * 0.62137119;
    float mph = total_dis_mile / hours;
    
    if ([seconds isEqualToString:@"0"]) {
        return 0;
    }

    else if ([activity_type isEqualToString:@"run"]) {
       if (mph < 2.0)
            MET = 2.0;
       else if (mph >= 2.0 && mph<2.5)
            MET = 2.5;
       else if (mph >= 2.5 && mph<3.0)
            MET = 3.0;
       else if (mph>=3.0 && mph<3.3)
            MET  = 3.3;
       else  if (mph >=3.5 && mph<4)
            MET = 3.8;
       else if (mph >=4 && mph<4.5)
            MET = 5.0;
       else if (mph >=4.5&& mph<5)
            MET = 6.3;
       else if (mph >=5 && mph<5.2)
            MET = 8.0;
       else  if (mph >=5.2 && mph<6)
            MET = 9.0;
       else if (mph >=6 && mph<6.7)
            MET = 10.0;
       else if (mph >=6.7 && mph<7)
            MET = 11.0;
       else if (mph >7 && mph<7.5)
            MET = 11.5;
       else  if (mph >=7.5 && mph<8)
            MET = 12.5;
       else if (mph >= 8.0 && mph<8.6)
            MET = 13.5;
       else if (mph >=8.6 && mph<9)
            MET = 14;
       else if (mph >=9 && mph<10)
           MET = 15;
       else if (mph >=10 && mph<10.9)
           MET = 16;
       else if (mph >=10.9)
           MET = 16;
        
    }
    else if ([activity_type isEqualToString:@"ride"]){
        if (mph<10)
            MET = 4.0;
        else   if (mph>=10 && mph<12)
            MET = 6.0;
        else if (mph>=12 && mph<14)
            MET = 8.0;
        else if (mph>=14 && mph<16)
            MET = 10.0;
         else if (mph>=16 && mph<20)
             MET = 12.0;
        else if (mph>20)
            MET = 16.0;
    }
    
    float cal = MET * weight_d* hours;
   // return [NSString stringWithFormat:@"%.2f",cal];
    return cal;
    
}


 @end
