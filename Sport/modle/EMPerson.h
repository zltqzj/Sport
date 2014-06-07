//
//  EMPerson.h
//  MantleDemo
//
//  Created by FFF on 14-4-9.
//  Copyright (c) 2014年 Liu Zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

typedef NS_ENUM(NSUInteger, EMPersonGender) {
    EMPersonGenderMale = 0,
    EMPersonGenderFemale = 1
};

@interface EMPerson : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger age;
@property (nonatomic, assign, readonly) EMPersonGender gender;
@property (nonatomic, strong, readonly) NSDate *birthDate;

@end

/* 
 // 测试方法（加存储）
 -(void)test{
 NSString *path = [[NSBundle mainBundle] pathForResource:@"Person" ofType:@"json"];
 NSData *data = [NSData dataWithContentsOfFile:path];
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
 
 EMPerson *person = [MTLJSONAdapter modelOfClass:[EMPerson class] fromJSONDictionary:dic error:nil];
 
 NSLog(@"person: %@", person);
 
 NSDictionary *dicee = [MTLJSONAdapter JSONDictionaryFromModel:person];
 
 NSLog(@"dicee : %@", dicee);
 }

*/