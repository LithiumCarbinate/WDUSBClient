//
//  MasterTester.m
//  WDUSBClient
//
//  Created by sixleaves on 16/11/10.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "MasterTester.h"
#import "FBHTTPOverUSBClient.h"
#import "WDTask.h"
#import "WDClient.h"
#import "WDTaskReciver.h"
#import "WDTaskDispatch.h"
#import "WDCommandReciver.h"
#define MAX_CLIENT_NUM 10
@interface MasterTester ()
@property (nonatomic, strong)  WDClient * client;

@property (nonatomic, strong)  WDTaskReciver *taskReciver;

@property (nonatomic, strong) WDTask *buildTask;

@property (nonatomic, assign) BOOL shouldExitApplication;

@end
static MasterTester *_instance = nil;
@implementation MasterTester



- (WDTaskReciver *)taskReciver {
    
    if (_taskReciver == nil) {
        
        _taskReciver = [[WDTaskReciver alloc] init];
    }
    
    return _taskReciver;
}

- (void)runMoneky {
    

    WDCommandReciver *commandReciver = [WDCommandReciver sharedInstance];
    WDTask *task = [commandReciver getReciveTask];
    
    // 创建任务分发器
    WDTaskDispatch *dispatcher = [WDTaskDispatch new];
    
    // 开始分发任务. 需提供当前工程源码所在位置。需要自行修改。
    // /Users/sixleaves/Dropbox/AutomaticTest/WDClient/WDUSBClient
    [dispatcher dispatchTaskToIphone:task];
}

- (void)runNormalUITest {
    
    NSLog(@"开启自定义UI测试");
    WDCommandReciver *commandReciver = [WDCommandReciver sharedInstance];
    WDTask *task = [commandReciver getReciveTask];
    
    // 创建任务分发器
    WDTaskDispatch *dispatcher = [WDTaskDispatch new];

    // 设置驱动编译时间, 单位为秒, 自行根据环境更改
    const NSUInteger buildDriverTime = 15;
    
    // 编译驱动
    [task buildDriverToIPhone];

    weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(buildDriverTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        strongify(self);
        NSLog(@"编译成功,开启自定义的UI测试");
        self.client = [[WDClient alloc] initWithTask: task];
        if (_runUITestWithClient) self.runUITestWithClient(self.client);
        else {
            NSLog(@"请实现自定义的UI测试");
        }
    });
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}


- (void)crashApplicationNow {
    _shouldExitApplication = YES;
}

- (BOOL)shouldExit {
    return _shouldExitApplication;
}

- (int)exitCode {
    return -1;
}


@end
