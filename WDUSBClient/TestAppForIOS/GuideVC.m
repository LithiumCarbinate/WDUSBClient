//
//  GuideVC.m
//  WDUSBClient
//
//  Created by admini on 16/10/20.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "GuideVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"
@interface GuideVC () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIButton *startButton;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger numOfPages;

@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arry = [NSArray array];
    [arry addObject:@""];
    _numOfPages = 3;
    //self.view.backgroundColor = [UIColor redColor];
    
    CGRect frame = self.view.bounds;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.scrollsToTop = false;
    self.scrollView.bounces = false;
    self.scrollView.contentSize = (CGSize){_numOfPages * frame.size.width, frame.size.height};
    
    self.scrollView.delegate = self;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"GuideImage%d", i + 1]]];
    
        imageView.frame = (CGRect) {frame.size.width * i, 0, frame.size.width, frame.size.height};
        [self.scrollView addSubview: imageView];
    }
    
    [self.view addSubview:self.scrollView];
    
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.frame = (CGRect){frame.size.width / 2.0, frame.size.height - 44, pageControl.frame.size.width, pageControl.frame.size.height};
    _pageControl = pageControl;
    _pageControl.numberOfPages = 3;
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview: pageControl];
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = (CGRect){frame.size.width / 2.0 - 100 / 2.0, frame.size.height - 100, 100, 44};
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColor.grayColor.CGColor;
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    _startButton = button;
    _startButton.hidden = YES;
    [self.view addSubview:button];
    
}

#pragma mark - Action
- (void)buttonAction {
    LoginVC *loginVC = [LoginVC new];
    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = loginVC;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / self.view.bounds.size.width);
    
    if (_pageControl.currentPage == _numOfPages - 1) {
        _startButton.hidden = NO;
    }else {
        _startButton.hidden = YES;
    }
    
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
