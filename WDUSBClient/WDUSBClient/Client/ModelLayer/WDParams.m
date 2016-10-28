//
//  WDParams.m
//  WDUSBClient
//
//  Created by sixleaves on 16/10/27.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDParams.h"

static WDParams *_paramsSingle;

@implementation WDParams

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _paramsSingle = [[WDParams alloc] init];
    });
    return _paramsSingle;
}

@end

