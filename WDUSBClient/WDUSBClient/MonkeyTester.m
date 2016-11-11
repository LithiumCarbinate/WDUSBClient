//
//  MonkeyTester.m
//  WDUSBClient
//
//  Created by sixleaves on 16/11/10.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "MonkeyTester.h"
#import "FBHTTPOverUSBClient.h"
#import "WDTask.h"
#import "WDClient.h"
#import "WDTaskReciver.h"
#import "WDTaskDispatch.h"
#import "WDCommandReciver.h"
#define MAX_CLIENT_NUM 10
@interface MonkeyTester ()
@property (nonatomic, strong)  NSMutableArray<WDClient *>* clients;

@property (nonatomic, strong)  WDTaskReciver *taskReciver;

@property (nonatomic, strong) WDTask *buildTask;

@property (nonatomic, assign) BOOL shouldExitApplication;

@end
static MonkeyTester *_instance = nil;
@implementation MonkeyTester



- (WDTaskReciver *)taskReciver {
    
    if (_taskReciver == nil) {
        
        _taskReciver = [[WDTaskReciver alloc] init];
    }
    
    return _taskReciver;
}

- (NSArray<WDClient *> *)clients {
    
    if (_clients == nil) {
        _clients = [NSMutableArray arrayWithCapacity: MAX_CLIENT_NUM];
    }
    return _clients;
}

- (void)run {
    
    NSLog(@"%s", __func__);    
    WDCommandReciver *commandReciver = [WDCommandReciver sharedInstance];
    WDTask *task = [commandReciver getReciveTask];
    
    // 创建任务分发器
    WDTaskDispatch *dispatcher = [WDTaskDispatch new];
    
    // 开始分发任务. 需提供当前工程源码所在位置。需要自行修改。
    [dispatcher dispatchTaskToIphone:task withPath:@"/Users/sixleaves/Dropbox/AutomaticTest/WDClient/WDUSBClient"];
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
