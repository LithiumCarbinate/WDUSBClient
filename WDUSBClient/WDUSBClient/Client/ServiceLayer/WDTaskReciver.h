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

 走socket的任务接收器.如果要使用这种方式, 需要自己进行二次开发
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
