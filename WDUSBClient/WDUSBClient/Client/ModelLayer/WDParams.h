//
//  WDParams.h
//  WDUSBClient
//
//  Created by sixleaves on 16/10/27.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDParams : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray *uuids;
@property (nonatomic, strong) NSArray *bundleID;


@property (nonatomic, strong) NSString *uuid;
//@property (nonatomic, strong) NSString *bundleID;

@end
