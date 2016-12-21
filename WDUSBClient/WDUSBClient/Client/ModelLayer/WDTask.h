//
//  WDTask.h
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/29.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTask : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, copy) NSString *imagesStorePath;

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *driverRootPath;
@property (nonatomic, copy) NSString *testAction;
// 设置monkey测试时间
@property (nonatomic, assign) NSInteger runMinites;

- (NSString *)commandForInstallDriverWithPath:(NSString *)path;
- (void)buildDriverToIPhone;
- (void)buildDriverToIPhoneWithPath:(NSString *)currentProjectPath;
@end
