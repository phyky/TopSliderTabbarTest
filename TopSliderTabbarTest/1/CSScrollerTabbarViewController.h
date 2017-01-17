//
//  CSScrollerTabbarViewController.h
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/16.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "PHYBaseViewController.h"

@interface CSScrollerTabbarViewController : PHYBaseViewController

//数据源,包含控制器类名和标题
@property (nonatomic,strong) NSMutableDictionary *dataSource;
//最底层的contentView
@property (nonatomic,strong) UIScrollView *scroContentView;
//子控制器的ContentView
@property (nonatomic, strong) UIScrollView *childScroContentView;
//顶部头
@property (nonatomic,strong) UIView *headerView;
//顶部tabbar
@property (nonatomic,strong) UIView *topTabbarView;
//底部红色指示器
@property (nonatomic,strong) UIView *indicatorView;
//选择的按钮
@property (nonatomic,strong) UIButton *selectedButton;
//设置最底层的ScrollView是否能滑动
@property (nonatomic,assign) BOOL canScro;
@end
