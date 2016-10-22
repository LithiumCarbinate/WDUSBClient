//
//  NSArray+AddClient.m
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/22.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "NSArray+AddClient.h"
#import "WDElement.h"
@implementation NSArray (AddClient)

- (void)addClient:(WDClient *)client {
    for (WDElement *element in self ) {
        element.client = client;
    }
}

@end
