//
//  MapViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
// 最后一个点取一下
// 存储
// 第一次定位拿街道信息，存到对象里
// gps信号强度判断,GPS状态（全局）
// 坐标偏移
//  起点标注，终点，公里标注，点击标注callout
// breadcrumb
// map 10s刷一次
// ssplit 20s
// stats 距离和 20s

#import "MapViewController.h"
static BOOL beginCollect = NO;

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize centerPoint = _centerPoint;
@synthesize timer = _timer;
@synthesize myGeocoder = _myGeocoder;
@synthesize points = _points;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize locationManager = _locationManager;
@synthesize displayLocation = _displayLocation;
@synthesize annoArray = _annoArray;
@synthesize activities= _activities;
@synthesize total_distance = _total_distance;


#pragma mark - MY FUNCTIONS

-(void)collectPoint{ // 点击定时器“恢复”按钮监听触发的事件
    beginCollect = YES;
 
    
}
-(void)stop_collectPoint{  // 点击定时器“暂停”按钮监听触发的事件
    beginCollect = NO;
}

-(void)initGps_btn{
    UIButton* gps_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gps_btn setImage:[UIImage imageNamed:@"ic_menu_mylocation.png"] forState:UIControlStateNormal];
    NSLog(@"地图高度%f",_mapView.bounds.size.height);
    if (IS_IPHONE5) {
        [gps_btn setFrame:CGRectMake(_mapView.bounds.size.width-48, 480, 38, 38)];
        
    }else
        [gps_btn setFrame:CGRectMake(_mapView.bounds.size.width-48, 300, 38, 38)];
    gps_btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin ;
    [_mapView addSubview:gps_btn];
    [gps_btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [_mapView setCenterCoordinate:_centerPoint.coordinate zoomLevel:13 animated:YES];
    }];
}

-(void)initMap{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectPoint) name:@"collectPoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop_collectPoint) name:@"stop_collectPoint" object:nil];

    _annoArray= [[NSMutableArray alloc] initWithCapacity:10];
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
        if (IS_IPHONE5) {
            [_mapView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = NO;
        self.mapView.userInteractionEnabled = YES;
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        
        [self.view addSubview:self.mapView];
        
        [self initGps_btn];// gps按钮

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy =kCLLocationAccuracyNearestTenMeters; // 跑步和骑车区分
        _locationManager.distanceFilter  = 5.0f;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        [_locationManager startUpdatingLocation];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initMap];
    [self initActivityObject];
    main_total_distance = 0;
    _total_distance = 0;
    _timer = [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(goToDrawLine) userInfo:nil repeats:YES];
    [_timer start];
    

   
}

-(void)goToDrawLine{
        NSLog(@"是否划线%@",[[MyManager sharedManager] ifDrawLine]);
        if ([[[MyManager sharedManager] ifDrawLine] isEqualToString:@"YES"] && beginCollect ==YES &&_points.count!=0) {
            [self configureRoutes];
        }
}



