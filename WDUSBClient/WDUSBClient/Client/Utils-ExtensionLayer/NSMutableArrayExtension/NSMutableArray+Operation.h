//
//  NSMutableArray+Operation.h
//  WDUSBClient
//
//  Created by sixleaves on 16/10/27.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Operation)

- (id)wd_removeLastObject;
- (id)wd_removeFirstObject;
- (BOOL)isEmpty;
@end
