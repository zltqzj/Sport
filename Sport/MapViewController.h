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
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (strong,nonatomic) CLGeocoder* myGeocoder;
@property (strong,nonatomic) IBOutlet UILabel* displayLocation;
@property(strong,nonatomic) MKUserLocation* centerPoint;

@property(strong,nonatomic) NSTimer* timer;

-(void) configureRoutes;

-(IBAction)go:(id)sender;
-(IBAction)end:(id)sender;
-(IBAction)pause:(id)sender;


@end
