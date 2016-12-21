//
//  NSMutableArray+Operation.m
//  WDUSBClient
//
//  Created by sixleaves on 16/10/27.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "NSMutableArray+Operation.h"
#import "WDElement.h"
#import "WDElement+Queries.h"
@implementation NSMutableArray (Operation)

- (id)wd_removeLastObject {
    
    id lastObj = [self lastObject];
    [self removeLastObject];
    return lastObj;    
}
- (id)wd_removeFirstObject {
    
    id firstObj = nil;
    if ([self count] > 0) {
        firstObj = [self firstObject];
        [self removeObjectAtIndex: 0];
    }
    return firstObj;
}

- (BOOL)isEmpty {
    
    if (self.count <= 0) return YES;
    return NO;
}

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
