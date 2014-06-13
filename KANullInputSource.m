//
//  KANullInputSource.m
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import "KANullInputSource.h"

@interface KANullInputSource ()
@property(nonatomic, assign) CFRunLoopSourceRef source;
@end

@implementation KANullInputSource
@synthesize source = source_;

- (void)dealloc {
    if (source_) {
        CFRelease(source_);
    }
    [super dealloc];
}

#pragma mark - ランループコールバック

static void schedule(void *info, CFRunLoopRef rl, CFStringRef mode) {
}

static void cancel(void *info, CFRunLoopRef rl, CFStringRef mode) {
}

static void perform(void *info) {
}

static CFRunLoopSourceRef create(id self) {
    CFRunLoopSourceContext context = {
        .version = 0,
        .info = self,
        .retain = NULL, .release = NULL,
        .copyDescription = NULL,
        .equal = NULL, .hash = NULL,
        .schedule = schedule,
        .cancel = cancel,
        .perform = perform,
    };
    return CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
}

#pragma mark - 初期化

- (id)init {
    self = [super init];
    if (self) {
        source_ = create(self);
        if (!source_) {
            [self release];
            return nil;
        }
    }
    return self;
}

#pragma mark - 外部インターフェイス

- (id)addToCurrentRunLoop {
    CFRunLoopAddSource(CFRunLoopGetCurrent(), self.source, kCFRunLoopDefaultMode);
    return self;
}

- (void)invalidate {
    CFRunLoopSourceInvalidate(self.source);
}

@end
