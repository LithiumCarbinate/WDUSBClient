//
//  WDUtils.h
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const START_APP_FAILED_MESSAGE;
extern NSString * const START_MONKEY_FAILED_MESSAGE;
extern NSString * const MONEKEY_FINISHED_MESSAGE;
extern NSString * const APPLICATION_CARSH_MESSAGE;
extern NSString * const INSTALL_FINISHED_MESSAGE;

@interface WDUtils : NSObject

+ (BOOL)isResponseSuccess:(NSDictionary *)response;
+ (NSString *)getCurretTime;
+ (void)logError:(NSString *)str;
@end
