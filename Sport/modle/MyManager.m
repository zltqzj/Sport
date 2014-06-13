//
//  MyManager.m
//  Sport
//
//  Created by ZKR on 6/9/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager
@synthesize ifDrawLine = _ifDrawLine;
@synthesize timer_in_map = _timer_in_map;
@synthesize whole_time = _whole_time;

@synthesize section = _section;

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

//-(void)startTimer_in_map{
//    CSPausibleTimer*   _timer = [CSPausibleTimer timerWithTimeInterval:5 target:self selector:@selector(goToDrawLine) userInfo:nil repeats:YES];
//    [_timer start];
//}


@end
