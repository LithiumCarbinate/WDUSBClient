//
//  MonkeyTester.h
//  WDUSBClient
//
//  Created by sixleaves on 16/11/10.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonkeyTester : NSObject
- (void)crashApplicationNow;
- (void)run ;
- (BOOL)shouldExit;
- (int)exitCode;
+ (instancetype)sharedInstance;
@end
