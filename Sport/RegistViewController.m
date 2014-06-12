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
    /*
    ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://run.yyzhao.com/m/reg"]];
   
    [req setPostValue:@"zltqzj@163.com" forKey:@"email"];
    [req setPostValue:@"111111" forKey:@"password"];

    [req setPostValue:@"zhaojian" forKey:@"username"];

    [req setPostValue:@"ios" forKey:@"device_type"];

    [req setPostValue:@"123456" forKey:@"device_token"];

    
    _request = req;
    [_request startAsynchronous];
    [_request setCompletionBlock:^{
        NSLog(@"返回值%@",[_request responseString]);
    }];
    [_request setFailedBlock:^{
        NSLog(@"返回值%@",[_request responseString]);

    }];
     */
    
  //  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"zltqzj@163.com",@"email",@"password",@"111111",@"zhaojian",@"username",@"ios",@"device_type",@"device_token",@"123456", nil];
    NSDictionary* dict = @{@"email": @"zltqzj@sina.cn",@"password":@"chengxuyuan",@"username":@"misschalk",@"device_type":@"ios",@"device_token":@"234567"};
    [_netUtils requestContentWithUrl:@"http://run.yyzhao.com/m/reg" para:dict withSuccessBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        _email_textField.text = [returnData valueForKeyPath:@"msg"];
    } withFailureBlock:^(NSError *error) {
       // NSLog(@"%@",returnData);
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

@end
