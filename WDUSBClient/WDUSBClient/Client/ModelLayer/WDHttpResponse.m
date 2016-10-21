//
//  WDHttpResponse.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDHttpResponse.h"
#import "WDElement.h"
#import "WDRect.h"
#import "WDSize.h"
@implementation WDHttpResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"elements" : [WDElement class],
             @"rect" : [WDRect class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"elements" : @"value",
             @"rect" : @"value",
             @"text" : @"value" ,
             @"displayed" : @"value",
             @"accessible" : @"value",
             @"enabled" : @"value",
             @"name" : @"value",
             @"size" : @"value"};
}


@end
