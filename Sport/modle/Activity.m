//
//  Activity.m
//  Sport
//
//  Created by zhaojian on 14-6-6.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "Activity.h"

@implementation Activity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"ID":@"ID",
             @"user_id":@"user_id"  ,
             @"flag":@"flag",
             @"start_date":@"start_date",
             @"start_date_local":@"start_date_local",
             @"time_zone":@"time_zone" ,
             @"location_city":@"location_city",
             @"location_province":@"location_province",
             @"location_country":@"location_country",
             @"start_latitude":@"start_latitude",
             @"start_longitude":@"start_longitude" ,
             @"moving_time":@"moving_time",
             @"elapsed_time":@"elapsed_time"  ,
             @"descript":@"descript",
             @"tag":@"tag",
             @"type":@"type",
             @"total_elevation_gain":@"total_elevation_gain",
             @"total_distance":@"total_distance" ,
             @"manual":@"manual",
             @"private_flag":@"private_flag",
             @"average_speed":@"average_speed",
             @"average_pace":@"average_pace",
             @"max_speed":@"max_speed"  ,
             @"average_heartrate":@"average_heartrate" ,
             @"max_heartrate":@"max_heartrate",
             @"calories":@"calories" ,
             @"brocast":@"brocast",
             @"like_count":@"like_count",
             @"comments_count":@"comments_count",
             @"awards_count":@"awards_count",
             @"device":@"device",
             @"lastsynctime":@"lastsynctime" ,
             @"list":@"list"
             
           
             };
    
}


-(NSMutableDictionary*)activityDictWithID:(NSString*)ID user_id:(NSString*)user_id flag:(NSString*)flag start_date:(NSString*)start_date start_date_local:(NSString*)start_date_local time_zone:(NSString*)time_zone location_city:(NSString*)location_city location_province:(NSString*)location_province location_country:(NSString*)location_country start_latitude:(NSString*)start_latitude start_longitude:(NSString*)start_longitude end_latitude:(NSString*)end_latitude end_logitude:(NSString*)end_longitude  moving_time:(NSString*)moving_time elapsed_time:(NSString*)elapsed_time name:(NSString*)name description:(NSString*)descript tag:(NSString*)tag type:(NSString*)type total_elevation_gain:(NSString*)total_elevation_gain total_distance:(NSString*)total_distance manual:(NSString*)manual private_flag:(NSString*)private_flag average_speed:(NSString*)average_speed average_pace:(NSString*)average_pace max_speed:(NSString*)max_speed average_heartrate:(NSString*)average_heartrate max_heartrate:(NSString*)max_heartrate calories:(NSString*)calories brocast:(NSString*)brocast like_count:(NSString*)like_count comments_count:(NSString*)comments_count awards_count:(NSString*)awards_count device:(NSString*)device lastsynctime:(NSString*)lastsynctime list:(NSArray*)list{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:ID forKey:@"ID"];
    [dict setValue:user_id  forKey:@"USER_ID"];
    [dict setValue:name  forKey:@"NAME"];
    
    [dict setValue:flag forKey:@"FLAG"];
    [dict setValue:start_date forKey:@"START_DATE"];
    [dict setValue:start_date_local forKey:@"START_DATE_LOCAL"];
    [dict setValue:time_zone forKey:@"TIME_ZONE"];
    
    [dict setValue:location_city forKey:@"LOCATION_CITY"];
    [dict setValue:location_province forKey:@"LOCATION_PROVINCE"];
    [dict setValue:location_country forKey:@"LOCATION_COUNTRY"];
    [dict setValue:start_latitude forKey:@"START_LATITUDE"];
    [dict setValue:start_longitude forKey:@"START_LONGITUDE"];
    
    [dict setValue:end_latitude forKey:@"END_LATITUDE"];
    [dict setValue:end_longitude forKey:@"END_LONGITUDE"];

    [dict setValue:moving_time forKey:@"MOVING_TIME"];
    [dict setValue:elapsed_time  forKey:@"ELAPSED_TIME"];
    
    [dict setValue:descript  forKey:@"DESCRIPTION"];
    [dict setValue:tag  forKey:@"TAG"];
    [dict setValue:type  forKey:@"TYPE"];
    [dict setValue:total_elevation_gain  forKey:@"TOTAL_ELEVATION_GAIN"];
    [dict setValue:total_distance  forKey:@"TOTAL_DISTANCE"];
    [dict setValue:manual  forKey:@"MANUAL"];
    [dict setValue:private_flag  forKey:@"PRIVATE"];
    [dict setValue:average_speed  forKey:@"AVERAGE_SPEED"];
    [dict setValue:average_pace  forKey:@"AVERAGE_PACE"];
    [dict setValue:max_speed  forKey:@"MAX_SPEED"];
    [dict setValue:average_heartrate  forKey:@"AVERAGE_HEARTRATE"];
    [dict setValue:max_heartrate  forKey:@"MAX_HEARTRATE"];
    [dict setValue:calories  forKey:@"CALORIES"];
    [dict setValue:brocast  forKey:@"BROCAST"];
    [dict setValue:like_count  forKey:@"LIKES_COUNT"];
    [dict setValue:comments_count  forKey:@"COMMENTS_COUNT"];
    [dict setValue:awards_count  forKey:@"AWARDS_COUNT"];
    
    [dict setValue:device  forKey:@"DEVICE"];
    
    [dict setValue:lastsynctime  forKey:@"LASTSYNCTIME"];
    
    [dict setValue:list forKey:@"LIST_LOCATION"];
    
    NSLog(@"------%@",dict);
    return dict;
}

/*
// 测试一下json
Activity* act = [[Activity alloc] init];
NSDictionary* dict =[act activityDictWithID:@"1" user_id:@"1" flag:@"1" start_date:@"" start_date_local:@"" time_zone:@"" location_city:@"" location_province:@"" location_country:@"" start_latitude:@"" start_longitude:@"" end_latitude:@"" end_logitude:@"" moving_time:@"" elapsed_time:@"" name:@"" description:@"" tag:@"" type:@"" total_elevation_gain:@"" total_distance:@"" manual:@"" private_flag:@"" average_speed:@"" average_pace:@"" max_speed:@"" average_heartrate:@"" max_heartrate:@"" calories:@"" brocast:@"" like_count:@"" comments_count:@"" awards_count:@"" device:@"" lastsynctime:@"" list:nil];
SBJsonWriter *writer = [[SBJsonWriter alloc] init];
NSLog(@"Start Create JSON!");
NSString *value = [writer stringWithObject:dict];
NSLog(@"%@",value);

ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_ACTIVITY]];
[request setPostValue:value forKey:@"activitydata"];
_req = request;
[_req startAsynchronous];
[_req setCompletionBlock:^{
    NSLog(@"返回值%@",[_req responseString]);
}];
[_req setFailedBlock:^{
    NSLog(@"返回值%@",[_req responseString]);
}];
*/


//    NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:value,@"activitydata", nil];
//    [_netUtil  requestContentWithUrl:UPLOAD_ACTIVITY para:d withSuccessBlock:^(id returnData) {
//        NSLog(@"返回值：%@",returnData);
//    } withFailureBlock:^(NSError *error) {
//        NSLog(@"返回值：%@",error);
//    }];



// save to disk
//    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filename = [Path stringByAppendingPathComponent:@"activity.rtf"];
//    [NSKeyedArchiver archiveRootObject:person toFile:filename];
//
//    Activity* d = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
//    NSLog(@"ACTIVITY%@",d);


@end
