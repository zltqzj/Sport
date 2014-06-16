//
//  SplitsViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBlockTableView.h"
@interface SplitsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView *splitTable;

@property(strong,nonatomic) NSMutableArray* split_data;
@end
