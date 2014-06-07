//
//  PlaceLocation.h
//  CityAssistance
//
//  Created by Neutrino on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PlaceLocation : NSObject{
    
    NSString* name;
    NSString* iconURL;
    NSString* address;
    NSString* reference;
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* iconURL;
@property(nonatomic,strong) NSString* address;
@property(nonatomic,strong) NSString* reference;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;


+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type;

@end
