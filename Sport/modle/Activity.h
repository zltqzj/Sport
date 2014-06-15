//
//  Activity.h
//  Sport
//
//  Created by zhaojian on 14-6-6.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "MTLModel.h"

#import "MTLJSONAdapter.h"

@interface Activity : MTLModel <MTLJSONSerializing>
@property(strong,nonatomic) NSString* name; // 活动名称，30个字以内
@property(strong,nonatomic) NSString* ID;  // 活动提交之前为空，Activity主键
@property(strong,nonatomic) NSString* user_id;  //#用户ID

@property(strong,nonatomic) NSString* flag;   // #1:有效 2:删除
@property(strong,nonatomic) NSString* start_date; // 活动开始时间
@property(strong,nonatomic) NSString* start_date_local; //
@property(strong,nonatomic) NSString* time_zone; // 所在时区

@property(strong,nonatomic) NSString* location_city; // 城市
@property(strong,nonatomic) NSString* location_province; // 省市区

@property(strong,nonatomic) NSString* location_country; // 国家
@property(strong,nonatomic) NSString* start_latitude; // 起点纬度
@property(strong,nonatomic) NSString* start_longitude; // 起点经度

@property(strong,nonatomic) NSString* moving_time; // 运动中移动时间

@property(strong,nonatomic) NSString* elapsed_time; // #目前MOVING_TIME＝ELAPSED_TIME，秒

@property(strong,nonatomic) NSString* descript; // 70个字以内

@property(strong,nonatomic) NSString* tag; // 标签
@property(strong,nonatomic) NSString* type; //#RUN跑步,RIDE骑行
@property(strong,nonatomic) NSString* total_elevation_gain; // 累计的爬升
@property(strong,nonatomic) NSString* total_distance; // 总距离

@property(strong,nonatomic) NSString* manual; // #是否手工输入，默认0，否
@property(strong,nonatomic) NSString* private_flag; // # 1:不公开,0:公开
@property(strong,nonatomic) NSString* average_speed; // 平均速度，提交的时候计算保存
@property(strong,nonatomic) NSString* average_pace; // 平均配速，提交的时候计算保存
@property(strong,nonatomic) NSString* max_speed; // 最大速度
@property(strong,nonatomic) NSString* average_heartrate; // 平均心率

@property(strong,nonatomic) NSString* max_heartrate; // 最大心率
@property(strong,nonatomic) NSString* calories; // 卡路里，千卡，计算，跑步和自行车的公式不一样,save的时候计算保存，提交
@property(strong,nonatomic) NSString* brocast; // #是否直播，否
@property(strong,nonatomic) NSString* like_count; // 喜欢人数
@property(strong,nonatomic) NSString* comments_count; // 评论人数
@property(strong,nonatomic) NSString* awards_count; // 此活动达成的奖励数量
@property(strong,nonatomic) NSString* device; // ios
@property(strong,nonatomic) NSString* lastsynctime; // 上次同步时间
@property(strong,nonatomic) NSMutableArray* list;// 测试数组

-(NSMutableDictionary*)activityDictWithID:(NSString*)ID user_id:(NSString*)user_id flag:(NSString*)flag start_date:(NSString*)start_date start_date_local:(NSString*)start_date_local time_zone:(NSString*)time_zone location_city:(NSString*)location_city location_province:(NSString*)location_province location_country:(NSString*)location_country start_latitude:(NSString*)start_latitude start_longitude:(NSString*)start_longitude end_latitude:(NSString*)end_latitude end_logitude:(NSString*)end_longitude  moving_time:(NSString*)moving_time elapsed_time:(NSString*)elapsed_time name:(NSString*)name description:(NSString*)descript tag:(NSString*)tag type:(NSString*)type total_elevation_gain:(NSString*)total_elevation_gain total_distance:(NSString*)total_distance manual:(NSString*)manual private_flag:(NSString*)private_flag average_speed:(NSString*)average_speed average_pace:(NSString*)average_pace max_speed:(NSString*)max_speed average_heartrate:(NSString*)average_heartrate max_heartrate:(NSString*)max_heartrate calories:(NSString*)calories brocast:(NSString*)brocast like_count:(NSString*)like_count comments_count:(NSString*)comments_count awards_count:(NSString*)awards_count device:(NSString*)device lastsynctime:(NSString*)lastsynctime list:(NSArray*)list;

 

/*



@property(strong,nonatomic) NSMutableArray* list_location; //  从起点到终点的所有经纬度数据.....
@property(strong,nonatomic) NSMutableArray* list_splits; //  按照每公里的表现拆分数据,并存储（只有RUN跑步类型有这个数据，其他类型运动，此列表都为空）
@property(strong,nonatomic) NSMutableArray* list_pics; //图片的URL，提交数据成功后，服务器返回对应图片的URL，再合并到对象中

*/



@end
