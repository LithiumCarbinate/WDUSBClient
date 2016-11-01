//
//  WDTask.m
//  WDUSBClient
//
//  Created by sixleaves on 2016/10/29.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDTask.h"

@interface WDTask ()

@property (nonatomic, copy) NSString *path;

@end

@implementation WDTask

- (NSString *)commandForInstallDriverWithPath:(NSString *)path {
    _path = path;
   return [@"" stringByAppendingString: [NSString stringWithFormat:@"/usr/bin/xcodebuild -project %@/WebDriverAgent/WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination \'platform=iOS,id=%@\' test-without-building", path, _uuid]];
}

- (NSString *)_commandForBuildWithoutInstallDriverWithPath:(NSString *)path {
    _path = path;
    return [@"" stringByAppendingString: [NSString stringWithFormat:@"/usr/bin/xcodebuild -project %@/WebDriverAgent/WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination \'platform=iOS,id=%@\' build-for-testing", path, _uuid]];
    
}

- (NSString *)_commandForGetProcessesInfo {
    return [NSString stringWithFormat:@"ps | grep %@", _uuid];
}



- (void)buildDriverToIPhoneWithPath:(NSString *)currentProjectPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *driverScriptsDir = [NSString stringWithFormat:@"%@/Desktop/WDAScripts", NSHomeDirectory()];
    NSString *fileName = [NSString stringWithFormat:@"%@.sh",_uuid];
    NSString *pidFileName = [NSString stringWithFormat:@"%@.txt",_uuid];
    NSString *driverScriptPath = [[driverScriptsDir stringByAppendingString:@"/"] stringByAppendingString:fileName];
    NSString *pidFullPath = [[driverScriptsDir stringByAppendingString:@"/"] stringByAppendingString:pidFileName];
    
    NSString *processScripeFileName = [NSString stringWithFormat:@"%@process.sh",_uuid];
    NSString *processInfoScriptPath = [[driverScriptsDir stringByAppendingString:@"/"] stringByAppendingString: processScripeFileName];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    if (![fileManager fileExistsAtPath:driverScriptsDir]) {
        [fileManager createDirectoryAtPath:driverScriptsDir withIntermediateDirectories:YES attributes:@{NSFilePosixPermissions : @(511)} error:nil];
    }

    if ([fileManager fileExistsAtPath:processInfoScriptPath]) {
        [fileManager removeItemAtPath:processInfoScriptPath error:nil];
    }
    BOOL isWriteGetProcessesInfo = [[self _commandForGetProcessesInfo] writeToFile:processInfoScriptPath atomically:YES];
    if (!isWriteGetProcessesInfo) {

    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            
        NSArray *lines = [self _runCommandWithScriptPath: processInfoScriptPath];
        for (NSString *line in lines) {
            if (![line isEqualToString: @""] && line != nil && [line containsString: _uuid]) {
                NSArray  *compents = [line componentsSeparatedByString:@" "];
                NSString *pid = [compents objectAtIndex: 1];
                NSString *killCMD = [@"kill -9 " stringByAppendingString: pid];
                system(killCMD.UTF8String);
            }
        }
            
        [fileManager removeItemAtPath:pidFullPath error:nil];

        
        
        BOOL createSuccess = [fileManager createFileAtPath:driverScriptPath contents:nil attributes:dict];
        
        BOOL writeSuccess = [[self commandForInstallDriverWithPath:currentProjectPath]
                             writeToFile:driverScriptPath atomically:YES];
        
        if (writeSuccess && createSuccess) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self _runScriptByTerminal: driverScriptPath];
                
            });
            
        }else {
            NSLog(@"驱动编译失败, 请检查路径是否存在: %@", driverScriptPath);
        }
    });

}

- (NSArray<NSString *> *)_runCommandWithScriptPath:(NSString *)scriptPath{

    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
    task.arguments = @[scriptPath];
    task.standardOutput = pipe;
    
    [task launch];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return [grepOutput componentsSeparatedByString:@"\n"];
}

- (void)_runScriptByTerminal:(NSString *)scriptPath {
    NSString *build =
    [NSString stringWithFormat: @"tell application \"Terminal\" to do script \"sh %@ &\"", scriptPath];
    NSAppleScript *buildAS = [[NSAppleScript alloc] initWithSource: build];
    [buildAS executeAndReturnError:nil];
}


@end
