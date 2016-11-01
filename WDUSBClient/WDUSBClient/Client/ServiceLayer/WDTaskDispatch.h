//
//  WDTaskDispatch.h
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/31.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDTask;
@interface WDTaskDispatch : NSObject

- (void)dispatchTaskToIphone:(WDTask *)task withPath:(NSString *)currentPath;

@end
