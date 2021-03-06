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
    
    if (  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 60, 320, 480)];

    }
 
    else{
        _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
   // self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor whiteColor];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:109.0f topCapHeight:0.0f];
    
    _stats_vc1 = viewOnSb(@"stats");
    _stats_vc1.title = @"     统计    ";
    
    _split_vc2 = viewOnSb(@"splits");
    _split_vc2.title = @"      分段      ";
    
    _map_vc3 = viewOnSb(@"map");
    _map_vc3.title = @"     地图  ";
    
    
    [(StatsViewController *)_stats_vc1 initSubThread];
 
    _slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:_slideSwitchView];
    [_slideSwitchView buildUI];
    UIButton* navLeftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navLeftBtn setImage:[UIImage imageNamed:@"ab_bottom_solid_strava_actionbar.9.png"] forState:UIControlStateNormal];
   // [navLeftBtn setTitle:@"测试" forState:UIControlStateNormal];
    [navLeftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLog(@"测试");
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:navLeftBtn];
   // self.navigationItem.leftBarButtonItem = rightItem;
    [self.navigationController.navigationItem setLeftBarButtonItem:leftItem];
    
    
//    UIBarButtonItem *discountButton = [[UIBarButtonItem alloc]
//                                       initWithTitle:@"折扣信息" style:UIBarButtonItemStyleBordered
//                                       target:self action:@selector(discount:)];
//    self.navigationItem.leftBarButtonItem = discountButton;
    
    
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
        [[MyManager sharedManager] setIfDrawLine:@"NO"];
       
        vc = _stats_vc1;
       // [_map_vc3 viewDidAppear:YES];
    } else if (number == 1) {
        
        [[MyManager sharedManager] setIfDrawLine:@"NO"];
        vc =_split_vc2;
        //[_map_vc3 viewDidAppear:YES];

    } else if (number == 2) {
        
         [[MyManager sharedManager] setIfDrawLine:@"YES"];
        vc = _map_vc3;
        
        
    }
    [[(StatsViewController *)_stats_vc1 myThread] performSelector:@selector(switchMainTab:) onThread:[(StatsViewController *)_stats_vc1 myThread] withObject:[NSNumber numberWithInteger:number] waitUntilDone:NO];
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
