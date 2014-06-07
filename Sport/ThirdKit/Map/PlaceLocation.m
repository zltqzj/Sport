//
//  PlaceLocation.m
//  CityAssistance
//
//  Created by Neutrino on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlaceLocation.h"

@implementation PlaceLocation
@synthesize name, iconURL, reference, address, coordinate;

+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type{
	int index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
		if([(NSString *)([[obj objectForKey:@"types"] objectAtIndex:0]) isEqualToString:component]){
			return YES;
		}else {
			return NO;
		}
	}];
	
	if(index == NSNotFound) return nil;
	
	return [[array objectAtIndex:index] valueForKey:type];
}


@end
