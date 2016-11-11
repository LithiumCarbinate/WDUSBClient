#import <Cocoa/Cocoa.h>
//#import "NSMutableArray+Operation.h"
//#import "WDTask.h"
//#import "WDCommandReciver.h"
//#import "YYModel.h"
//#import "ViewController.h"
//#import "MasterTester.h"


#import <WDUSBClientLib/WDClient.h>
#import <WDUSBClientLib/WDTask.h>
#import "MasterTester.h"
#import <WDUSBClientLib/WDCommandReciver.h>
NSMutableArray * _cStrsToNSStrings(int argc, const char * argv[]);


int main(int argc, const char * argv[]) {

    NSRunLoop   * runLoop;
    MasterTester *masterTester=nil; // replace with desired class
    
    @autoreleasepool
    {
        runLoop = [NSRunLoop currentRunLoop];
        
        NSMutableArray *params = _cStrsToNSStrings(argc, argv);

        NSString *uuid = [params wd_removeFirstObject];
        NSString *bundleID = [params wd_removeFirstObject];
        NSString *imageStorePath = [params wd_removeFirstObject];
        NSString *driverRootPath = [params wd_removeFirstObject];
        NSString *account = nil;
        NSString *password = nil;

        NSLog(@"手机的UUID: %@", uuid);
        NSLog(@"包名: %@", bundleID);
        NSLog(@"图片存储路径: %@", imageStorePath);
        NSLog(@"WDUSBClient根路径: %@", driverRootPath);

        if (![params isEmpty]) {
            account = [params wd_removeFirstObject];
            password = [params wd_removeFirstObject];
        }
        
        // 创建任务接收器, 接受命令行任务
        WDTask *task = [WDTask new];
        task.uuid = uuid, task.bundleID = bundleID, task.imagesStorePath = imageStorePath, task.driverRootPath = driverRootPath;
        task.account = account, task.password = password;
        WDCommandReciver  *reciver = [WDCommandReciver sharedInstance];
        [reciver setReciveTask: task];
        
        // 创建测试管理器对象, 开启monkey测试
        masterTester = [MasterTester sharedInstance];
        [masterTester runMoneky];

        // 开启自定义UI测试
        [masterTester setRunUITestWithClient:^(WDClient *client) {
            // 再这里实现自定义的UI测试

        }];
        // 实现后, 可以打开下面这行注释,进行测试
//        [masterTester runUITestWithClient];

        while((!(masterTester.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));
        
    };
    return(masterTester.exitCode);
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
