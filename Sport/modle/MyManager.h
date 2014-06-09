//
//  MyManager.h
//  Sport
//
//  Created by ZKR on 6/9/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject

@property (nonatomic, assign) BOOL ifDrawLine;

+ (id)sharedManager;

@end
