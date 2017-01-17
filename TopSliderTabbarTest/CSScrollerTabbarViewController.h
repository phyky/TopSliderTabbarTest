//
//  CSScrollerTabbarViewController.h
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/16.
//  Copyright © 2017年 physoft. All rights reserved.
//
#define OBSERVER_KEYPATH @"contentOffset"

#import "PHYBaseViewController.h"

@interface CSScrollerTabbarViewController : PHYBaseViewController

//数据源,包含控制器类名和标题
@property (nonatomic,strong) NSMutableDictionary *dataSource;
//子控制器的ContentView
@property (nonatomic, strong) UIScrollView *childScroContentView;
//顶部头
@property (nonatomic,strong) UIView *headerView;
//顶部背景图
@property (nonatomic,strong) UIImageView *headerImage;
//顶部tabbar
@property (nonatomic,strong) UIView *topTabbarView;
//底部红色指示器
@property (nonatomic,strong) UIView *indicatorView;
//选择的按钮
@property (nonatomic,strong) UIButton *selectedButton;

@end
