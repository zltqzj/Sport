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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _split_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (_split_data.count!=0) {
       
        NSDictionary* dict = [_split_data objectAtIndex:indexPath.row];
        NSLog(@"%@",dict);
      
        cell.textLabel.text =  [dict objectForKey:@"xsection"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pace_string"]];
     //   n_distance   n_time
        
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor lightGrayColor];
        }
        
        
        
    }
    
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
