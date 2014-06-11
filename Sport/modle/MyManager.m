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
@synthesize section = _section;

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
