//
//  WDTaskReciver.h
//  socketDemo
//
//  Created by sixleaves on 16/10/28.
//  Copyright © 2016年 sixleaves. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 WDTaskReciver, Use to recive data from remote host.
 
 transport layer protocol is TCP protocol;

 */

@interface WDTaskReciver : NSObject

// 监听的端口
- (void)reciveDataAtLocalhostOnPort:(__uint16_t)port;

// 获取接受到的任务列表
- (NSMutableArray *)getTasks;

// 移除所有任务
- (void)removeAllTask;

// 获取当前任务个数
@property (nonatomic, assign, readonly) NSInteger currentTasksSize;

@end
