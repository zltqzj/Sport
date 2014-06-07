//
//  NTPhoto.m
//  MantleDemo
//
//  Created by FFF on 14-4-8.
//  Copyright (c) 2014年 Liu Zhuang. All rights reserved.
//




#import "NTPhoto.h"
#import "MTLValueTransformer.h"

@implementation NTPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"accessLevel": @"accessLevel",
        @"attachSize": @"attachSize",
        @"attachURL": @"attachURL",
        @"blogId": @"blogId",
        @"blogType": @"blogType",
        @"content": @"content",
        @"createTime": @"createTime",
        @"deleteStatus": @"deleteStatus"
    };
}

+ (NSValueTransformer *)attachURLJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *attachURL) {
        return [NSURL URLWithString:attachURL];
    } reverseBlock:^id(NSURL *url) {
        return url.absoluteString;
    }];
}

@end
