//
//  WDCommandReciver.h
//  WDUSBClient
//
//  Created by sixleaves on 16/10/31.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 命令行任务接收器
 
 */
@class WDTask;
@interface WDCommandReciver : NSObject

+ (instancetype)sharedInstance;

- (WDTask *)getReciveTask;
- (void)setReciveTask:(WDTask *)task;
@end
