//
//  SaveViewController.h
//  Sport
//
//  Created by zhaojian on 14-6-10.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveViewController : UIViewController
// 关于保存的
@property(nonatomic,strong) IBOutlet UITextField* name;
@property(strong,nonatomic) IBOutlet UITextField* sport_type;
@property(strong,nonatomic) IBOutlet UITextField* sport_description;
 
-(IBAction)save_activity:(id)sender;
@end
