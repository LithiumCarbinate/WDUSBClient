//
//  WDTaskDispatch.h
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/31.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDTask;
@class WDClient;
@interface WDTaskDispatch : NSObject

@property (nonatomic, strong) WDClient *client;
- (void)dispatchTaskToIphone:(WDTask *)task withPath:(NSString *)currentPath;


@end
