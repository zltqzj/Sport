//
//  MyLocationThread.m
//  Sport
//
//  Created by zhaojian on 14-6-13.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "MyLocationThread.h"

@implementation MyLocationThread
@synthesize timer = _timer;
@synthesize locationManager = _locationManager;

-(void)myrun{
    _source = [[RunLoopSource alloc] init];
    [_source addToCurrentRunLoop];
    
    self.isCancelled = NO;
    NSLog(@"线程以启动");
    _timer =   [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(didTimer) userInfo:nil repeats:YES];
    [_timer start];
    [self initMap];
    [[NSRunLoop currentRunLoop] addTimer:_timer.timer forMode:NSDefaultRunLoopMode];
    while (!self.isCancelled) {
        //[self doOtherTask];
        BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"after runloop counting.........: %d", ret);
    }}

-(void)didTimer{
    NSLog(@"定时器~~~~");
}

-(void)doOtherTask{
    
}

-(void)initMap{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyNearestTenMeters; // 跑步和骑车区分
    _locationManager.distanceFilter  = 5.0f;
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    [_locationManager startUpdatingLocation];
 
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"改变权限");
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    
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
        NSTimeInterval inteval_time = 0;
        if (nil != _points) { // 计算时间间隔
            NSDate* time = [_lastlocal_meta_data objectForKey:@"time"];
            if (time == nil)
                inteval_time = 0 ;
            else
                inteval_time = [location.timestamp timeIntervalSinceDate:time];
            NSLog(@"%@",[NSNumber numberWithDouble:inteval_time]);
        }
        
        
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];//1
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"logitude"];//2
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.speed] forKey:@"speed"];//3
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.altitude] forKey:@"altitude"];//4
        [loc_meta_data setValue:location.timestamp forKey:@"time"];//5
        [loc_meta_data setValue:[[MyManager sharedManager] whole_time]  forKey:@"interval"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%ld",(long)[[MyManager sharedManager] section]] forKey:@"section"];
        [loc_meta_data setValue:[NSNumber numberWithDouble:inteval_time] forKey:@"time_span"];
        if (_points.count > 0) {
            CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
            NSLog(@"距离%f",distance);
            _main_total_distance = _main_total_distance+distance;
            _total_distance = [NSString stringWithFormat:@"%.2f",_main_total_distance];
            
            NSDictionary* dict_total_distance = [NSDictionary dictionaryWithObjectsAndKeys:_total_distance,@"_total_distance", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"_total_distance" object:nil userInfo:dict_total_distance];
            [loc_meta_data setValue:_total_distance forKey:@"distance"];//6
            
            
        }
        
        _currentLocation = location;
        
        
        // 判断_points.count 个数
        if (_points.count ==  MAX_POINT ) {
            
            NSMutableArray*   _tempArray = [[NSMutableArray alloc] initWithCapacity:10];
            _tempArray = [self searchPointFromFile];
            if (_tempArray.count == 0)
                _tempArray = [NSMutableArray arrayWithArray:_points];
            else
                [_tempArray addObjectsFromArray:_points];
            
            NSData* data =  [NSKeyedArchiver archivedDataWithRootObject:_tempArray];
            [data writeToFile:[self fileName] atomically:YES];
            [_tempArray removeAllObjects];
            
            [_points removeAllObjects];
            
        }
        
        [_points addObject:loc_meta_data];
        _lastlocal_meta_data =  loc_meta_data;
        NSLog(@"-------%@",_lastlocal_meta_data);
        
    }
    
}

-(NSMutableArray*)searchPointFromFile{
    //NSData* data = [NSKeyedUnarchiver unarchiveObjectWithData:data  ];
    NSData *data = [NSData dataWithContentsOfFile:[self fileName]];
    if (data == nil)
        return nil;
    NSMutableArray* point_array = [NSKeyedUnarchiver unarchiveObjectWithData:data  ];
    return point_array;
}

-(NSString*)fileName{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"point.rtf"];
    return filename;
}
//NSString *testPath = [documentsPath stringByAppendingPathComponent:@"test.txt"];
//NSString *content=@"测试12123123121写入内容！";
//NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:testPath];
//[myHandle seekToEndOfFile];
//
//[myHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    // [TSMessage showNotificationInViewController:self title:@"定位失败" subtitle:@"定位失败" type:TSMessageNotificationTypeWarning];
    
}

-(id)init{
    if (self == [super init]) {
       // self =   [super initWithTarget:self selector:@selector(myrun) object:nil];
        _points = [[NSMutableArray alloc] initWithCapacity:5];
        _pointsToDraw = [[NSMutableArray alloc] initWithCapacity:5];
        
        [MyLocationThread detachNewThreadSelector:@selector(myrun) toTarget:self withObject:nil];
    }
    return self;
}

@end
