//
//  HomeViewController.m
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/5.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.title = @"测试";
    self.showBackButton = NO;
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    NSArray *vcs = [NSArray arrayWithObjects:@"TestViewController",@"TestViewController",@"TestViewController",@"TestViewController",@"TestViewController", nil];
    
    NSArray *titles = [NSArray arrayWithObjects:@"测试1",@"测试2",@"测试3",@"测试4",@"测试5", nil];
    
    self.dataSource = [[NSMutableDictionary alloc]initWithObjectsAndKeys:vcs,@"child_name",titles,@"child_title", nil];
    self.contentView_H = SCREEN_H_NO_STATUS - 50 -300;
    self.contentView_Y = 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
