//
//  KAThread.h
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPausibleTimer.h"
#import "MyManager.h"
#import <MapKit/MapKit.h>
#import "Activity.h"
#import <CoreLocation/CoreLocation.h>
#import "PTInputSource.h"


@interface KAThread : NSThread<CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
    
  
    CLLocation* _currentLocation;
    
    
}
@property(strong,nonatomic) CSPausibleTimer* timer;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (strong,nonatomic) CLGeocoder* myGeocoder;
@property (nonatomic, retain) NSMutableArray* points;
@property (strong,nonatomic) MKUserLocation* centerPoint;
@property (strong,nonatomic) NSMutableArray* annoArray;
@property (nonatomic, retain) Activity* activities;

@property (nonatomic, readwrite, retain) RunLoopSource *source;
@property(assign,nonatomic) NSString* total_distance;

@property(assign,nonatomic) double main_total_distance;
@property(assign,nonatomic) BOOL beginCollect;
@property (strong,nonatomic) NSDictionary* lastlocal_meta_data;
@property(strong,nonatomic) NSMutableArray* pointsToDraw;
@property(assign,nonatomic) BOOL isCancelled;

-(id)init;

+ (id)sharedManager;

 
- (void)stopRunLoop;
- (void)startRunLoop;
-(void)switchMainTab;
-(void)resumeRunLoop;
-(void)finishActivity;
@end
