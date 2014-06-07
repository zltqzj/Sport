//
//  EMPerson.m
//  MantleDemo
//
//  Created by FFF on 14-4-9.
//  Copyright (c) 2014年 Liu Zhuang. All rights reserved.
//

#import "EMPerson.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"

@implementation EMPerson

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         @"name": @"name",
         @"age": @"age",
         @"gender": @"gender",
         @"birthDate": @"birth_date"
    };
    
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
       @"male": @(EMPersonGenderMale),
       @"female": @(EMPersonGenderFemale)
    }];
}

+ (NSValueTransformer *)birthDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id timestep) {
        unsigned long long jsTimestemp = [timestep longLongValue];
        unsigned long long objcTimestemp = jsTimestemp / 1000;
        NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:objcTimestemp];
        return birthDate;
    } reverseBlock:^id(NSDate *date) {
        NSTimeInterval ocInterval = [date timeIntervalSince1970];
        unsigned long long jsInterval = ocInterval * 1000;
        return @(jsInterval);
    }];
}
@end
