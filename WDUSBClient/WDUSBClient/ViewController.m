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
    // 测试本地App
    [self testAppForIOS];
    
    // 测试微信自动发消息, 需要按照需要执行更改
    //[self testWeChatForIOS];
    
    
    
}

- (void)testWeChatForIOS {
    // 测试环境:
    // 输入法： 百度输入法
    //
    
    for (int i = 0; i < 1; i++) {
        // com.tencent.xin
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            WDClient *client = (WDClient *)self.clients[i];
            [client setBundleID: @"com.tencent.xin"];
            // 启动微信 App
            [client startApp];
            
            // 获取所有cell
            NSArray *elements = [client findElementsByClassName:kUITableViewCell];
            for (WDElement *element in elements) {
                // 包含自动发消息的cell
                if ([element.label containsString:@"自动发消息"]) {
                    
                    // 进入回话
                    [element click];
                    
                    for (;1;) {
                        // 开始写消息
                        NSArray *textViews = [client findElementsByClassName:kUITextView];
                        WDElement *textView = [textViews firstObject];
                        [textView typeText:@"你好!!!"];
                        
                        // 点击确认按钮
                        WDElement *elementForSure = [[client findElementsByParticalLinkText:@"确认"] firstObject];
                        [elementForSure click];
                        
                        // 点击发送
                        WDElement *elementForSend = [[client findElementsByParticalLinkText:@"发送"] firstObject];
                        [elementForSend click];
                    }
                    
                }
            }
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
            WDElement *scrollView = [[(WDClient *)self.clients[i] findElementsByClassName:kUIScrollView] firstObject];
            
            NSArray *childs = scrollView.childrens;
            
            // 向左滑动8次
            for (int i = 0; i < 8; i++) {
                [scrollView swipeLeft];
            }
            
            // 找到按钮点击
            NSArray *buttons = [(WDClient *)self.clients[i] findElementsByClassName: kUIButton];
            for (WDElement *element in buttons) {
                [element click];
            }
            
            // 获取控件文本为@"请输入用户名"的控件的父, OtherView,
            NSArray *others = [(WDClient *)self.clients[i] findElementsByClassName: kUIOther];
            for (WDElement *element in others) {
                for (WDElement *subElement in element.childrens) {
                    NSLog(@"type = %@, label = %@", subElement.type, subElement.label);
                    if ([subElement.text containsString: @"请输入用户名"]) {
                        NSLog(@"find");
                        WDElement *parent = subElement.parent;
                        NSLog(@"parent = %@, otherVIew = %@", parent.elementID, element.elementID);
                    }
                }
            }
    
            // 输入帐号密码
            NSArray *textFields =  [(WDClient *)self.clients[i] findElementsByClassName: kUITextField];
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
