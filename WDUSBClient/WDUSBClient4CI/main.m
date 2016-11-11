#import <Cocoa/Cocoa.h>
//#import "NSMutableArray+Operation.h"
//#import "WDTask.h"
//#import "WDCommandReciver.h"
//#import "YYModel.h"
//#import "ViewController.h"
//#import "MonkeyTester.h"


#import <WDUSBClientLib/WDClient.h>
#import <WDUSBClientLib/WDTask.h>
#import <WDUSBClientLib/MonkeyTester.h>
#import <WDUSBClientLib/WDCommandReciver.h>
NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]);


int main(int argc, const char * argv[]) {

    NSRunLoop   * runLoop;
    MonkeyTester *monkey=nil; // replace with desired class
    
    @autoreleasepool
    {
        // create run loop
        runLoop = [NSRunLoop currentRunLoop];
        
        NSMutableArray *params = _cStrsToNSStrings(argc, argv);
        NSLog(@"%@", params);
        NSString *uuid = [params wd_removeFirstObject];
        NSString *bundleID = [params wd_removeFirstObject];
        NSString *imageStorePath = [params wd_removeFirstObject];
        NSString *account = nil;
        NSString *password = nil;
        
        if (![params isEmpty]) {
            account = [params wd_removeFirstObject];
            password = [params wd_removeFirstObject];
        }
        
        // 创建任务接收器, 接受命令行任务
        WDTask *task = [WDTask new];
        task.uuid = uuid, task.bundleID = bundleID, task.imagesStorePath = imageStorePath;
        task.account = account, task.password = password;
        
        WDCommandReciver  *reciver = [WDCommandReciver sharedInstance];
        [reciver setReciveTask: task];
        
        // 创建monkey对象, 开启monkey测试
        monkey = [MonkeyTester sharedInstance];
        [monkey run];
        
        // enter run loop
        while((!(monkey.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));
        
    };
    return(monkey.exitCode);
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
