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
    // Demo 1 测试本地App
    [self testAppForIOS];
    
    // Demo 2 测试微信自动发消息, 需要按照需要执行更改
    //[self testWeChatForIOS];
    
    // Demo 3 UIKitcatalog
    //[self testCatalog];
    
    // Demo 5 微信 monkey测试
    [self testMonkeyInWX];
}

- (void)testMonkeyInWX {
    
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
            
            // 开启monkey 测试
            [client startMonkey];
                   });
    }

    
}


- (void)testCatalog {
    
    for (int i = 0; i < 1; i++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            WDClient *client = (WDClient *)self.clients[i];
            [client setBundleID: @"com.example.apple-samplecode.UIKitCatalog"];
            // 启动App
            [client startApp];
            [self testActivityIndicatorsWithClient: client];
            [self testAlertController: client];
            [self testDatePicker: client];
            [self testSlider: client];
        });
  }
}

- (void)testSlider:(WDClient *)client {
    
    WDElement *element = [client findElementsByParticalLinkText:@"Sliders"].firstObject;
    [element click];
    
    WDElement *slider = [client findElementsByClassName: kUISlider][1];
    [slider dragFrom:CGPointMake(slider.location.x + slider.size.width / 2.0, slider.location.y + slider.size.height / 2.0) to:CGPointMake(slider.location.x + slider.size.width - 10, slider.location.y + slider.size.height / 2.0) forDuration:0.2];
    
    element = [client findElementByParticalLinkText:@"UIKitCatalog" withClassType:kUIButton];
    [element click];
}

- (void)testActivityIndicatorsWithClient:(WDClient *)client {
    // 获取UIKitCatalog这个label所在的button
    WDElement *element = [client findElementByParticalLinkText:@"UIKitCatalog" withClassType:kUIButton];
    [element click];
    
    // 获取包含Activity文字的第一个cell
    WDElement *avtivityCell = [client findElementByParticalLinkText:@"Activity" withClassType:kUITableViewCell];
    [avtivityCell click];
    
    element = [client findElementByParticalLinkText:@"UIKitCatalog" withClassType:kUIButton];
    [element click];
}

- (void)testAlertController:(WDClient *)client {
    
    // 获取包含Alert文字的第一个cell
    WDElement *alertCell = [client findElementsByParticalLinkText:@"Alert"].firstObject;
    [alertCell click];
    
    // 获取包含Simple的Cell
    WDElement *simpleCell = [[client findElementsByParticalLinkText:@"Simple"] firstObject];
    [simpleCell click];
    
    // 接受弹窗
    [[[client findElementsByParticalLinkText:@"OK"] firstObject] click];
    
    // 退出
    WDElement *element = [client findElementByParticalLinkText:@"UIKitCatalog" withClassType:kUIButton];
    [element click];
}

- (void)testDatePicker:(WDClient *)client {
    
    WDElement *element =[client findElementsByParticalLinkText:@"Date Picker"].firstObject;
    [element click];
    
    WDElement *datePicker = [[client findElementsByClassName: kUIDatePicker] firstObject];
    [datePicker scrollToDirection: @"up"];
    
    // 退出
    element = [client findElementByParticalLinkText:@"UIKitCatalog" withClassType:kUIButton];
    [element click];
    
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
