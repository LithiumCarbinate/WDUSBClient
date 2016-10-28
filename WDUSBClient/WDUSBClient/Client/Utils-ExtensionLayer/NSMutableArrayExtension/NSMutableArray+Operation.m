//
//  NSMutableArray+Operation.m
//  WDUSBClient
//
//  Created by sixleaves on 16/10/27.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "NSMutableArray+Operation.h"

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

@end
