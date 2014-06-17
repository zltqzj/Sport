//
//  SplitCell.h
//  Sport
//
//  Created by zhaojian on 14-6-17.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitCell : UITableViewCell


@property(strong,nonatomic) IBOutlet UILabel* sectionLabel;
@property(strong,nonatomic) IBOutlet UILabel* paceLabel;
@property(strong,nonatomic) IBOutlet UILabel* elevateLabel;

@property(strong,nonatomic) IBOutlet UIView* split_view;


@end
