//
//  MapViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "Mantle.h"
#import "StatsViewController.h"

double main_total_distance;

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate,TSMessageViewProtocol>
{
	 
    
	// the data representing the route points.
	MKPolyline* _routeLine;
	
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    
    // location manager
    CLLocationManager* _locationManager;
    
    // current location
    CLLocation* _currentLocation;
    
    
    
}

@property (nonatomic, retain)   MKMapView* mapView;  // 地图控件

@property (nonatomic, retain) MKPolyline* routeLine; // 划线
@property (nonatomic, retain) MKPolylineView* routeLineView; // 划线视图

@property(strong,nonatomic) NSMutableArray* annoArray;

@property (strong,nonatomic) CLGeocoder* myGeocoder;

@property (strong,nonatomic) MKUserLocation* centerPoint;

@property (nonatomic, retain) Activity* activities;

@property(assign,nonatomic) NSString* total_distance;


 
-(void)UPDateMainMap;
 


@end
