//
//  StatsViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "StatsViewController.h"
static int a = 1;
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

-(IBAction)begin:(id)sender{
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        
    } repeats:YES];
    //每1秒运行一次function方法。
    
   // [TSMessage showNotificationInViewController:self title:@"定位失败" subtitle:@"定位失败" type:TSMessageNotificationTypeWarning];
    
 
}


-(IBAction)end:(id)sender{
    NSLog(@"暂停");
    [_timer setFireDate:[NSDate distantFuture]];
   // [_timer pauseTimer];
}
-(IBAction)resume:(id)sender{
    NSLog(@"恢复");
    [_timer setFireDate:[NSDate distantPast]];
  //  [_timer resumeTimer];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Actions

- (IBAction)startStopTapped:(id)sender {
    NSLog(@"currentValue：%lu",self.counterLabel.currentValue);
    NSLog(@"startValue：%lu",self.counterLabel.startValue);
    NSLog(@"countDirection：%lu",(long)self.counterLabel.countDirection);
    if (self.counterLabel.isRunning) {
        [self.counterLabel stop];
        
        [self updateUIForState:kTTCounterStopped];
    } else {
        [self.counterLabel start];
        
        [self updateUIForState:kTTCounterRunning];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collectPoint" object:self userInfo:nil];
    }
}

- (IBAction)resetTapped:(id)sender {
    [self.counterLabel reset];
    
    [self updateUIForState:kTTCounterReset];
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
