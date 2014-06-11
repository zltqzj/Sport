//
//  MyManager.h
//  Sport
//
//  Created by ZKR on 6/9/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPausibleTimer.h"
@interface MyManager : NSObject

@property (nonatomic, strong) NSString* ifDrawLine;
@property(nonatomic,strong) CSPausibleTimer* timer_in_map;
@property(nonatomic,assign) NSInteger section;


+ (id)sharedManager;

@end
