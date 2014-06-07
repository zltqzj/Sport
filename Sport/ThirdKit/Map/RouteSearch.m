

#import "RouteSearch.h"

@implementation RouteSearch

@synthesize results,kmlFilePath;
@synthesize kml;
@synthesize delegate;

-(void)drawRoute:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&output=kml",from.latitude, from.longitude, to.latitude, to.longitude];
    NSLog(@"%@", urlString);
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if(connection){
        receivedData = [[NSMutableData alloc] initWithLength:0];
    }      

/*
    if (![kmlFilePath isEqualToString:@""]) {
        
        NSLog(@"%@", kmlFilePath);
        return true;
    }
        
    return false;
 */
}
/////////////////////http delegate////////////////////
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
 //   NSLog(@"%@", geocodingResponse);
    char buf[64] = {0};
    uuid_t uid;
    uuid_generate(uid);
    uuid_unparse(uid, buf);
    strcat(buf, ".kml");
    NSError* error;
 //   NSString* path = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
    NSMutableString* path = [[NSMutableString alloc] initWithCapacity:0];
    [path appendString:NSTemporaryDirectory()];
    [path appendString:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]];
    if([geocodingResponse writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error]){
        
        [delegate routeSearch:self didFinishDownloadKMLFile:path];   
    }

}
/////////////////////http delegate////////////////////


@end
