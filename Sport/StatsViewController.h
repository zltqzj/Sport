//
//  StatsViewController.h
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSLocationManager.h"
#import "NSTimer+Blocks.h"
#import "NSTimer+Extension.h"
@interface StatsViewController : UIViewController <PSLocationManagerDelegate>

@property(nonatomic,strong) IBOutlet UILabel* strength;
@property(strong,nonatomic) NSTimer *timer;

-(IBAction)begin:(id)sender;
-(IBAction)end:(id)sender;
-(IBAction)resume:(id)sender;
@end
