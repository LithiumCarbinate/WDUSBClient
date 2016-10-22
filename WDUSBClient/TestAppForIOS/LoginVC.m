//
//  LoginVC.m
//  WDUSBClient
//
//  Created by admini on 16/10/20.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "LoginVC.h"

@interface WDView : UIView

@end

@implementation WDView


@end

@interface LoginVC ()

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) WDView *container;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect frame = self.view.bounds;
    self.container = [[WDView alloc] initWithFrame: frame];
    CGFloat w = 200, h =44;
    _userNameTextField = [[UITextField alloc] initWithFrame: (CGRect) {frame.size.width/ 2.0 - w/ 2.0, 100, w, h}];
    _userNameTextField.text = @"请输入用户名";
    _userNameTextField.borderStyle = UITextBorderStyleLine;
    [self.container addSubview: _userNameTextField];
    
    _pwdTextField = [[UITextField alloc] initWithFrame:(CGRect) {frame.size.width/2.0 - w/2.0, 164, w, h}];
    _pwdTextField.text = @"请输入密码";
    _pwdTextField.borderStyle = UITextBorderStyleLine;
    [self.container addSubview: _pwdTextField];
    
    [self.view addSubview: self.container];
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
