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
#import "TTCounterLabel.h"
@interface StatsViewController : UIViewController <PSLocationManagerDelegate,TTCounterLabelDelegate>

@property(strong,nonatomic) IBOutlet UILabel* lblHour;
@property(strong,nonatomic) IBOutlet UILabel* lblMinite;

@property(strong,nonatomic) IBOutlet UILabel* lblSeconds;



@property(nonatomic,strong) IBOutlet UILabel* strength;
@property(nonatomic,strong) IBOutlet TTCounterLabel* counterLabel;
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property(strong,nonatomic) NSTimer *timer;

-(IBAction)begin:(id)sender;
-(IBAction)end:(id)sender;
-(IBAction)resume:(id)sender;
//

- (IBAction)startStopTapped:(id)sender;
- (IBAction)resetTapped:(id)sender;
@end
