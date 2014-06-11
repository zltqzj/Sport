//
//  CSPausibleTimer.h
//  Sport
//
//  Created by zhaojian on 14-6-10.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPausibleTimer : NSObject

//Timer Info
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic) id userInfo;
@property (nonatomic) BOOL repeats;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isPaused;

+(CSPausibleTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;

-(void)pause;
-(void)start;

@end
