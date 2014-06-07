//
//  NetUtils.h
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockUI.h"
#import "AFNetworking.h"

typedef void (^updateBlock)(void); // 检查更新

// ASI
typedef void (^DataConnectorSuccessBlock)(NSString * returnData);
typedef void (^DataConnectorFailureBlock)(NSString  * returnData);

// AF
typedef void (^AFCompletionBlock)(id returnData);
typedef void (^AFFailedBlcok)(NSError* error);

@interface NetUtils : NSObject
 
 
@property(nonatomic,weak) ASIFormDataRequest* utilReq;
@property(nonatomic,weak) AFHTTPRequestOperationManager* manager;

 // ASI
- (void) getContentsOfURLFromString:(NSString *) urlString
                   withSuccessBlock:(DataConnectorSuccessBlock) successBlock
                   withFailureBlock:(DataConnectorFailureBlock) failureBlock;

// af
-(void)requestContentWithUrl:(NSString*)urlString para:(NSDictionary*)dict  withSuccessBlock:(AFCompletionBlock) successBlock
            withFailureBlock:(AFFailedBlcok) failureBlock;

-(void)getUpdate:(updateBlock)completonBlock;  // 检查更新

-(void)whatNew ; // 更新的内容

@end
