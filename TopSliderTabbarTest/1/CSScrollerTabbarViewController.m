//
//  CSScrollerTabbarViewController.m
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/16.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "CSScrollerTabbarViewController.h"
#import "PHYCommonMacro.h"

@interface CSScrollerTabbarViewController ()<UIScrollViewDelegate>

@end

@implementation CSScrollerTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Setter&&Getter
-(void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    [self setupChildViewControllers];
    [self.view addSubview:self.scroContentView];
    [self.scroContentView addSubview:self.headerView];
    [self.scroContentView addSubview:self.topTabbarView];
    [self.scroContentView addSubview:self.childScroContentView];
    //视图加载完毕，设置最底层ScrollView的contentSize
    _scroContentView.contentSize = CGSizeMake(0, SCREEN_H_NO_STATUS + self.headerView.frame.size.height +TOP_SLIDER_BAR_HEIGHT);
    self.canScro = YES;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W_NO_STATUS, 300)];
        UIImageView *bg_image = [[UIImageView alloc]initWithFrame:_headerView.bounds];
        bg_image.image = [UIImage imageNamed:@"bg_store.png"];
        [_headerView addSubview:bg_image];
    }
    return _headerView;
}

-(UIScrollView *)scroContentView{
    if (!_scroContentView) {
        _scroContentView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scroContentView.delegate = self;
        _scroContentView.pagingEnabled = NO;
        _scroContentView.showsHorizontalScrollIndicator = NO;
    }
    return _scroContentView;
}

-(UIView *)topTabbarView{
    if (!_topTabbarView) {
        _topTabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height, SCREEN_W_NO_STATUS, TOP_SLIDER_BAR_HEIGHT)];
        _topTabbarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SLIDER_BAR_HEIGHT- TOP_INDICATOR_HEIGHT, 0, TOP_INDICATOR_HEIGHT)];
        _indicatorView.backgroundColor = [UIColor redColor];
        
        NSInteger count = self.childViewControllers.count;
        CGFloat width = SCREEN_W_NO_STATUS / count ;
        CGFloat height = TOP_SLIDER_BAR_HEIGHT;
        
        for (int i = 0; i<count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
            button.tag = i;
            UIViewController *vc = self.childViewControllers[i];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [button setTitle:vc.title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(titleClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topTabbarView addSubview:button];
            if (i == 0) {
                button.enabled = NO;
                self.selectedButton = button;
                [button.titleLabel sizeToFit];
                CGRect frame = _indicatorView.frame;
                frame.size.width = button.titleLabel.frame.size.width;
                _indicatorView.frame = frame;
                CGPoint center = _indicatorView.center;
                center.x = button.center.x;
                _indicatorView.center = center;
            }
        }
        [_topTabbarView addSubview:_indicatorView];
    }
    return _topTabbarView;
}

-(UIScrollView *)childScroContentView{
    if (!_childScroContentView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = self.topTabbarView.frame.origin.y + TOP_SLIDER_BAR_HEIGHT;
        _childScroContentView = [[UIScrollView alloc]initWithFrame:frame];
        _childScroContentView.delegate = self;
        _childScroContentView.contentSize = CGSizeMake(SCREEN_W_NO_STATUS *self.childViewControllers.count,0);
        _childScroContentView.pagingEnabled = YES;
        _childScroContentView.showsHorizontalScrollIndicator = NO;
        [self.view insertSubview:_childScroContentView atIndex:0];
        [self scrollViewDidEndScrollingAnimation:_childScroContentView];
    }
    return _childScroContentView;
}

-(void)setCanScro:(BOOL)canScro{
    _canScro = canScro;
    self.scroContentView.scrollEnabled = canScro;
    [self childrenVCScroContro];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.childScroContentView]) {
        //当前索引
        int index = (int)(scrollView.contentOffset.x / SCREEN_W_NO_STATUS);
        //拿到子控制器
        UIViewController *vc = self.childViewControllers[index];
        CGRect frame = vc.view.frame;
        frame.origin.x = scrollView.contentOffset.x;
        frame.origin.y = 0;// 设置控制器的y值为0(默认为20)
        //设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
        frame.size.height = scrollView.frame.size.height;
        vc.view.frame = frame;
        [scrollView addSubview:vc.view];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    if ([scrollView isEqual:self.scroContentView]){
        if (scrollView.contentOffset.y>_headerView.frame.size.height - 64) {
            self.canScro = NO;
        }
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.childScroContentView]) {
        [self scrollViewDidEndScrollingAnimation:self.childScroContentView];
        //当前索引
        int index = (int)(scrollView.contentOffset.x / SCREEN_W_NO_STATUS);
        UIButton *button = self.topTabbarView.subviews[index];
        [self titleClickAction:button];
    }
}


#pragma mark - SetupUI

//初始化子控制器
-(void)setupChildViewControllers{
    NSArray *child_vcs = [self.dataSource objectForKey:@"child_name"];
    NSArray *child_vc_titles = [self.dataSource objectForKey:@"child_title"];
    for (int i = 0; i<child_vcs.count; i++) {
        UIViewController *vc = [[NSClassFromString(child_vcs[i]) alloc] init];
        if (vc) {
            [self addChildViewController:vc];
            vc.title = child_vc_titles[i];
            vc.view.tag = i;
        }
    }
}

#pragma mark - Click Action

//顶部滑条点击事件
-(void)titleClickAction:(UIButton *)sender{
    //修改按钮状态
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    //执行动画
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.indicatorView.frame;
        frame.size.width = self.selectedButton.titleLabel.frame.size.width;
        self.indicatorView.frame = frame;
        CGPoint center = self.indicatorView.center;
        center.x = self.selectedButton.center.x;
        self.indicatorView.center = center;
    }];
    //滚动,切换子控制器
    CGPoint offset = self.childScroContentView.contentOffset;
    offset.x = sender.tag *SCREEN_W_NO_STATUS;
    [self.childScroContentView setContentOffset:offset animated:YES];
}

#pragma mark - privateMethod

-(void)childrenVCScroContro{
    for (UIViewController *vc in self.childViewControllers) {
        for (UIView *view in vc.view.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                ((UITableView *)view).scrollEnabled = !self.canScro;
            }
        }
    }
}

@end
