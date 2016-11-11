//
//  WDTaskDispatch.m
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/31.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDTaskDispatch.h"
#import "WDTask.h"
#import "WDClient.h"
#import "WDUtils.h"


@interface WDTaskDispatch ()



@end

@implementation WDTaskDispatch

- (void)dispatchTaskToIphone:(WDTask *)task withPath:(NSString *)currentPath{

      [task buildDriverToIPhoneWithPath:  currentPath];
    
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
                        _client = [[WDClient alloc] initWithTask: task];
                        if ([_client runTask]) {
                            [WDUtils logError: MONEKEY_FINISHED_MESSAGE];
                            [_client pressHome];
                            exit(-1);
                        }else {
                            exit(-1);
                        }
    
                   });
      });
}

- (void)dispatchTaskToIphone:(WDTask *)task {
    [self dispatchTaskToIphone:task withPath:task.driverRootPath];
}

@end
