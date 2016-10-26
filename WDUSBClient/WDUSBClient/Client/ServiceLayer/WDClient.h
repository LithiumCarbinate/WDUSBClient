//
//  WDClient.h
//  HttpDemo
//
//  Created by admini on 16/10/17.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBHTTPOverUSBClient.h"
#import "WDElement.h"
#import "WDElement+Queries.h"
#import "WDClassType.h"
extern NSString * const WDOrientationPORTRAIT;
extern NSString * const WDOrientationLANDSCAPE;
extern NSString * const WDOrientationUIA_DEVICE_ORIENTATION_LANDSCAPERIGHT;
extern NSString * const WDOrientationUIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN;


extern NSString * const WDHttpResponseKey;
extern NSString * const WDSessionIDKey;
extern NSString * const WDStatusKey;
extern NSString * const WDStatusCodeKey;
extern NSString * const WDUUIDKey;

extern NSString * const WDSendHttpMsgWithPOST;
extern NSString * const WDSendHttpMsgWithGET;

@interface WDClient : FBHTTPOverUSBClient


- (instancetype)initWithDeviceUDID:(NSString *)deviceUDID;

@property (nonatomic, copy) NSString *pathForStoreImages;

@property (nonatomic, copy) NSString *sessionID;

// 设置要启动的包名
@property (nonatomic, copy) NSString *bundleID;

// 启动App
- (void)startApp;

// 开启Monkey测试, 默认5分钟
- (void)startMonkey;

// 开启monkey测试, 测试分钟数为minute
- (void)startMonkeyWithMinute:(NSInteger)minute;

// 截图
- (void)screenshot;

// 按home键
- (void)pressHome;

// 挂起App duration秒
- (void)deactiveAppWithDuration:(NSInteger)duration;

// 完全匹配Label文字, 返回匹配的数组
- (NSMutableArray *)findElementsByLinkText:(NSString *)linkText;

// 模糊匹配, 返回包含的数组
- (NSMutableArray *)findElementsByParticalLinkText:(NSString *)partialLinkText;

// 通过类名, 返回所包含的对象
- (NSMutableArray *)findElementsByClassName:(NSString *)className;

// 获取手机屏幕大小
- (CGSize)windowSize;

// 通过XPath, 返回对象
- (NSMutableArray *)findElementsByXPath:(NSString *)xpath;

// 返回可见的cells
- (NSMutableArray *)getVisibleCells;

// 查找包含partialLinkText文字的控件, 并返回第一个匹配的控件
- (WDElement *)findElementByParticalLinkText:(NSString *)partialLinkText
                               withClassType:(NSString *)classType;

- (BOOL)dissmissAlert;

/*
 时时设置App旋转方向
 提供以下方向设置
 WDOrientationPORTRAIT;
 WDOrientationLANDSCAPE;
 WDOrientationUIA_DEVICE_ORIENTATION_LANDSCAPERIGHT;
 WDOrientationUIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN;
*/
@property (nonatomic, copy) NSString *orientation;

// 获取正颗的树结构
- (NSDictionary *)getSourceTree;




@end
