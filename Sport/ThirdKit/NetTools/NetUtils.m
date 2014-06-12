//
//  NetUtils.m
//  BaiduMapTest
//
//  Created by ZKR on 5/29/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "NetUtils.h"

@implementation NetUtils
 
@synthesize utilReq = _utilReq;
@synthesize manager = _manager;

- (void)getContentsOfURLFromString:(NSString *) urlString
                   withSuccessBlock:(DataConnectorSuccessBlock) successBlock
                   withFailureBlock:(DataConnectorFailureBlock) failureBlock
{
 
        NSURL * url = [NSURL URLWithString:urlString];
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
        _utilReq = request;
        [_utilReq setTimeOutSeconds:10];
        [_utilReq startAsynchronous];
        [_utilReq setCompletionBlock:^{
            successBlock([_utilReq responseString]);
        }];
        [_utilReq setFailedBlock:^{
            failureBlock([_utilReq responseString]);
        }];
 
}

-(void)requestContentWithUrl:(NSString*)urlString para:(NSDictionary*)dict withSuccessBlock:(AFCompletionBlock)successBlock withFailureBlock:(AFFailedBlcok)failureBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    _manager = manager;
    // NSDictionary *parameters = @{@"foo": @"bar"};
    NSString* url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureBlock(error);
    }];
}

 
// 检查更新
-(void)getUpdate:(updateBlock)completonBlock{
   
    [self requestContentWithUrl:UPDATE para:nil withSuccessBlock:^(id returnData) {
        if ([returnData isKindOfClass:[NSDictionary class]]) {
             NSString* verCode = [returnData objectForKey:@"verCode"];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            NSURL* url = [NSURL URLWithString:DOWNLOAD];
            
            if (![verCode isEqualToString:nowVersion] &&verCode ) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本更新" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            NSLog(@"暂不升级");
                            break;
                        case 1:
                            NSLog(@"马上升级");
                            
                            [[UIApplication sharedApplication] openURL:url];
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
    
 
}


/*  调用方法
 
 [dataConnector getContentsOfURLFromString:[self.urlTextField text]
 withSuccessBlock:(DataConnectorSuccessBlock)^(NSString * resultString) {
 [self.textView setText:resultString];
 
 
 }
 withFailureBlock:(DataConnectorFailureBlock)^(NSError * error) {
 [self.textView setText:[error description]];
 
 }];


 */



// 更新的内容
-(void)whatNew{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"whatNew"]) {
        
    }else{
        UIAlertView* alert =[ [UIAlertView alloc] initWithTitle:@"更新内容" message:WHAT_NEW delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"whatNew"];
            }
        }];
    }
}




@end
