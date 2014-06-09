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

-(IBAction)go:(id)sender{
    // 添加起点图片
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self configureRoutes];
    });
}

-(IBAction)end:(id)sender{
    
    [_locationManager stopUpdatingLocation];
}

-(IBAction)pause:(id)sender{
    [self gecode];
   
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)collectPoint{
    beginCollect = YES;
    [self configureRoutes];
}

-(void)initMap{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectPoint) name:@"collectPoint" object:nil];
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    if (IS_IPHONE5) {
        [_mapView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    [self.view addSubview:self.mapView];
    
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
   
//    _timer = [NSTimer scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer){
//        [self locationServicesEnabled];
//    } repeats:YES];
    
    [self initMap];
}



// 划线方法
- (void)configureRoutes
{
    // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	NSLog(@"%@",_points);
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    if (_points.count ==0) {
        
    }
    else{
        // for(int idx = 0; idx < pointStrings.count; idx++)
        for(int idx = 0; idx < _points.count; idx++)
        {
            CLLocation *location = [_points objectAtIndex:idx];
            CLLocationDegrees latitude  = location.coordinate.latitude;
            CLLocationDegrees longitude = location.coordinate.longitude;
            
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
            
            pointArray[idx] = point;
            NSLog(@"%d",idx);
        }
        
        if (self.routeLine) {
            [self.mapView removeOverlay:self.routeLine];
        }
        
        self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
        
        // add the overlay to the map
        if (nil != self.routeLine) {
            [self.mapView addOverlay:self.routeLine];
            NSLog(@"划线");
        }
        
        // clear the memory allocated earlier for the points
        free(pointArray);
    }
   
  
    NSMutableDictionary* dic = [self activityDictWithID:@"1" user_id:@"2" flag:@"1" start_date:[DayManagement stringFromDate:[NSDate date]] start_date_local:[DayManagement stringFromDate:[NSDate date]] time_zone:@"8" location_city:@"beijing" location_province:@"beijing" location_country:@"china" start_latitude:@"1" start_longitude:@"1" moving_time:@"" elapsed_time:@"1" name:@"run" description:@"1" tag:@"2" type:@"1" total_elevation_gain:@"1" total_distance:@"1" manual:@"1" private_flag:@"1" average_speed:@"1" average_pace:@"1" max_speed:@"1" average_heartrate:@"1" max_heartrate:@"1" calories:@"1" brocast:@"1" like_count:@"1" comments_count:@"1" awards_count:@"1" device:@"1" lastsynctime:@"" list:_points];
    NSLog(@"dic%@",dic);
    Activity *person = [MTLJSONAdapter modelOfClass:[Activity class] fromJSONDictionary:dic error:nil];
    
    NSLog(@"person: %@", person);
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"activity.rtf"];
    [NSKeyedArchiver archiveRootObject:person toFile:filename];
    
    Activity* d = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    NSLog(@"ACTIVITY%@",d);
    
 
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

 
-(NSMutableDictionary*)activityDictWithID:(NSString*)ID user_id:(NSString*)user_id flag:(NSString*)flag start_date:(NSString*)start_date start_date_local:(NSString*)start_date_local time_zone:(NSString*)time_zone location_city:(NSString*)location_city location_province:(NSString*)location_province location_country:(NSString*)location_country start_latitude:(NSString*)start_latitude start_longitude:(NSString*)start_longitude moving_time:(NSString*)moving_time elapsed_time:(NSString*)elapsed_time name:(NSString*)name description:(NSString*)description tag:(NSString*)tag type:(NSString*)type total_elevation_gain:(NSString*)total_elevation_gain total_distance:(NSString*)total_distance manual:(NSString*)manual private_flag:(NSString*)private_flag average_speed:(NSString*)average_speed average_pace:(NSString*)average_pace max_speed:(NSString*)max_speed average_heartrate:(NSString*)average_heartrate max_heartrate:(NSString*)max_heartrate calories:(NSString*)calories brocast:(NSString*)brocast like_count:(NSString*)like_count comments_count:(NSString*)comments_count awards_count:(NSString*)awards_count device:(NSString*)device lastsynctime:(NSString*)lastsynctime  {
   
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
    
  
   // [dict setValue:description  forKey:@"description"];
    
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
   
    

    NSLog(@"------%@",dict);
    return dict;
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]] ){
        
        ((MKUserLocation *)annotation).title = @"我的位置";
        //  ((MKUserLocation *)annotation).subtitle = @"中关村东路66号";
        return nil;  //return nil to use default blue dot view
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
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]&& userLocation) {
        [_mapView setCenterCoordinate:coordinate zoomLevel:15 animated:YES];
       
        [[NSUserDefaults standardUserDefaults] setValue:@"fisrt" forKey:@"first"];
    }
    else{
        [_mapView setCenterCoordinate:coordinate animated:YES];
        
    }
    // [_mapView setCenterCoordinate:coordinate zoomLevel:13 animated:YES];
    
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [ProgressHUD showError:@"定位失败"];
}
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"改变权限");
}


- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    
//    CLLocationCoordinate2D cood = [WGS84TOGCJ02 transformFromWGSToGCJ:[location1 coordinate]];
//    CLLocation* location = [[CLLocation alloc] initWithCoordinate:cood altitude:location1.altitude horizontalAccuracy:location1.horizontalAccuracy verticalAccuracy:location1.verticalAccuracy course:location1.course speed:location1.speed timestamp:[NSDate date]];
    
    NSLog(@"我的高度%f",location.altitude);
    NSLog(@"我的速度%f",location.speed);
    // check the zero point
    if  (location.coordinate.latitude == 0.0f ||
         location.coordinate.longitude == 0.0f)
        return;
    
    
    
    if (_points.count > 0) {
        CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
        if (distance < 5)
            return;
    }
    _currentLocation = location;
    if (nil == _points) {
        _points = [[NSMutableArray alloc] init];
    }
    NSLog(@"%d",_points.count);
    if (beginCollect == YES) {
        [_points addObject:location];
        NSLog(@"points: %@", _points);
    }
 
    
    if ([[MyManager sharedManager] ifDrawLine] && beginCollect ==YES) {
        [self configureRoutes];
    }
        
//        if (beginCollect ==YES) {
//            [self configureRoutes];
//        }
    // 起点画坐标
//    MapPoint* map  = [[MapPoint alloc] initWithCoordinate:_centerPoint.coordinate title:@"起点" subTitle:@""];
//    [_mapView addAnnotation:map];
    
   // [self configureRoutes]; // 划线
    
}



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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
//    [self configureRoutes];
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [self configureRoutes];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
