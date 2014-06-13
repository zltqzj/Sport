//
//  KAThread.h
//  MyThread
//
//  Created by koga kazuo on 11/08/20.
//  Copyright 2011 Kazuo Koga. All rights reserved.
//

#import <Foundation/Foundation.h>

// ランループに特化したスレッド
// -[start]を呼ぶと新規のスレッド上でランループの走行を開始する。
// 利用者は -[performSelector:onThread:...]を利用してスレッド上での実行を行うこと。
@interface KAThread : NSThread

// カレントランループを停止する
// すなわち、別スレッドから -[performSelector:onThread:...]経由で -[stopRunLoop]を
// 呼び出す必要がある。そうしない場合、呼び出しスレッドのランループが停止する。
- (void)stopRunLoop;

@end