// 划线方法
- (void)configureRoutes
{
    self.mapView.userInteractionEnabled = NO;
    [_mapView removeAnnotations:_annoArray];
       // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	NSLog(@"%@",_points);
    
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    MKMapPoint* pointArray2Draw = nil;
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    if (_points.count ==0) {
        
    }
    else{
        if (self.routeLine) {
            [self.mapView removeOverlay:self.routeLine];
        }

        int nIndex = 0;
        for(int idx = 0; idx < _points.count; idx++)
        {
            NSLog(@"------%d",idx);
            NSDictionary* d = [_points objectAtIndex:idx];
           // CLLocation *location = [_points objectAtIndex:idx];
              latitude  = [[d objectForKey:@"latitude"] doubleValue];
            
              longitude = [[d objectForKey:@"logitude"] doubleValue];
            NSLog(@"%f", longitude);
            // create our coordinate and add it to the correct spot in the array
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            MKMapPoint point = MKMapPointForCoordinate(coordinate);
            
            // if it is the first point, just use them, since we have nothing to compare to yet.
            if (idx == 0) {
                northEastPoint = point;
                southWestPoint = point;
                
            } else {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
             if (idx>0){
                 NSString* a =[[_points objectAtIndex:idx] objectForKey:@"section"];
                 NSString* b =[[_points objectAtIndex:idx-1] objectForKey:@"section"];
                 if ( ![a isEqualToString:b]) {
                     NSLog(@"不同section");
                     
                    if (pointArray2Draw==nil)
                    {
                        pointArray2Draw = malloc(sizeof(CLLocationCoordinate2D) * nIndex);
                        memcpy(pointArray2Draw, pointArray, sizeof(CLLocationCoordinate2D) * nIndex);
                    }
                    self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
                    if (nil != self.routeLine) {
                        [self.mapView addOverlay:self.routeLine]; // add the overlay to the map
                        NSLog(@"划线");
                    }
                    if (pointArray2Draw)
                    {
                        free(pointArray2Draw);
                        pointArray2Draw = nil;
                    }
                    free(pointArray);
                    pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
                    nIndex = 0;
                 }
             }
            
            pointArray[nIndex] = point;
            NSLog(@"%d",nIndex);
           
            nIndex ++ ;
        
        }
        //
      //   NSLog(@"---------%f,%f",lo.coordinate.latitude,lo.coordinate.longitude );
        CLLocationCoordinate2D lo1 = CLLocationCoordinate2DMake(latitude,longitude);
        MapPoint* mmp = [[MapPoint alloc] initWithCoordinate:lo1 title:@"当前位置" subTitle:@""];
       [ _mapView addAnnotation:mmp];
        [_annoArray addObject:mmp];
      
        if (pointArray2Draw == nil)
        {
            pointArray2Draw = malloc(sizeof(CLLocationCoordinate2D) * nIndex);
            memcpy(pointArray2Draw, pointArray, sizeof(CLLocationCoordinate2D) * nIndex);
        }
        self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
        
        if (nil != self.routeLine) {
            [self.mapView addOverlay:self.routeLine]; // add the overlay to the map
            NSLog(@"划线");
        }
        if (pointArray2Draw)
        {
            free(pointArray2Draw);
            pointArray2Draw = nil;
        }
        free(pointArray);
        nIndex = 0;
    }
}


-(void)initActivityObject{
    NSMutableDictionary* dic = [self activityDictWithID:@"1" user_id:@"1" flag:@"1" start_date:[DayManagement stringFromDate:[NSDate date]] start_date_local:[DayManagement stringFromDate:[NSDate date]] time_zone:@"8" location_city:@"beijing" location_province:@"beijing" location_country:@"china" start_latitude:@"1" start_longitude:@"1" moving_time:@"" elapsed_time:@"1" name:@"run" description:@"1" tag:@"2" type:@"1" total_elevation_gain:@"1" total_distance:@"1" manual:@"1" private_flag:@"1" average_speed:@"1" average_pace:@"1" max_speed:@"1" average_heartrate:@"1" max_heartrate:@"1" calories:@"1" brocast:@"1" like_count:@"1" comments_count:@"1" awards_count:@"1" device:@"1" lastsynctime:@"" list:_points];
    //Activity *person = [MTLJSONAdapter modelOfClass:[Activity class] fromJSONDictionary:dic error:nil];
    _activities = [MTLJSONAdapter modelOfClass:[Activity class] fromJSONDictionary:dic error:nil];
     
    NSLog(@"_activities: %@", _activities);
    
    // save to disk
    //    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *filename = [Path stringByAppendingPathComponent:@"activity.rtf"];
    //    [NSKeyedArchiver archiveRootObject:person toFile:filename];
    //
    //    Activity* d = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    //    NSLog(@"ACTIVITY%@",d);

}


-(NSMutableDictionary*)activityDictWithID:(NSString*)ID user_id:(NSString*)user_id flag:(NSString*)flag start_date:(NSString*)start_date start_date_local:(NSString*)start_date_local time_zone:(NSString*)time_zone location_city:(NSString*)location_city location_province:(NSString*)location_province location_country:(NSString*)location_country start_latitude:(NSString*)start_latitude start_longitude:(NSString*)start_longitude moving_time:(NSString*)moving_time elapsed_time:(NSString*)elapsed_time name:(NSString*)name description:(NSString*)description tag:(NSString*)tag type:(NSString*)type total_elevation_gain:(NSString*)total_elevation_gain total_distance:(NSString*)total_distance manual:(NSString*)manual private_flag:(NSString*)private_flag average_speed:(NSString*)average_speed average_pace:(NSString*)average_pace max_speed:(NSString*)max_speed average_heartrate:(NSString*)average_heartrate max_heartrate:(NSString*)max_heartrate calories:(NSString*)calories brocast:(NSString*)brocast like_count:(NSString*)like_count comments_count:(NSString*)comments_count awards_count:(NSString*)awards_count device:(NSString*)device lastsynctime:(NSString*)lastsynctime list:(NSArray*)list{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:ID forKey:@"ID"];
    [dict setValue:user_id  forKey:@"user_id"];
    [dict setValue:name  forKey:@"name"];

    [dict setValue:flag forKey:@"flag"];
    [dict setValue:start_date forKey:@"start_date"];
    [dict setValue:start_date_local forKey:@"start_date_local"];
    [dict setValue:time_zone forKey:@"time_zone"];
    
    [dict setValue:location_city forKey:@"location_city"];
    [dict setValue:location_province forKey:@"location_province"];
    [dict setValue:location_country forKey:@"location_country"];
    [dict setValue:start_latitude forKey:@"start_latitude"];
    [dict setValue:start_longitude forKey:@"start_longitude"];
    [dict setValue:moving_time forKey:@"moving_time"];
    [dict setValue:elapsed_time  forKey:@"elapsed_time"];
    
  //  [dict setValue:description  forKey:@"description"];
    [dict setValue:tag  forKey:@"tag"];
    [dict setValue:type  forKey:@"type"];
    [dict setValue:total_elevation_gain  forKey:@"total_elevation_gain"];
    [dict setValue:total_distance  forKey:@"total_distance"];
    [dict setValue:manual  forKey:@"manual"];
    [dict setValue:private_flag  forKey:@"private_flag"];
    [dict setValue:average_speed  forKey:@"average_speed"];
    [dict setValue:average_pace  forKey:@"average_pace"];
    [dict setValue:max_speed  forKey:@"max_speed"];
    [dict setValue:average_heartrate  forKey:@"average_heartrate"];
    [dict setValue:max_heartrate  forKey:@"max_heartrate"];
    [dict setValue:calories  forKey:@"calories"];
    [dict setValue:brocast  forKey:@"brocast"];
    [dict setValue:like_count  forKey:@"like_count"];
    [dict setValue:comments_count  forKey:@"comments_count"];
    [dict setValue:awards_count  forKey:@"awards_count"];
    
    [dict setValue:device  forKey:@"device"];
    
    [dict setValue:lastsynctime  forKey:@"lastsynctime"];
    
    [dict setValue:list forKey:@"list"];
    
    NSLog(@"------%@",dict);
    return dict;
}

 
 
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"改变权限");
}


- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations{
    
    
    if (beginCollect == YES) { // 定时器开启就开始收集所有的点
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
        
        
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];//1
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"logitude"];//2
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.speed] forKey:@"speed"];//3
        [loc_meta_data setValue:[NSString stringWithFormat:@"%f",location.altitude] forKey:@"altitude"];//4
        [loc_meta_data setValue:[NSString stringWithFormat:@"%@",location.timestamp] forKey:@"time"];//5
        [loc_meta_data setValue:[[MyManager sharedManager] whole_time]  forKey:@"interval"];
        [loc_meta_data setValue:[NSString stringWithFormat:@"%ld",(long)[[MyManager sharedManager] section]] forKey:@"section"];
        
        if (_points.count > 0) {
            CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
            NSLog(@"距离%f",distance);
            main_total_distance = main_total_distance+distance;
            _total_distance = [NSString stringWithFormat:@"%.2f",main_total_distance];
            
            NSDictionary* dict_total_distance = [NSDictionary dictionaryWithObjectsAndKeys:_total_distance,@"_total_distance", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"_total_distance" object:nil userInfo:dict_total_distance];
            [loc_meta_data setValue:_total_distance forKey:@"distance"];//6
            
            
        }
        
        _currentLocation = location;
        if (nil == _points) {
            _points = [[NSMutableArray alloc] init];
        }
        NSLog(@"%d",_points.count);

        
        [_points addObject:loc_meta_data];
        NSLog(@"points: %@", _points);
        
        
        _activities.list = _points;
        NSLog(@"_activities: %@", _activities);
       
    }
    
    

    
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

