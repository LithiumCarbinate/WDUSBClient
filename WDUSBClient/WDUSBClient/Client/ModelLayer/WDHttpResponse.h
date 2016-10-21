//
//  WDHttpResponse.h
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDElement;
@class WDRect;
@class WDSize;
@interface WDHttpResponse : NSObject

@property (nonatomic, strong) NSArray *elements;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *status;

// for easy access element
@property (nonatomic, strong) WDRect *rect;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL displayed;

@property (nonatomic, assign) BOOL accessible;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, strong) WDSize *size;

@property (nonatomic, copy) NSString *name;



@end
