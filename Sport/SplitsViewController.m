//
//  SplitsViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//  按电源键再恢复无法划线，从地图界面home再恢复，stats界面走了一会按下暂停，再切换到地图界面，（无法划线，因为停止了划线的方法）

#import "SplitsViewController.h"

@interface SplitsViewController ()

@end

@implementation SplitsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)reloadTable:(NSNotification*)info{
    NSLog(@"%@",info.userInfo);
    _split_data = [info.userInfo objectForKey:@"split_data"];
    NSLog(@"%@",_split_data);
    [_splitTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _split_data = [[NSMutableArray alloc] initWithCapacity:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"split_data" object:nil];
    _splitTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _splitTable.delegate = self;
    _splitTable.dataSource = self;
    [self.view addSubview:_splitTable];
    
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _split_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"cell";
    SplitCell* cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[SplitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    UIView* split_view = [[UIView alloc] init];
    
    // 135,206,235
    [split_view setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:191.0f/255.0f blue:235.0f/255.0f alpha:0.5f]];
    
  
    if (_split_data.count!=0) {
        NSDictionary* dict = [_split_data objectAtIndex:indexPath.row];
        cell.sectionLabel.text =[dict objectForKey:@"xsection"];
        cell.paceLabel.text = [dict objectForKey:@"pace_string"];
        NSLog(@"%@",[dict objectForKey:@"pace"]);
        double pace =   [[dict objectForKey:@"pace"] doubleValue];
        if (pace > 8*60) { // 根据实时配速设置蓝条条的宽度
            [split_view setFrame:CGRectMake(90, 2, 200, 27)];
        }
        else{
            int width = pace*20/48;
            [split_view setFrame:CGRectMake(90, 2, width, 27)];
        }
        [cell.contentView addSubview:split_view];
    }
   // cell.backgroundColor = [UIColor blackColor];
//    if (indexPath.row%2==0) {
//        cell.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
//    }
//    else{
//        cell.backgroundColor = [UIColor underPageBackgroundColor];
//    }
    return cell;
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
