//
//  LoginViewController.m
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize netUtils = _netUtils;
@synthesize password_textField = _password_textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 登陆
-(IBAction)login:(id)sender{
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
//    [dict setValue:_email_textField.text forKey:@"email"];
//    [dict setValue:_password_textField.text forKey:@"password"];
//    
//    [dict setValue:_username_textField.text forKey:@"username"];
//    
//    [dict setValue:@"ios" forKey:@"device_type"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"device_token"];
//    [ProgressHUD show:@"正在注册"];
//    [_netUtils requestContentWithUrl:REGIST para:dict withSuccessBlock:^(id returnData) {
//        NSLog(@"%@",returnData);
//        if ([[returnData valueForKeyPath:@"success"] isEqualToString:@"true"]) {
//            [ProgressHUD showSuccess:@"注册成功"];
//        }
//        else if ([[returnData valueForKeyPath:@"success"] isEqualToString:@"false"]){
//            [ProgressHUD showError:@"用户已存在"];
//        }
//    } withFailureBlock:^(NSError *error) {
//        [ProgressHUD showError:@"网络不给力啊……"];
//    }];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:_email_textField.text forKey:@"email"];
    [dict setValue:_password_textField.text forKey:@"password"];
    [dict setValue:@"ios" forKey:@"device_type"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"device_token"];
    
    [ProgressHUD show:@"正在登陆……"];
    [_netUtils requestContentWithUrl:LOGIN para:dict withSuccessBlock:^(id returnData) {
        NSLog(@"登陆返回值%@",returnData);
        [ProgressHUD dismiss];
        if ([[returnData  valueForKeyPath:@"success"] isEqualToString:@"true"]) {
            
            [TSMessage showNotificationWithTitle:@"登陆成功" subtitle:@"正在进入主页……" type:TSMessageNotificationTypeSuccess];
            NSString* user_id = [returnData valueForKeyPath:@"msg"];
            [[NSUserDefaults standardUserDefaults] setValue:user_id forKey:@"user_id"];
            NSLog(@"用户ID：%@",user_id);
            TabbarViewController* tab = viewOnSb(@"tabbar");
            [self.navigationController pushViewController:tab animated:YES onCompletion:nil];

        }
        else{
            [TSMessage showNotificationWithTitle:@"登陆失败" subtitle:[returnData valueForKeyPath:@"msg"] type:TSMessageNotificationTypeError];
        }
    } withFailureBlock:^(NSError *error) {
        [ProgressHUD dismiss];
       [TSMessage showNotificationWithTitle:@"登陆失败" subtitle:@"网速不给力啊……" type:TSMessageNotificationTypeError];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _netUtils  = [[NetUtils alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
