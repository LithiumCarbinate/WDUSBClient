//
//  WDUtils.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDUtils.h"
#import "WDClient.h"

NSString * const START_APP_FAILED_MESSAGE = @"ERROR 1:start application failed";
NSString * const START_MONKEY_FAILED_MESSAGE = @"ERROR 2:start monkey failed";
NSString * const  MONEKEY_FINISHED_MESSAGE = @"SUCCESS 1:finished monkey";
NSString * const APPLICATION_CARSH_MESSAGE =@"ERORR 3:Application Crash";
NSString * const OTHER_MESSAGE = @"ERROR *:undefine error";

@implementation WDUtils

+ (BOOL)isResponseSuccess:(NSDictionary *)response {
    
    NSString *statusCode =[[response objectForKey: WDStatusCodeKey] stringValue];
    if (statusCode == nil) return false;
    
    if ([statusCode isEqualToString:@"200"]) return true;
    return false;
}

+ (NSString *)getCurretTime {
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    return [dateFormatter stringFromDate: currentDate];
}


/**

 Error 1:start application failed
 Error 2:start monkey failed
 
 */
+ (void)logError:(NSString *)str {
    perror(str.UTF8String);
}




@end
