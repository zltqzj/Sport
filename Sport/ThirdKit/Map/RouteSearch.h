//
//  RouteSearch.h
//  CityAssistance
//
//  Created by Neutrino on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <uuid/uuid.h>
#import "KMLParser.h"

@protocol RouteSearchDelegate;

@interface RouteSearch : NSObject {
    
    id <RouteSearchDelegate> __unsafe_unretained delegate;
    NSMutableData *receivedData;
	NSMutableArray* results;
    NSString* kmlFilePath;
    KMLParser *kml;
}

@property (nonatomic, unsafe_unretained) id <RouteSearchDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSString* kmlFilePath;
@property (nonatomic, strong) KMLParser *kml;

-(void)drawRoute:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;
//-(void)drawRoute;
@end

@protocol RouteSearchDelegate <NSObject>

-(void) routeSearch:(RouteSearch*)route didFinishDownloadKMLFile:(NSString*)filePath;

@end
