//
//  main.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSMutableArray+Operation.h"
#import "WDTask.h"
#import "WDCommandReciver.h"
#import "YYModel.h"
NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]);

int main(int argc, const char * argv[]) {
    
    
    NSMutableArray *params = _cStrsToNSStrings(argc, argv);
    NSString *uuid = [params wd_removeFirstObject];
    NSString *bundleID = [params wd_removeFirstObject];
    NSString *imageStorePath = [params wd_removeFirstObject];
    NSString *account = nil;
    NSString *password = nil;
    
    if (![params isEmpty]) {
        account = [params wd_removeFirstObject];
        password = [params wd_removeFirstObject];
    }
    
    WDTask *task = [WDTask new];
    task.uuid = uuid, task.bundleID = bundleID, task.imagesStorePath = imageStorePath;
    task.account = account, task.password = password;
    
//    NSDictionary *dict = [task yy_modelToJSONObject];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject: dict forKey: @"WDTaskKey"];
//    [userDefaults synchronize];

      WDCommandReciver  *reciver = [WDCommandReciver new];
      [reciver setReciveTask: task];

    return NSApplicationMain(argc, argv);
}


NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]) {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < argc; i++) {
        
        const char *cStr = argv[i];
        NSString *nsStr = [NSString stringWithUTF8String: cStr];
        [array addObject: nsStr];
    }
    return array;
}

