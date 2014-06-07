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
    [_netUtils requestContentWithUrl:@"" para:nil withSuccessBlock:^(id returnData) {
        TabbarViewController* tab =  viewOnSb(@"tabbar");
        [self.navigationController pushViewController:tab animated:YES];
    } withFailureBlock:^(NSError *error) {
        
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
