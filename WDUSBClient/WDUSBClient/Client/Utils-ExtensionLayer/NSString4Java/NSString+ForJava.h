//
//  NSString+_Java.h
//  WDUSBClient
//
//  Created by sixleaves on 16/11/11.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ForJava)

// 最后一个lastString字符的位置
- (NSInteger)lastIndexOf:(NSString *)lastString;

// 第一个非空白符的位置
- (NSInteger)firstIndexOfNOBlankString;

@end
