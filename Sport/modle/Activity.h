//
//  Activity.h
//  Sport
//
//  Created by zhaojian on 14-6-6.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "MTLModel.h"
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Activity : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger age;

@end
