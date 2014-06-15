//
//  FileManager.m
//  Sport
//
//  Created by ZKR on 6/14/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

-(NSMutableArray*)searchPointFromFile{
    
    NSData *data = [NSData dataWithContentsOfFile:[self fileName]];
    if (data == nil)
        return nil;
    NSMutableArray* point_array = [NSKeyedUnarchiver unarchiveObjectWithData:data  ];
    return point_array;
}

-(NSString*)fileName{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"point.rtf"];
    return filename;
}

-(void)initActivityObject{
    NSMutableDictionary* dic = [self activityDictWithID:@"1" user_id:@"1" flag:@"1" start_date:[DayManagement stringFromDate:[NSDate date]] start_date_local:[DayManagement stringFromDate:[NSDate date]] time_zone:@"8" location_city:@"beijing" location_province:@"beijing" location_country:@"china" start_latitude:@"1" start_longitude:@"1" moving_time:@"" elapsed_time:@"1" name:@"run" description:@"1" tag:@"2" type:@"1" total_elevation_gain:@"1" total_distance:@"1" manual:@"1" private_flag:@"1" average_speed:@"1" average_pace:@"1" max_speed:@"1" average_heartrate:@"1" max_heartrate:@"1" calories:@"1" brocast:@"1" like_count:@"1" comments_count:@"1" awards_count:@"1" device:@"1" lastsynctime:@"" list:nil];
    //Activity *person = [MTLJSONAdapter modelOfClass:[Activity class] fromJSONDictionary:dic error:nil];
   // _activities = [MTLJSONAdapter modelOfClass:[Activity class] fromJSONDictionary:dic error:nil];
    
   // NSLog(@"_activities: %@", _activities);
    
    // save to disk
    //    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *filename = [Path stringByAppendingPathComponent:@"activity.rtf"];
    //    [NSKeyedArchiver archiveRootObject:person toFile:filename];
    //
    //    Activity* d = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    //    NSLog(@"ACTIVITY%@",d);
    
}

-(NSMutableDictionary*)activityDictWithID:(NSString*)ID user_id:(NSString*)user_id flag:(NSString*)flag start_date:(NSString*)start_date start_date_local:(NSString*)start_date_local time_zone:(NSString*)time_zone location_city:(NSString*)location_city location_province:(NSString*)location_province location_country:(NSString*)location_country start_latitude:(NSString*)start_latitude start_longitude:(NSString*)start_longitude moving_time:(NSString*)moving_time elapsed_time:(NSString*)elapsed_time name:(NSString*)name description:(NSString*)description tag:(NSString*)tag type:(NSString*)type total_elevation_gain:(NSString*)total_elevation_gain total_distance:(NSString*)total_distance manual:(NSString*)manual private_flag:(NSString*)private_flag average_speed:(NSString*)average_speed average_pace:(NSString*)average_pace max_speed:(NSString*)max_speed average_heartrate:(NSString*)average_heartrate max_heartrate:(NSString*)max_heartrate calories:(NSString*)calories brocast:(NSString*)brocast like_count:(NSString*)like_count comments_count:(NSString*)comments_count awards_count:(NSString*)awards_count device:(NSString*)device lastsynctime:(NSString*)lastsynctime list:(NSArray*)list{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:ID forKey:@"ID"];
    [dict setValue:user_id  forKey:@"user_id"];
    [dict setValue:name  forKey:@"name"];
    
    [dict setValue:flag forKey:@"flag"];
    [dict setValue:start_date forKey:@"start_date"];
    [dict setValue:start_date_local forKey:@"start_date_local"];
    [dict setValue:time_zone forKey:@"time_zone"];
    
    [dict setValue:location_city forKey:@"location_city"];
    [dict setValue:location_province forKey:@"location_province"];
    [dict setValue:location_country forKey:@"location_country"];
    [dict setValue:start_latitude forKey:@"start_latitude"];
    [dict setValue:start_longitude forKey:@"start_longitude"];
    [dict setValue:moving_time forKey:@"moving_time"];
    [dict setValue:elapsed_time  forKey:@"elapsed_time"];
    
    //  [dict setValue:description  forKey:@"description"];
    [dict setValue:tag  forKey:@"tag"];
    [dict setValue:type  forKey:@"type"];
    [dict setValue:total_elevation_gain  forKey:@"total_elevation_gain"];
    [dict setValue:total_distance  forKey:@"total_distance"];
    [dict setValue:manual  forKey:@"manual"];
    [dict setValue:private_flag  forKey:@"private_flag"];
    [dict setValue:average_speed  forKey:@"average_speed"];
    [dict setValue:average_pace  forKey:@"average_pace"];
    [dict setValue:max_speed  forKey:@"max_speed"];
    [dict setValue:average_heartrate  forKey:@"average_heartrate"];
    [dict setValue:max_heartrate  forKey:@"max_heartrate"];
    [dict setValue:calories  forKey:@"calories"];
    [dict setValue:brocast  forKey:@"brocast"];
    [dict setValue:like_count  forKey:@"like_count"];
    [dict setValue:comments_count  forKey:@"comments_count"];
    [dict setValue:awards_count  forKey:@"awards_count"];
    
    [dict setValue:device  forKey:@"device"];
    
    [dict setValue:lastsynctime  forKey:@"lastsynctime"];
    
    [dict setValue:list forKey:@"list"];
    
    NSLog(@"------%@",dict);
    return dict;
}


@end
