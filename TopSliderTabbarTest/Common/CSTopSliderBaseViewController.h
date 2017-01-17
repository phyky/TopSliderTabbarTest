//
//  CSTopSliderBaseViewController.h
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/5.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "PHYBaseViewController.h"
#import "PHYCommonMacro.h"

@interface CSTopSliderBaseViewController : PHYBaseViewController

//数据源,包含控制器类名和标题
@property (nonatomic,strong) NSMutableDictionary *dataSource;
//顶部滑动栏
@property (nonatomic,strong) UIView *topSliderBar;
//底部红色指示器
@property (nonatomic,strong) UIView *indicatorView;
//视图容器高度
@property (nonatomic,assign) CGFloat contentView_H;
//视图容器y坐标
@property (nonatomic,assign) CGFloat contentView_Y;
@end
