/*
 * MJGeocoder.m
 *
 *
	Copyright (c) 2011, Mohammed Jisrawi
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.

	* Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer in the
	  documentation and/or other materials provided with the distribution.

	* Neither the name of the Mohammed Jisrawi nor the
	  names of its contributors may be used to endorse or promote products
	  derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL MOHAMMED JISRAWI BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "MJGeocoder.h"
#import "JSON.h"

@implementation MJGeocoder

@synthesize delegate, results;

/*
 *	Opens a URL Connection and calls Google's JSON geocoding service
 *
 *  address: address to geocode
 *  title: custom title for location (useful for passing an annotation title on through the AddressComponents object)
 */
- (void)findLocationsWithAddress:(NSString *)address lati:(CGFloat)lati longi:(CGFloat)longi
                          radius:(NSInteger)radius{
    
	NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&name=%@&sensor=true&key=AIzaSyAEGo1DFOUt-3GYyrahu5EEre_opCSNYoU",lati,longi,radius,address];
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if(connection){
        receivedData = [NSMutableData data];
    }else{        
        NSError *error = [NSError errorWithDomain:@"MJGeocoderError" code:5 userInfo:nil];
        [delegate geocoder:self didFailWithError:error];
    }
    
}
- (void)findLocationDetail:(NSString*)reference
{
    
    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=AIzaSyAEGo1DFOUt-3GYyrahu5EEre_opCSNYoU", reference];
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if(connection){
        //connection valid, so init data holder
        receivedData = [NSMutableData data];
    }else{        
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"MJGeocoderError" code:5 userInfo:nil];
        [delegate geocoder:self didFailWithError:error];
    }
}

/*
 *  Reset data when a new response is received
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}


/*
 *  Append received data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

/*
 *  Called when done downloading response from Google. Builds a table of AddressComponents objects
 *	and tells the delegate that it was successful or informs the delegate of a failure.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//get response
	NSString *geocodingResponse = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    
	//result as dictionary dictionary
	NSDictionary *resultDict = [geocodingResponse JSONValue];
    
	NSString *status = [resultDict valueForKey:@"status"];
	if([status isEqualToString:@"OK"]){
		//if successful, build results array
		NSArray *foundLocations = [resultDict objectForKey:@"results"];
		results = [NSMutableArray arrayWithCapacity:[foundLocations count]];
		NSLog(@"%d", [foundLocations count]);
		[foundLocations enumerateObjectsUsingBlock:^(id location, NSUInteger index, BOOL *stop) {
            
			PlaceLocation *resultAddress = [[PlaceLocation alloc] init];
            resultAddress.name = [location valueForKey:@"name"];
            resultAddress.iconURL = [location valueForKey:@"icon"];
            resultAddress.address = [location valueForKey:@"vicinity"];
            resultAddress.reference = [location valueForKey:@"reference"];
            resultAddress.coordinate = 
			CLLocationCoordinate2DMake([[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue],
									   [[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue]);
            
            [results addObject:resultAddress];
		}];
		
		[delegate geocoder:self didFindLocations:results];
	}else{
		//if status code is not OK
		NSError *error = nil;
		
		if([status isEqualToString:@"ZERO_RESULTS"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:1 userInfo:nil];
		}
		else if([status isEqualToString:@"OVER_QUERY_LIMIT"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:2 userInfo:nil];
		}
		else if([status isEqualToString:@"REQUEST_DENIED"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:3 userInfo:nil];
		}
		else if([status isEqualToString:@"INVALID_REQUEST"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:4 userInfo:nil];
		}
		
		[delegate geocoder:self didFailWithError:error];
	}
}


@end
