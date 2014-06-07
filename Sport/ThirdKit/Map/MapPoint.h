//
//  MapPoint.h
//  MyIns
//
//  Created by Neutrino on 11-10-12.
//  Copyright 2011年 中科软科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPoint : NSObject <MKAnnotation>{
    NSString* title;
    NSString* subTitle;
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* subTitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st; 

@end

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end