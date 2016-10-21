//
//  ViewController.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "ViewController.h"
#import "FBHTTPOverUSBClient.h"
#import "WDClient.h"

#define MAX_CLIENT_NUM 10

@interface ViewController ()

@property (nonatomic, strong)  NSMutableArray<FBHTTPOverUSBClient *>* clients;

@end

@implementation ViewController

- (NSArray<FBHTTPOverUSBClient *> *)clients {
    
    if (_clients == nil) {
        _clients = [NSMutableArray arrayWithCapacity: MAX_CLIENT_NUM];
    }
    return _clients;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBHTTPOverUSBClient *client = [[WDClient alloc] initWithDeviceUDID:@"a49bcbd6a9d3b24b8f70b8adde348925a5bfac6e"];
    [self.clients addObject:client];
    [self testAppForIOS];
    //[self testWeChatForIOS];
}

- (void)testWeChatForIOS {
    
    for (int i = 0; i < 1; i++) {
        // com.tencent.xin
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [(WDClient *)self.clients[i] setBundleID: @"com.tencent.xin"];
            // 启动App
            [(WDClient *)self.clients[i] startApp];
            
        });
        
    }

    
}

- (void)testAppForIOS {
    
    
    for (int i = 0; i < 1; i++) {
        // com.tencent.xin
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [(WDClient *)self.clients[i] setBundleID: @"com.nd.www.TestAppForIOS"];
            // 启动App
            [(WDClient *)self.clients[i] startApp];
            
            // 获取屏幕大小
            CGSize size = [(WDClient *)self.clients[i] windowSize];
            
            // 获取scrollView
            WDElement *scrollView = [[(WDClient *)self.clients[i] findElementsByClassName:@"XCUIElementTypeScrollView"] firstObject];
            
            // 向左滑动8次
            for (int i = 0; i < 8; i++) {
                [scrollView swipeLeft];
            }
            
            // 找到按钮点击
            NSArray *buttons = [(WDClient *)self.clients[i] findElementsByClassName:@"XCUIElementTypeButton"];
            for (WDElement *element in buttons) {
                [element click];
            }
            
            // 输入帐号密码
            NSArray *textFields =  [(WDClient *)self.clients[i] findElementsByClassName:@"XCUIElementTypeTextField"];
            WDElement *userName = [textFields firstObject];
            WDElement *pwd = [textFields lastObject];
            [userName clearText];
            [pwd clearText];
            [userName typeText:@"sixleaves"];
            [pwd typeText:@"123456789"];
            
        });
        
    }
    

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
