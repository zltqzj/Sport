//
//  DayManagement.h
//  FamilyFinancialManagemet
//
//  Created by Sinosoft on 4/11/13.
//  Copyright (c) 2013 Sinosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayManagement : NSObject

//获取系统当前时间
+(NSString*)getCurrentDay:(BOOL)_withTime;

//获取指定日期是星期几
+(NSString*)getWeekdayFromDate:(NSString*)_str;

// NSDate -> NSString
+ (NSString *)stringFromDate:(NSDate *)date;

//将字符串转换成NSDate
+(NSDate*)dateFromeStringWithTime:(NSString*)dateString;

+(NSDate*)dateFromeStringWithoutTime:(NSString *)dateString;

+(NSDate*)dateFromeStringOnlyWithYearAndMonth:(NSString *)dateString;

//某个日期在本周内
+(BOOL)isDateThisWeek:(NSDate *)date;

//判断某天在不在本月
+(BOOL)isDateThisMonth:(NSDate *)date;

//返回当前周一
+(NSString*)getCurrentMonday;

//返回当前周日
+(NSString*)getCurrentSunday;

//获取本月月初字符串
+(NSString*)getTheFristdayOfThisMonth;

//获取本月月末字符串
+(NSString*)getTheLastdayOfThisMonth;

//上个月月初字符串
+(NSString*)getTheFristdayOfLastMonth;

//上个月月末字符串
+(NSString*)getTheLastdayOfLastMonth;

//获取某天的昨天或明天日期，返回字符串类型 参数为yesterday或tomorrow
+(NSString*)getYesterdayOrTomorrow:(NSString*)_str withTip:(NSString*)_yesterdayOrTomorrow;

//获取上周周一或周日
+(NSString*)getLastMondayOrSunday:(NSString*)_str;

//获取下周一或周日
+(NSString*)getNextMondayOrSunday:(NSString*)_str;

//判断某天在不在两个日期范围内
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
