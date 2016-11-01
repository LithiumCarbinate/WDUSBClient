//
//  WDCommandReciver.m
//  WDUSBClient
//
//  Created by sixleaves on 16/10/31.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDCommandReciver.h"
#import "YYModel.h"
#import "WDTask.h"
#import "NSMutableArray+Operation.h"
static WDCommandReciver *_reciver = nil;

@interface WDCommandReciver () <NSCopying>

@property (nonatomic, strong) WDTask *task;

@end

@implementation WDCommandReciver

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reciver = [super allocWithZone:zone];
    });
    return _reciver;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reciver = [[self alloc] init];
    });
    return _reciver;
}


- (id)copyWithZone:(NSZone *)zone {
    return _reciver;
}

- (void)setReciveTask:(WDTask *)task {
    [self _setReciveTask: task];
}

- (void)_setReciveTask:(WDTask *)task {
    
    _task = task;
    
}

- (WDTask *)getReciveTask {
    return _task;
}


@end
