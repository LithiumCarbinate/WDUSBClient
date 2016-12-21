//
//  XCUIElement+Property.m
//  WebDriverAgent
//
//  Created by sixleaves on 2016/10/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "XCUIElement+Property.h"
#import <objc/runtime.h>
@implementation XCUIElement (Property)

static char * const kParentElementKey = "parentElement";
static char * const kWDUUID = "wd_uuid";
static char * const kMemory = "wd_memory";

- (void)setAppMemoryUsage:(NSString *)appMemoryUsage {
    objc_setAssociatedObject(self, kMemory, appMemoryUsage, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)appMemoryUsage {
  return  objc_getAssociatedObject(self, kMemory);
}

- (void)setParentElement:(XCUIElement *)parentElement {
    objc_setAssociatedObject(self, kParentElementKey, parentElement, OBJC_ASSOCIATION_RETAIN);
}

- (XCUIElement *)parentElement {
    return objc_getAssociatedObject(self, kParentElementKey);
}

- (void)setWd_uuid:(NSString *)wd_uuid {
    objc_setAssociatedObject(self, kWDUUID, wd_uuid, OBJC_ASSOCIATION_COPY);
}

- (NSString *)wd_uuid {
   return objc_getAssociatedObject(self, kWDUUID);
}

@end
