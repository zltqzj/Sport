//
//  RegistViewController.m
//  Sport
//
//  Created by ZKR on 6/3/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
@synthesize email_textField = _email_textField;
@synthesize password_textField = _password_textField;
@synthesize username_textField = _username_textField;
@synthesize weight_textField = _weight_textField;
@synthesize netUtils = _netUtils;
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 注册
-(IBAction)regist:(id)sender{
 
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:_email_textField.text forKey:@"email"];
    [dict setValue:_password_textField.text forKey:@"password"];

    [dict setValue:_username_textField.text forKey:@"username"];

    [dict setValue:@"ios" forKey:@"device_type"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"device_token"];
    [dict setValue:_weight_textField.text forKey:@"weight"];
    
    [ProgressHUD show:@"正在注册"];
    [_netUtils requestContentWithUrl:REGIST para:dict withSuccessBlock:^(id returnData) {
        NSLog(@"%@",returnData);
         [ProgressHUD dismiss];
        if ([[returnData valueForKeyPath:@"success"] isEqualToString:@"true"]) {
            [TSMessage showNotificationWithTitle:@"注册成功" subtitle:@"正在进入主页……" type:TSMessageNotificationTypeSuccess];
            NSString* user_id = [returnData valueForKeyPath:@"msg"];// 存储User_id
            [[NSUserDefaults standardUserDefaults] setValue:user_id forKey:@"user_id"];
            TabbarViewController* tab = viewOnSb(@"tabbar");
            [self.navigationController pushViewController:tab animated:YES onCompletion:nil];
        }
        else if ([[returnData valueForKeyPath:@"success"] isEqualToString:@"false"]){
            [TSMessage showNotificationWithTitle:@"注册失败" subtitle:[returnData valueForKeyPath:@"msg"] type:TSMessageNotificationTypeError];
        }
    } withFailureBlock:^(NSError *error) {
        [ProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"注册失败" subtitle:@"网络不给力啊……" type:TSMessageNotificationTypeError];
    }];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _netUtils = [[NetUtils alloc] init];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_email_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
    [_username_textField resignFirstResponder];
    [_weight_textField resignFirstResponder];
}
@end
