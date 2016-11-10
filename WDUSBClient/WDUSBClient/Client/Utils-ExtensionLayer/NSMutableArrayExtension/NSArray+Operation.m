//
//  NSArray+Operation.m
//  WDUSBClient
//
//  Created by sixleaves on 16/11/9.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "NSArray+Operation.h"
#import "WDElement.h"
#import "WDElement+Queries.h"
@implementation NSArray (Operation)
- (void)setWheelValues:(NSString *)value, ... {
    
    va_list ap;
    va_start(ap, value);
    
    NSString *wheelValue = nil;
    int i = 1;
    NSInteger len = self.count;
    WDElement *element = self.firstObject;
    element.pickerWheelValue = value;
    while ((wheelValue = va_arg(ap, NSString *))) {
        if (i >= len) break;
        WDElement *element = [self objectAtIndex: i];
        element.pickerWheelValue = wheelValue;
        i++;
    }
    va_end(ap);
}

@end
