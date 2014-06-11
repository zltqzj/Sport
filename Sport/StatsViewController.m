//
//  StatsViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//  待解决问题：异步，地图界面右滑按钮。定时判断是否开启。 

#import "StatsViewController.h"
static int a = 1;
static int b = 0;
typedef NS_ENUM(NSInteger, kTTCounter){
    kTTCounterRunning = 0,
    kTTCounterStopped,
    kTTCounterReset,
    kTTCounterEnded
};
@interface StatsViewController ()

@end

@implementation StatsViewController
@synthesize strength = _strength;
@synthesize counterLabel = _counterLabel;
@synthesize timer = _timer;
@synthesize lblHour = _lblHour;
@synthesize lblMinite = _lblMinite;
@synthesize lblSeconds = _lblSeconds;
@synthesize lblTotalDistance = _lblTotalDistance;

@synthesize cs_timer = _cs_timer;
@synthesize whole_second = _whole_second;


-(void)beginActivity{
    
        NSLog(@"cs定时器走没走%@",[NSString stringWithFormat:@"%d",b]);
        _whole_second =[NSString stringWithFormat:@"%d",++b];
        [self calculate_h_m_s:_whole_second];
    
        if (_cs_timer.isPaused) {
            
        }else{
            
            
            [self calculate_distance:1.2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectPoint" object:self userInfo:nil];
        }
    
    
    
    
}

-(void)calculate_distance:(double)dis{
    
    
            
            
        
//            //设置SecondViewController中的值
//            mapView. = userEntity;
            
         
      //  _lblTotalDistance.text = [NSString stringWithFormat:@"%.1f",dis];
        
 
    
    
}


-(void)calculate_h_m_s:(NSString*)wholeSecond{
    
    int  w_second = [wholeSecond doubleValue];
    int hour = w_second / 3600;
    int minute = w_second % 3600 /60;
    int second = w_second %3600 %60;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hour<10) {
            _lblHour.text = [NSString stringWithFormat:@"0%d",hour];
        }else{
            _lblHour.text = [NSString stringWithFormat:@"%d",hour];
        }
        
        if (minute<10) {
            _lblMinite.text = [NSString stringWithFormat:@"0%d",minute];
        }else{
            _lblMinite.text = [NSString stringWithFormat:@"%d",minute];
            
        }
        
        if (second<10) {
            _lblSeconds.text = [NSString stringWithFormat:@"0%d",second];
        }else{
            _lblSeconds.text = [NSString stringWithFormat:@"%d",second];
        }

    });
    
    
}


-(IBAction)end:(id)sender{
    NSLog(@"完成");
    [[MyManager sharedManager] setSection:0];
    
  //  [_cs_timer pause];
//    SaveViewController* save = viewOnSb(@"save");
//     
//    [self presentViewController:save animated:YES completion:^{
//        
//    }];
   
}
-(IBAction)resume:(id)sender{
   
        if (b == 0) {
            _cs_timer = [CSPausibleTimer timerWithTimeInterval:1 target:self selector:@selector(beginActivity) userInfo:nil repeats:YES];
            NSLog(@"第一次启动");
            [[MyManager sharedManager] setSection:[[MyManager sharedManager] section]+1];
            [_cs_timer start];
        }
        else if (b!=0 && [_cs_timer isPaused]){
            [_cs_timer start];
            [[MyManager sharedManager] setSection:[[MyManager sharedManager] section]+1];
               NSLog(@"恢复");
        }
        else{
            [_cs_timer pause];
               NSLog(@"暂停");
            [[MyManager sharedManager] setIfDrawLine:NO];
        }
 
    
    
   
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)show_total_distance:(NSNotification*)info{
    NSLog(@"----%@",info);
    NSString* str = [info.userInfo objectForKey:@"_total_distance"];
    NSLog(@"%@",str);
     _lblTotalDistance.text = str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show_total_distance:) name:@"_total_distance" object:nil];
   
     [self customiseAppearance];
   
        [PSLocationManager sharedLocationManager].delegate = self;
        [[PSLocationManager sharedLocationManager] prepLocationUpdates];
        [[PSLocationManager sharedLocationManager] startLocationUpdates];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

- (void)customiseAppearance {
    [self.counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:55]];
    // _counterLabel.boldFont = [UIFont  fontWithName:@"HelveticaNeue-Medium" size:55];

    [self.counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:55]];
    
    // The font property of the label is used as the font for H,M,S and MS
    [self.counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    
    // Default label properties
    self.counterLabel.textColor = [UIColor darkGrayColor];
    
    // After making any changes we need to call update appearance
    [self.counterLabel updateApperance];
}

- (void)updateUIForState:(NSInteger)state {
    switch (state) {
        case kTTCounterRunning:
            [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
            self.resetButton.hidden = YES;
            break;
            
        case kTTCounterStopped:
            [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            self.resetButton.hidden = NO;
            break;
            
        case kTTCounterReset:
            [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            self.resetButton.hidden = YES;
            self.startStopButton.hidden = NO;
            break;
            
        case kTTCounterEnded:
            self.startStopButton.hidden = YES;
            self.resetButton.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - TTCounterLabelDelegate

- (void)countdownDidEnd {
    [self updateUIForState:kTTCounterEnded];
    
}


#pragma mark --- PSLocationManagerDelegate GPS强度

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    NSString *strengthText;
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        strengthText = NSLocalizedString(@"Weak", @"");
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        strengthText = NSLocalizedString(@"Strong", @"");
    } else {
        strengthText = NSLocalizedString(@"...", @"");
    }
    
   // self.strengthLabel.text = strengthText;
    debugLog(strengthText);
     _strength.text = strengthText;
     
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    //self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
    debugLog(NSLocalizedString(@"Consistently Weak", @""));
    _strength.text = @"Consistently Weak";
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
   // self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"meters", @"")];
    debugLog([NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"meters", @"")] );
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
   // self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
}



@end
