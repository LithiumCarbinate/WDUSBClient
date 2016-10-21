//
//  WDElement+Queries.h
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDElement.h"

@interface WDElement (Queries)

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGSize size;

// 锚点位于左上方的坐标
@property (nonatomic, assign) CGPoint location;

// 该节点所包含的文本
@property (nonatomic, assign) NSString *text;

@property (nonatomic, assign) BOOL displayed;

@property (nonatomic, assign) BOOL accessible;

@property (nonatomic ,assign) BOOL enabled;

@property (nonatomic, copy) NSString *name;

// Action
// 点击动作, 点击成功后返回true, 失败返回false
- (BOOL)click;

// 输入文本
- (BOOL)typeText:(NSString *)text;

// 清除输入的文本
- (BOOL)clearText;

// 滚动, 每次水平滚动距离为一个屏幕的宽度。竖直滚动是一个屏幕的高度
- (BOOL)scrollToDirection:(NSString *)direction;
- (BOOL)dragFrom:(CGPoint)from to:(CGPoint)to forDuration:(CGFloat)duration;

// 左滑
- (BOOL)swipeLeft;

// 右滑
- (BOOL)swipeRight;

@end
