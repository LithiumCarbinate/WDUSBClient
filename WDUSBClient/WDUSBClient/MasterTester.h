//
//  MasterTester.h
//  WDUSBClient
//
//  Created by sixleaves on 16/11/10.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDClient;


@interface MasterTester : NSObject


@property (nonatomic, copy) void(^runUITestWithClient)(WDClient * client);

- (void)crashApplicationNow;
- (BOOL)shouldExit;
- (int)exitCode;
+ (instancetype)sharedInstance;

// 进行自定义的UI测试, 需要调用改方法, 并实现方法内的函数
- (void)runNormalUITest;
- (void)runMoneky ;
@end
