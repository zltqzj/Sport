//
//  LoginViewController.h
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarViewController.h"
@interface LoginViewController : UIViewController

@property(strong,nonatomic) NetUtils* netUtils;

-(IBAction)login:(id)sender; // 登陆

@end
