//
//  NSArray+AddClient.h
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/22.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDClient;
@interface NSArray (AddClient)

- (void)addClient:(WDClient *)client;

@end