-(void)gecode{
    if (_myGeocoder == nil) {
        _myGeocoder  = [[CLGeocoder alloc] init];
    }
    
    NSLog(@"%f,%f",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
    [self.myGeocoder
     reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error == nil &&[placemarks count] > 0){
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"dic = %@", placemark.addressDictionary );
             
             NSLog(@"Country = %@", placemark.country);
             NSLog(@"Postal Code = %@", placemark.postalCode);
             NSLog(@"Locality = %@", placemark.locality);
             
             NSLog(@"dic FormattedAddressLines= %@", [placemark.addressDictionary objectForKey:@"FormattedAddressLines"]);
             NSLog(@"dic Name = %@", [placemark.addressDictionary objectForKey:@"Name"]);
             NSLog(@"dic State = %@", [placemark.addressDictionary objectForKey:@"State"]);
             NSLog(@"dic Street = %@", [placemark.addressDictionary objectForKey:@"Street"]);
             NSLog(@"dic SubLocality= %@", [placemark.addressDictionary objectForKey:@"SubLocality"]);
             NSLog(@"dic SubThoroughfare= %@", [placemark.addressDictionary objectForKey:@"SubThoroughfare"]);
             NSLog(@"dic Thoroughfare = %@", [placemark.addressDictionary objectForKey:@"Thoroughfare"]);
             _displayLocation.text = [placemark.addressDictionary objectForKey:@"Name"];
             
         }
         else if (error == nil &&
                  [placemarks count] == 0){
             NSLog(@"No results were returned.");
         }
         else if (error != nil){
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
}


- (BOOL)locationServicesEnabled {
    NSLog(@"定时器");
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        return YES;
    } else {
         [TSMessage showNotificationInViewController:self title:@"定位失败" subtitle:@"手机定位未开启" type:TSMessageNotificationTypeWarning];
        return NO;
    }
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]] ){
        
        ((MKUserLocation *)annotation).title = @"我的位置";
        //  ((MKUserLocation *)annotation).subtitle = @"中关村东路66号";
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        static NSString* MapPointAnnoationIdentifer = @"mapPointAnnoationIdentifer";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:MapPointAnnoationIdentifer];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:MapPointAnnoationIdentifer];
            if ([[annotation title] isEqualToString:@"起点"]) {
                customPinView.image = [UIImage imageNamed:@"track_start_marker.png"];
                
            }
            else{
                customPinView.pinColor = MKPinAnnotationColorPurple;
            }
            //  customPinView.pinColor = MKPinAnnotationColorPurple;
            
            //  customPinView.animatesDrop = YES;
            //  customPinView.canShowCallout = YES;
            // NSLog(@"副标题%@",[annotation subtitle]);
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else
        return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 5;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"annotation views: %@", views);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    _centerPoint = userLocation;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    NSLog(@"------%d",(int)(userLocation.coordinate.latitude));
    int a = (int)userLocation.coordinate.latitude;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"] && a!=0 ) {
        [_mapView setCenterCoordinate:coordinate zoomLevel:15 animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"fisrt" forKey:@"first"];
    }
    
    
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [ProgressHUD showError:@"定位失败"];
}

#pragma mark - Others
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
