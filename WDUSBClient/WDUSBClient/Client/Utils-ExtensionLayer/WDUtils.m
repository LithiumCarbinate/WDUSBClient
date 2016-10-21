//
//  WDUtils.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDUtils.h"
#import "WDClient.h"
@implementation WDUtils

+ (BOOL)isResponseSuccess:(NSDictionary *)response {
    
    NSString *statusCode =[[response objectForKey: WDStatusCodeKey] stringValue];
    if (statusCode == nil) return false;
    
    if ([statusCode isEqualToString:@"200"]) return true;
    return false;
    
}

@end
