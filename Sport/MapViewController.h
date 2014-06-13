//
//  MapViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"
#import "iOSBlocks.h"
#import "NSTimer+Blocks.h"
#import "TSMessageView.h"
#import "WGS84TOGCJ02.h"
#import "Activity.h"
#import "Mantle.h"
#import "ProgressHUD.h"
#import "Activity.h"
#import "EMPerson.h"
#import "DayManagement.h"
#import "MyManager.h"
#import "CSPausibleTimer.h"

#import "StatsViewController.h"

double main_total_distance;

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate,TSMessageViewProtocol>
{
	// the map view
	MKMapView* _mapView;
	
    // routes points
    NSMutableArray* _points;
    
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

@property (nonatomic, retain)   MKMapView* mapView;

@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (strong,nonatomic) CLGeocoder* myGeocoder;
@property (strong,nonatomic) IBOutlet UILabel* displayLocation;
@property (strong,nonatomic) MKUserLocation* centerPoint;
@property (strong,nonatomic) NSMutableArray* annoArray;
@property (nonatomic, retain) Activity* activities;
@property(strong,nonatomic) CSPausibleTimer* timer;
@property(assign,nonatomic) NSString* total_distance;


//@property(strong,nonatomic) NSMutableArray* pointsToDraw;
//@property(strong,nonatomic) KAThread * subThread;
//@property(strong,nonatomic) StatsViewController * pStatusViow;
-(void)configureRoutes;
-(void)UPDateMainMap;
 


@end
