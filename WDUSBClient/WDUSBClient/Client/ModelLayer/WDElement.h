//
//  WDElement.h
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDClient;
@interface WDElement : NSObject

@property (nonatomic, copy) NSString *elementID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *label;

@property (nonatomic, weak) WDClient *client;

@end
