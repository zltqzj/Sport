//
//  KANullInputSource.h
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KANullInputSource : NSObject

- (id)addToCurrentRunLoop;
- (void)invalidate;

@end
