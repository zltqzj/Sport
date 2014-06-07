//
//  NSTimer+Extension.m
//
//  Created by hwj4477 on 13. 2. 15..
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)
NSDate *pauseStart, *previousFireDate;
-(void)pauseTimer{
    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0] ;
    
    previousFireDate = [self fireDate] ;
    
    [self setFireDate:[NSDate distantFuture]];
}
-(void)resumeTimer{
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    
    [self setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
 
}
@end
