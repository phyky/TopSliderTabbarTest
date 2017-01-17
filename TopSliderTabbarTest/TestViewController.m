//
//  TestViewController.m
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/5.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)testAction:(UIButton *)snder{
    NSLog(@"test%ld",(long)self.view.tag);
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
