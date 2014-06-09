//
//  StatsViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController
@synthesize strength = _strength;
@synthesize timer = _timer;

-(IBAction)begin:(id)sender{
    
   // [TSMessage showNotificationInViewController:self title:@"定位失败" subtitle:@"定位失败" type:TSMessageNotificationTypeWarning];
    
  
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
        NSLog(@"timeInterval%f",timer.timeInterval);
    } repeats:YES];
}

-(IBAction)end:(id)sender{
    NSLog(@"暂停");
    [_timer pauseTimer];
}
-(IBAction)resume:(id)sender{
    NSLog(@"恢复");
    [_timer resumeTimer];
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
    [PSLocationManager sharedLocationManager].delegate = self;
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
