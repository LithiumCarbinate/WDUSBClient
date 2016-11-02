//
//  ViewController.m
//  TestAppForIOS
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect) {0, 0, self.view.bounds.size.width, self.view.bounds.size.height}];
    _scrollView.backgroundColor = [UIColor redColor];

    _scrollView.contentOffset = (CGPoint) {0, 0};
    UIImage *image = [UIImage imageNamed:@"tesla.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    _scrollView.contentSize = (CGSize) {image.size.width, image.size.height};
    [_scrollView addSubview: imageView];
    [self.view addSubview: _scrollView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
