//
//  RecordViewController.m
//  Sport
//
//  Created by ZKR on 6/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize slideSwitchView = _slideSwitchView;
@synthesize stats_vc1  = _stats_vc1;
@synthesize split_vc2 = _split_vc2;
@synthesize map_vc3 = _map_vc3;

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
    self.title = @"Record";
    
    if (IS_IPHONE5) {
        _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 60, 320, 480)];

    }
    else{
        _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    }
    
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:109.0f topCapHeight:0.0f];
    
    _stats_vc1 = [[StatsViewController alloc] init];
    _stats_vc1.title = @"STATS";
    
    _split_vc2 = [[SplitsViewController alloc] init];
    _split_vc2.title = @"SPLITS";
    
    _map_vc3 = viewOnSb(@"map");
    _map_vc3.title = @"MAP";
    
 
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:_slideSwitchView];
    [_slideSwitchView buildUI];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return _stats_vc1;
    } else if (number == 1) {
        return _split_vc2;
    } else if (number == 2) {
        return _map_vc3;
    }   else {
        return nil;
    }
}



- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    UIViewController *vc = nil;
    if (number == 0) {
        
        vc = _stats_vc1;
    } else if (number == 1) {
        vc =_split_vc2;
    } else if (number == 2) {
        vc = _map_vc3;
    }
    // [vc viewDidCurrentView];
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
