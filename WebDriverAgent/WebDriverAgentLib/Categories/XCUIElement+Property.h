//
//  XCUIElement+Property.h
//  WebDriverAgent
//
//  Created by sixleaves on 2016/10/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCUIElement (Property)

@property (nonatomic, strong) XCUIElement *parentElement;
@property (nonatomic, strong) NSString *wd_uuid;
@property (nonatomic, strong) NSString *appMemoryUsage;
@end
