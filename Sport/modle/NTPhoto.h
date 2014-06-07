//
//  NTPhoto.h
//  MantleDemo
//
//  Created by FFF on 14-4-8.
//  Copyright (c) 2014年 Liu Zhuang. All rights reserved.
//

//"accessLevel": 0,
//"attachSize": 15515,
//"attachURL": "http://m.iyhjy.com:80/upload/photo/201404/2014040409043239049.png",
//"blogId": "c5f08a3b-bb9c-11e3-a220-00163e02123d",
//"blogType": 1,
//"content": "",
//"createTime": 1396576772000,
//"deleteStatus": 0,
//"duration": 0,
//"groupId": 5725,
//"lastModifyTime": 1396576772000,
//"photowall": 0,
//"remark": "image/jpg",
//"syncTime": 1396576776000,
//"theorder": 0,
//"thumbnail": "http://m.iyhjy.com:80/upload/photo/201404/2014040409043239049_thumb.png",
//"title": "img432577200",
//"userId": "f3c32ace-938d-11e3-a220-00163e02123d",
//"versions": 1390,
//"voiceSize": 0,
//"voiceURL": ""

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface NTPhoto : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly, assign) NSUInteger accessLevel;
@property (nonatomic, readonly, assign) NSUInteger attachSize;
@property (nonatomic, copy, readonly) NSURL *attachURL;
@property (nonatomic, copy, readonly) NSString *blogId;
@property (nonatomic, readonly, assign) NSUInteger blogType;
@property (nonatomic, readonly, copy) NSString *content;
@property (nonatomic, assign, readonly) NSUInteger createTime;
@property (nonatomic, assign, readonly) NSUInteger deleteStatus;

@end
