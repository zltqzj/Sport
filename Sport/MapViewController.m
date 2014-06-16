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

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize centerPoint = _centerPoint;

@synthesize myGeocoder = _myGeocoder;

@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine; //表示当前需要更新的一个Overlay；本Overlay是每次重画的
@synthesize routeLineView = _routeLineView;
@synthesize activities= _activities;
@synthesize total_distance = _total_distance;

#pragma mark - MY FUNCTIONS

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
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initMap];
 
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UPDateMainMap:) name:@"UPDateMainMap" object:nil];
    main_total_distance = 0;
    _total_distance = 0;
    _haveDrawCount = 0;
    _routeLineArray = [[NSMutableArray alloc] initWithCapacity:10];
 
    
}

-(void)UPDateMainMap:(NSNotification*)info{
    NSDictionary* dict = info.userInfo;
    NSMutableArray* parry = [dict objectForKey:@"parry"];
    [self configureRoutes:parry];
    [parry removeAllObjects];
}


// 划线方法（点的个数发生变化时才划线）(重新开始一个activity要把_routeLineArray,_haveDrawCount清零。）
- (void)configureRoutes:(NSMutableArray *) _pointsToDraw
{
 
    [_mapView removeAnnotations:_annoArray];
       // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	 
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _pointsToDraw.count);
    MKMapPoint* pointArray2Draw = nil;
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    if (_pointsToDraw.count ==0) {
        
    }
    else{
        if (self.routeLine) {
            
            [self.mapView removeOverlay:self.routeLine];
            //[_mapView removeOverlays:_routeLineArray];
            NSLog(@"____________________%d___________________",_routeLineArray.count);
        }

        int nIndex = 0;
        for(int idx = _haveDrawCount; idx < _pointsToDraw.count; idx++)
        {
           
            NSDictionary* d = [_pointsToDraw objectAtIndex:idx];
         
              latitude  = [[d objectForKey:@"latitude"] doubleValue];
            
              longitude = [[d objectForKey:@"logitude"] doubleValue];
          
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
             if (idx > 0){
                 NSString* a =[[_pointsToDraw objectAtIndex:idx] objectForKey:@"section"];
                 NSString* b =[[_pointsToDraw objectAtIndex:idx-1] objectForKey:@"section"];
                 if ( ![a isEqualToString:b]) { //当前是section有变化的时候，需要添加一个不重画的overlay
                   
                     if(nIndex > 0)
                     {
                     
                         if (pointArray2Draw==nil)
                         {
                             pointArray2Draw = malloc(sizeof(CLLocationCoordinate2D) * nIndex);
                             memcpy(pointArray2Draw, pointArray, sizeof(CLLocationCoordinate2D) * nIndex);
                         }
                         self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
                         if (nil != self.routeLine) {
                             [self.mapView addOverlay:self.routeLine]; // add the overlay to the map
                             [_routeLineArray addObject:self.routeLine];
                             NSLog(@"划线从第%d个点----->第%d个点,画了%d个点",_haveDrawCount,idx-1,nIndex);
                            _haveDrawCount = idx;
                         }
                         if (pointArray2Draw)
                         {
                             free(pointArray2Draw);
                             pointArray2Draw = nil;
                         }
                         free(pointArray);
                         pointArray = malloc(sizeof(CLLocationCoordinate2D) * _pointsToDraw.count);
                         nIndex = 0;
                     }
                     
                 }
             }
            
            pointArray[nIndex] = point;
            nIndex ++ ;
            
            /////////////////////判断当前的idx总数是否满足max_count,则需要生成一个不重画的overlay；
            if (nIndex == MAX_POINT)
            {
                if (pointArray2Draw==nil)
                {
                    pointArray2Draw = malloc(sizeof(CLLocationCoordinate2D) * nIndex);
                    memcpy(pointArray2Draw, pointArray, sizeof(CLLocationCoordinate2D) * nIndex);
                }
                self.routeLine = [MKPolyline polylineWithPoints:pointArray2Draw count:nIndex];
                if (nil != self.routeLine) {
                    [self.mapView addOverlay:self.routeLine]; // add the overlay to the map
                    [_routeLineArray addObject:self.routeLine];
                    NSLog(@"划线从第%d个点----->第%d个点，画了%d个点",_haveDrawCount,idx,nIndex);
                    _haveDrawCount = idx;// 为了保证点的连续，所以必须上一个的点的数据也要参与到下一段的画线中。下一个timmer触发画线的时候用到。
                    
                }
                if (pointArray2Draw)
                {
                    free(pointArray2Draw);
                    pointArray2Draw = nil;
                }
                free(pointArray);
                pointArray = malloc(sizeof(CLLocationCoordinate2D) * _pointsToDraw.count);
                nIndex = 0;
                //为了保证点的连续，所以必须上一个的点的数据也要参与到下一段的画线中。当前画线的时候用到。
                pointArray[nIndex] = point;
                nIndex++;

            }
        }
        
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
            //[_routeLineArray addObject:self.routeLine];
            NSLog(@"划线从第%d个点----->第%d个点,当前画了%d个点",_haveDrawCount,_pointsToDraw.count, nIndex+1);
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


-(void)gecode{
    if (_myGeocoder == nil) {
        _myGeocoder  = [[CLGeocoder alloc] init];
    }
    
   // NSLog(@"%f,%f",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
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
    
    NSLog(@"annotation views: %@", views);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   
    _centerPoint = userLocation;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
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
