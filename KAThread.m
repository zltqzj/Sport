//
//  KAThread.m
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import "KAThread.h"
#import "KANullInputSource.h"


@implementation KAThread

- (void)main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // インプットソースがひとつも無いとランループは即時終了するので
    // ダミーのインプットソースを追加しておく。
    [[[[KANullInputSource alloc] init] addToCurrentRunLoop] release];

    CFRunLoopRun();

    [pool drain];
}

- (void)stopRunLoop {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
