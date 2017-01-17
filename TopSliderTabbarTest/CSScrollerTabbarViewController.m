//
//  CSScrollerTabbarViewController.m
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/16.
//  Copyright © 2017年 physoft. All rights reserved.
//
#define HEADERVIEW_H 300
#define SCRO_TOP_POSITION 100


#import "CSScrollerTabbarViewController.h"
#import "PHYCommonMacro.h"

@interface CSScrollerTabbarViewController ()<UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat contentOffset;
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
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.topTabbarView];
    [self.view addSubview:self.childScroContentView];
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W_NO_STATUS, HEADERVIEW_H)];
        _headerImage = [[UIImageView alloc]initWithFrame:_headerView.bounds];
        _headerImage.image = [UIImage imageNamed:@"bg_store.png"];
        [_headerView addSubview:_headerImage];
    }
    return _headerView;
}

-(UIView *)topTabbarView{
    if (!_topTabbarView) {
        _topTabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, HEADERVIEW_H, SCREEN_W_NO_STATUS, TOP_SLIDER_BAR_HEIGHT)];
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
        frame.size.height = SCREEN_H_NO_STATUS - (SCRO_TOP_POSITION +TOP_SLIDER_BAR_HEIGHT);
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

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && [object isKindOfClass:[UITableView class]]) {
        self.contentOffset = ((UITableView*)object).contentOffset.y;
        [self changeSubViewFrame];
    }
}

#pragma mark - privateMethod

-(void)changeSubViewFrame{
    if (self.contentOffset>=0) {
        CGRect headerView_frame = self.headerView.frame;
        CGFloat headerView_h = HEADERVIEW_H - self.contentOffset;
        
        if (headerView_h < SCRO_TOP_POSITION) {
            headerView_h = SCRO_TOP_POSITION;
        }
        
        if (headerView_h >=SCRO_TOP_POSITION) {
            double fabs_h = fabs(fabs(headerView_frame.size.height) - fabs(headerView_h));
            headerView_frame.size.height = headerView_h;
            if (fabs_h >20) {//如果差距太大，采取动画过渡
                [UIView animateWithDuration:0.15 animations:^{
                    self.headerView.frame = headerView_frame;
                    self.headerImage.frame = headerView_frame;
                }];
            }else{
                self.headerView.frame = headerView_frame;
                self.headerImage.frame = headerView_frame;
            }
        }
        
        CGRect tabbarView_frame = self.topTabbarView.frame;
        if (headerView_h >=SCRO_TOP_POSITION) {
            double fabs_y = fabs(fabs(tabbarView_frame.origin.y) - fabs(headerView_h));
            tabbarView_frame.origin.y = headerView_h;
            if (fabs_y >20) {//如果差距太大，采取动画过渡
                [UIView animateWithDuration:0.15 animations:^{
                    self.topTabbarView.frame = tabbarView_frame;
                }];
            }else{
                self.topTabbarView.frame = tabbarView_frame;
            }
            
        }
        
        CGRect scrollView_frame = self.childScroContentView.frame;
        if (headerView_h >=SCRO_TOP_POSITION) {
            double fabs_y = fabs(fabs(scrollView_frame.origin.y) - fabs(headerView_h + TOP_SLIDER_BAR_HEIGHT));
            scrollView_frame.origin.y = headerView_h + TOP_SLIDER_BAR_HEIGHT;
            if (fabs_y >20) {//如果差距太大，采取动画过渡
                [UIView animateWithDuration:0.15 animations:^{
                    self.childScroContentView.frame = scrollView_frame;
                }];
            }else{
                self.childScroContentView.frame = scrollView_frame;
            }
            
        }
    }
}

@end
