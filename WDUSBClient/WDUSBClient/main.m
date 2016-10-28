//
//  main.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSMutableArray+Operation.h"


NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]);

int main(int argc, const char * argv[]) {
    
    return NSApplicationMain(argc, argv);
}


NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]) {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < argc; i++) {
        
        const char *cStr = argv[i];
        NSString *nsStr = [NSString stringWithUTF8String: cStr];
        [array addObject: nsStr];
    }
    return array;
}

