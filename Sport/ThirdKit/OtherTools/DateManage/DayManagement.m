//
//  DayManagement.m
//  FamilyFinancialManagemet
//
//  Created by Sinosoft on 4/11/13.
//  Copyright (c) 2013 Sinosoft. All rights reserved.
//

#import "DayManagement.h"

@implementation DayManagement

//获取系统当前时间
+(NSString*)getCurrentDay:(BOOL)_withTime
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    if (YES == _withTime)
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* currentDay = [dateFormatter stringFromDate:date];
    
    return currentDay;
}


+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    
    return destDateString;
    
}

//获取指定日期是星期几
+(NSString*)getWeekdayFromDate:(NSString*)_str
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormat dateFromString:_str];
    NSLog(@"date:%@",date);
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]  ;
  
    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* components = [[NSDateComponents alloc] init] ;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];

    if(weekday == 1)
        return @"周日";
    if(weekday == 2)
        return @"周一";
    if(weekday == 3)
        return @"周二";
    if(weekday == 4)
        return @"周三";
    if(weekday == 5)
        return @"周四";
    if(weekday == 6)
        return @"周五";
    if(weekday == 7)
        return @"周六";
    else
        return nil;
}


//将字符串转换成NSDate
+(NSDate*)dateFromeStringWithTime:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
   
    return destDate;
}

+(NSDate*)dateFromeStringWithoutTime:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+(NSDate*)dateFromeStringOnlyWithYearAndMonth:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM-dd"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
 
    return destDate;
}

//某个日期在本周内
+(BOOL)isDateThisWeek:(NSDate *)date
{
    
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate]+24*3600;
    NSTimeInterval dayStartInSecs = [start timeIntervalSinceReferenceDate]+24*3600;
    if(dateInSecs >= dayStartInSecs && dateInSecs <= (dayStartInSecs + extends))
        return YES;
    else
        return NO;
    
}

//判断某天在不在本月
+(BOOL)isDateThisMonth:(NSDate *)date {
    
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSMonthCalendarUnit startDate:&start interval: &extends forDate:today];
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs >= dayStartInSecs && dateInSecs <= (dayStartInSecs+extends))
        return YES;
    else
        return NO;
    
}

//返回当前周一
+(NSString*)getCurrentMonday
{
    NSDate* newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok)
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    else
        return nil;
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
   
    
    return beginString;
}

//返回当前周日
+(NSString*)getCurrentSunday
{
    NSDate* newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
 
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok)
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    else
        return nil;
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    
    
    return endString;

}

//获取本月月初字符串
+(NSString*)getTheFristdayOfThisMonth
{
    NSDate* newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok)
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    else
        return nil;
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
  
    
    return beginString;

}

//获取本月月末字符串
+(NSString*)getTheLastdayOfThisMonth
{
    NSDate* newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok)
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    else
        return nil;
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    
    return endString;

}

//上个月月初字符串
+(NSString*)getTheFristdayOfLastMonth
{
    return nil;
}

//上个月月末字符串
+(NSString*)getTheLastdayOfLastMonth
{
    return nil;
}

//获取某天的昨天或明天日期，返回字符串类型 参数为yesterday或tomorrow
+(NSString*)getYesterdayOrTomorrow:(NSString*)_str withTip:(NSString*)_yesterdayOrTomorrow
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormat dateFromString:_str];
    NSTimeInterval aDay=0;
    if ([_yesterdayOrTomorrow isEqualToString:@"yesterday"])
        aDay = -24 * 60 * 60;
    else if([_yesterdayOrTomorrow isEqualToString:@"tomorrow"])
        aDay = 24 * 60 * 60;
    else
    {
       
        return nil;
    }
    NSDate* day=[date dateByAddingTimeInterval:aDay];
    NSString* strDay=[dateFormat stringFromDate:day];
   
    return strDay;
}

//获取上周周一或周日
+(NSString*)getLastMondayOrSunday:(NSString*)_str
{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormat dateFromString:_str];
    NSTimeInterval aDay=0;
    aDay = -24 * 60 * 60 * 7 ;
    NSDate* day=[date dateByAddingTimeInterval:aDay];
    NSString* strDay=[dateFormat stringFromDate:day];
   
    return strDay;
    
}

//获取下周一或周日
+(NSString*)getNextMondayOrSunday:(NSString*)_str
{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormat dateFromString:_str];
    NSTimeInterval aDay=0;
    aDay = 24 * 60 * 60 * 7 ;
    NSDate* day=[date dateByAddingTimeInterval:aDay];
    NSString* strDay=[dateFormat stringFromDate:day];
   
    return strDay;
    
    
}

//判断某天在不在两个日期范围内
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
@end
