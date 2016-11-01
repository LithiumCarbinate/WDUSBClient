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
@implementation WDTaskDispatch

- (void)dispatchTaskToIphone:(WDTask *)task withPath:(NSString *)currentPath{
    
      [task buildDriverToIPhoneWithPath:  currentPath];
    
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
                        WDClient *client = [[WDClient alloc] initWithTask: task];
                        if ([client runTask]) {
                            exit(-1);
                        }else {
                            NSLog(@"运行任务失败");
                        }
    
                   });
      });
    

}

@end
