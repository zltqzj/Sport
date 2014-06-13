//
//  RegistViewController.h
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarViewController.h"
@interface RegistViewController : UIViewController
@property(strong,nonatomic) IBOutlet UITextField* email_textField;
@property(strong,nonatomic) IBOutlet UITextField* password_textField;

@property(strong,nonatomic) IBOutlet UITextField* username_textField;

@property(strong,nonatomic) NetUtils* netUtils;
@property(weak,nonatomic) ASIFormDataRequest* request;
// 注册
-(IBAction)regist:(id)sender;

@end
