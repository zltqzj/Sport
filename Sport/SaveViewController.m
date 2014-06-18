//
//  SaveViewController.m
//  Sport
//
//  Created by zhaojian on 14-6-10.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()

@end

@implementation SaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(IBAction)save:(id)sender{
//    NSLog(@"%@,%@,%@",_name.text,_sport_type.text,_sport_type.text);
//}
-(IBAction)save_activity:(id)sender{
    NSLog(@"%@,%@,%@",_name.text,_sport_type.text,_sport_type.text);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    
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
    [_name resignFirstResponder];
    [_sport_description resignFirstResponder];
    [_sport_type resignFirstResponder];
}
@end
