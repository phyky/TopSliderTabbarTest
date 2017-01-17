//
//  CSTopSliderBaseViewController.m
//  TopSliderTabbarTest
//
//  Created by pang on 17/1/5.
//  Copyright © 2017年 physoft. All rights reserved.
//

#import "CSTopSliderBaseViewController.h"

@interface CSTopSliderBaseViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation CSTopSliderBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter

-(void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    [self setupChildViewControllers];
    [self setupTopSliderBar];
    [self setupScrollview];
}

-(void)setContentView_H:(CGFloat)contentView_H{
    _contentView_H = contentView_H;
    CGRect frame = self.scrollView.frame;
    frame.size.height = contentView_H - TOP_SLIDER_BAR_HEIGHT;
    self.scrollView.frame = frame;
}

-(void)setContentView_Y:(CGFloat)contentView_Y{
    _contentView_Y = contentView_Y;
    CGRect frame = self.scrollView.frame;
    frame.origin.y = contentView_Y + TOP_SLIDER_BAR_HEIGHT;
    self.scrollView.frame = frame;
    
    CGRect frame2 = self.topSliderBar.frame;
    frame2.origin.y = contentView_Y;
    self.topSliderBar.frame = frame2;
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
            vc.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        }
    }
}

//初始化顶部标签栏
-(void)setupTopSliderBar{
    self.topSliderBar = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_W_NO_STATUS, TOP_SLIDER_BAR_HEIGHT)];
    self.topSliderBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.topSliderBar];
    
    self.indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SLIDER_BAR_HEIGHT- TOP_INDICATOR_HEIGHT, 0, TOP_INDICATOR_HEIGHT)];
    self.indicatorView.backgroundColor = [UIColor redColor];
    
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
        [self.topSliderBar addSubview:button];
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            [button.titleLabel sizeToFit];
            CGRect frame = self.indicatorView.frame;
            frame.size.width = button.titleLabel.frame.size.width;
            self.indicatorView.frame = frame;
            CGPoint center = self.indicatorView.center;
            center.x = button.center.x;
            self.indicatorView.center = center;
        }
    }
    [self.topSliderBar addSubview:self.indicatorView];
    
}

//初始化容器scrollview
-(void)setupScrollview{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, self.topSliderBar.frame.origin.y + TOP_SLIDER_BAR_HEIGHT, SCREEN_W_NO_STATUS, SCREEN_H_NO_STATUS - (self.topSliderBar.frame.origin.y + TOP_SLIDER_BAR_HEIGHT));
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_W_NO_STATUS *self.childViewControllers.count, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.backgroundColor = [UIColor brownColor];
    [self.view insertSubview:self.scrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
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
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = sender.tag *SCREEN_W_NO_STATUS;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    //当前索引
    int index = (int)(scrollView.contentOffset.x / SCREEN_W_NO_STATUS);
    UIButton *button = self.topSliderBar.subviews[index];
    [self titleClickAction:button];
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
