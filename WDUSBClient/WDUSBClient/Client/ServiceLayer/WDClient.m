//
//  WDClient.m
//  HttpDemo
//
//  Created by admini on 16/10/17.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDClient.h"
#import "WDTask.h"
#import "YYModel.h"
#import "WDHttpResponse.h"
#import "WDUtils.h"
#import "WDSize.h"
#import "NSArray+AddClient.h"
#import <AppKit/AppKit.h>
#import "WDMacro.h"
#import <stdio.h>
#import <objc/runtime.h>
#import <objc/NSObjCRuntime.h>
#import <objc/message.h>
#import "WDUtils.h"
NSString * const WDOrientationPORTRAIT = @"PORTRAIT";
NSString * const WDOrientationLANDSCAPE = @"LANDSCAPE";
NSString * const WDOrientationUIA_DEVICE_ORIENTATION_LANDSCAPERIGHT = @"UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT";
NSString * const WDOrientationUIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN = @"UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN";


NSString * const WDHttpResponseKey = @"httpResponse";
NSString * const WDSessionIDKey = @"sessionId";
NSString * const WDStatusKey = @"status";
NSString * const WDStatusCodeKey = @"statusCode";
NSString * const WDUUIDKey = @"uuid";


NSString * const WDQueryElementWithClassName = @"class name";
NSString * const WDQuertElementWithPartialLinkText = @"partial link text";

NSString * const WDWindowWidthKey = @"WDWindowWidth";
NSString * const WDWindowHeightKey = @"WDWindowHeight";
NSString * const WDMonkeyRunningTimeKey = @"WDMonkeyRunningTime";

@interface WDClient()



@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *statusCode;

@property (nonatomic, strong) NSArray *methods;

@property (nonatomic, strong) WDTask *task;

@property (nonatomic, assign) CGSize windowSize;

@property (nonatomic, strong) NSMutableDictionary *imagesKey;

@end

@implementation WDClient


- (instancetype)initWithDeviceUDID:(NSString *)deviceUDID {
    
    if (self = [super initWithDeviceUDID:deviceUDID]) {
    
    }
    return self;
}

- (instancetype)initWithTask:(WDTask *)task {
    
    _task = task;
    if (self = [super initWithDeviceUDID: _task.uuid]) {
        self.bundleID = _task.bundleID;
        self.pathForStoreImages = _task.imagesStorePath;
    }
    return self;
}


- (NSString *)bundleID {
    if (_bundleID == nil) {
        NSLog(@"must set bundleID!!!");
        exit(-1);
    }
    return _bundleID;
}

- (BOOL)startApp {
    __block BOOL isStartApp = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:@"/session" parameters:@{@"desiredCapabilities" : @{
                                                                                      @"bundleId":self.bundleID
                                                                                      }}  completion:^(NSDictionary *response, NSError *requestError) {
        strongify(self);
                                                                                          if ([response objectForKey: WDStatusCodeKey]) {
                                                                                              
                                                                                              _statusCode =[[response objectForKey: WDStatusCodeKey] stringValue];
                                                                                              if (![_statusCode isEqualToString:@"200"] || _statusCode == nil) {
                                                                                                  NSLog(@"无法通讯, 请检查数据线");
                                                                                              }else {

                                                                                                  NSDictionary *httpRes = response[WDHttpResponseKey];
                                                                                                  isStartApp = true;
                                                                                                  if ([httpRes objectForKey:WDSessionIDKey]) {
                                                                                                      _sessionID = httpRes[WDSessionIDKey];
                                                                                                  }
                                                                                              }
                                                                                              
                                                                                              NSDictionary *httpRDic = [response objectForKey: WDHttpResponseKey];
                                                                                              if (httpRDic) {
                                                                                                  
                                                                                                  id valueObj = [httpRDic objectForKey:@"value"];
                                                                                                  if ([valueObj isKindOfClass:NSString.class]) {
                                                                                                      
                                                                                                      NSString *value =  [valueObj uppercaseString];
                                                                                                      if ([value containsString:@"APPLICATION IS NOT RUNNING"]) {
                                                                                                          perror(START_APP_FAILED_MESSAGE.UTF8String);
                                                                                                          exit(-1);
                                                                                                      }
                                                                                                  }
                                                                                              }

                                                                                          }
                                                                                          dispatch_semaphore_signal(sema);
                                                                                      }];
    
   dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
   return isStartApp;
}



- (BOOL)startMonkey {
   return [self startMonkeyWithMinute: 5];
}

- (BOOL)stopMonkey {
    __block BOOL isStop = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/stopMonkey", _sessionID] parameters:nil completion:^(NSDictionary *response, NSError *requestError) {
        strongify(self);
        if ([WDUtils isResponseSuccess:response]) {
            isStop = true;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isStop;
}

- (BOOL)startMonkeyWithMinute:(NSInteger)minute {
    
    __block BOOL isFinishMonkey = false;
    _windowSize = [self windowSize];
    
    NSInteger width = _windowSize.width;
    NSInteger height = _windowSize.height;

    NSArray *method = @[@"_randomTap", @"_randomSwipeLeft", @"_randomSwipeRight", @"_randomDrag", @"_randomOrientation"];
    NSInteger methodLen = method.count;
    NSInteger numberOfEventsPerMin = 60 * 100 / 110;
    NSInteger defaultNumberOfEvents = minute * numberOfEventsPerMin;
    NSInteger numberofEvents = defaultNumberOfEvents;

    // swipe launch screen
    WDElement *scrollView = [[self findElementsByClassName: kUIScrollView] firstObject];
    int maxImagesLen = 8;
    for (int i = 0; i < maxImagesLen; i++) {
        [scrollView swipeLeft];
        if (i == maxImagesLen - 1) [self screenshot];

    }

    // find account textfileds
    NSArray *textFilds = [self findElementsByClassName: kUITextField];
     WDElement * _Nullable account = nil;
     WDElement * _Nullable password = nil;
    if (textFilds.count > 1) {
        account = textFilds[0];
        password = textFilds[1];
    }else if (textFilds.count > 0) {
        account = textFilds[0];
        password = [[self findElementsByClassName: kUISecureTextField] firstObject];
    }

    // typing account and password
    if (_task == nil) NSLog(@"请提供用户名和密码");
    else {
        [account typeText: _task.account];
        if (account) [self screenshotWithFileName:@"username"];
        [password typeText: _task.password];
        if (password) [self screenshotWithFileName:@"password"];
    }
    

    // click login button
    WDElement *loginButton = [[self findButtonsWithContainsLabelTexts: @[@"登录" , @"登入"]] firstObject];
    if (loginButton) {
        [loginButton click];
        [self screenshotWithFileName:@"login"];
    }
    
    // start monkey test
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [self screenshot];
    });
    dispatch_resume(_timer);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(minute * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isFinishMonkey = true;
    });

    
    for (int i = 0; i < numberofEvents; i++) {
        [NSThread sleepForTimeInterval: 0.15];
        NSString *callM = method[ i % methodLen];
        SEL callMSel = NSSelectorFromString(callM);
        
        void (*randomMethod)(id, SEL) = ((void(*)(id, SEL))objc_msgSend);
        randomMethod(self, callMSel);
        
        if (isFinishMonkey) break;
    }
    
    isFinishMonkey = true;
    return YES;
}

- (void)_randomTap {
    

    __block BOOL isSuccess = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST
                endpoint:[NSString stringWithFormat:@"/session/%@/randomTap", _sessionID]
              parameters:@{@"width" : @(_windowSize.width),
                           @"height" : @(_windowSize.height)
                          }
              completion:^(NSDictionary *response, NSError *requestError) {
                  
        strongify(self);
        if ([WDUtils isResponseSuccess:response]) {
            isSuccess = true;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

}

- (void)_randomSwipeLeft {

    __block BOOL isSuccess = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/randomSwipeLeft", _sessionID]
              parameters:@{@"width" : @(_windowSize.width),
                           @"height" : @(_windowSize.height)
    } completion:^(NSDictionary *response, NSError *requestError) {
        strongify(self);
        if ([WDUtils isResponseSuccess:response]) {
            isSuccess = true;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)_randomSwipeRight {

    __block BOOL isSuccess = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/randomSwipeRight", _sessionID]
              parameters:@{@"width" : @(_windowSize.width),
                      @"height" : @(_windowSize.height)
              } completion:^(NSDictionary *response, NSError *requestError) {
                strongify(self);
                if ([WDUtils isResponseSuccess:response]) {
                    isSuccess = true;
                }
                dispatch_semaphore_signal(sema);
            }];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //return isSuccess;
}

- (void)_randomDrag {

    __block BOOL isSuccess = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/randomDrag", _sessionID]
              parameters:@{@"width" : @(_windowSize.width),
                      @"height" : @(_windowSize.height)
              } completion:^(NSDictionary *response, NSError *requestError) {
                strongify(self);
                if ([WDUtils isResponseSuccess:response]) {
                    isSuccess = true;
                }
                dispatch_semaphore_signal(sema);
            }];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //return isSuccess;
}

- (void)_randomOrientation {

    __block BOOL isSuccess = false;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    weakify(self);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/randomOrientation", _sessionID]
              parameters:@{@"width" : @(_windowSize.width),
                           @"height" : @(_windowSize.height)
              } completion:^(NSDictionary *response, NSError *requestError) {
                strongify(self);
                if ([WDUtils isResponseSuccess:response]) {
                    isSuccess = true;
                }
                dispatch_semaphore_signal(sema);
            }];
    [NSThread sleepForTimeInterval: 0.2];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //return isSuccess;
}

- (NSMutableDictionary *)imagesKey {
    if (_imagesKey == nil ) {
        _imagesKey = [NSMutableDictionary dictionary];
    }
    return _imagesKey;
}

- (void)screenshotWithFileName:(NSString *)fileName {

    __block NSImage *image = nil;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDGET endpoint:@"/screenshot" parameters:@{}  completion:^(NSDictionary *response, NSError *requestError) {
        
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(@"%@", WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        NSString *base64Image = httpResponse.base64Image;
        if (base64Image == nil) {
            dispatch_semaphore_signal(signal);
            return;
        }
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Image options:1];
        image = [[NSImage alloc] initWithData: imageData];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *desktopDir = [NSString stringWithFormat:@"%@/Desktop/screenshots", NSHomeDirectory()];
        
        
        NSString *shotName = nil;
        if (fileName == nil ||  [fileName isEqualToString:@""]) { // 时间格式截图
            NSString *dateString = [WDUtils getCurretTime];
            if (dateString !=nil)
                shotName = [dateString stringByAppendingString:@".png"];
        }else {
            shotName = [fileName stringByAppendingString:@".png"];
        }
        
        NSString *fullPath = [[desktopDir stringByAppendingString:@"/"] stringByAppendingString:shotName];
        if (_pathForStoreImages) {
            fullPath = [[_pathForStoreImages stringByAppendingString:@"/"]
                        stringByAppendingString: shotName];
        }
        
        if (![fileManager fileExistsAtPath: desktopDir]) {
            [fileManager createDirectoryAtPath:desktopDir withIntermediateDirectories:YES attributes:@{NSFilePosixPermissions : @(511)} error:nil];
        }
        
        BOOL createSuccess = [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
        BOOL writeSuccess = [imageData writeToFile:fullPath atomically:YES];
        
        if (writeSuccess && createSuccess) {
            NSLog(@"%@", [@"截图成功, 位于" stringByAppendingString:fullPath] );
        }
        
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
}

- (void)screenshot {
    [self screenshotWithFileName: nil];
}

- (void)pressHome {
    [self dispatchMethod:kWDPOST endpoint:@"/homescreen" parameters:@{}  completion:^(NSDictionary *response, NSError *requestError) {
                           NSLog(@"%@", response);                                                               
    
                                                                              }];
}

- (void)deactiveAppWithDuration:(NSInteger)duration {
    [self dispatchMethod:kWDPOST endpoint:@"" parameters:@{@"duration":@(duration)}  completion:^(NSDictionary *response, NSError *requestError) {
        
    
    }];
}

- (void)setOrientation:(NSString *)orientation {
    _orientation = orientation;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/orientation", _sessionID];
    [self dispatchMethod:kWDPOST endpoint:endPoint parameters:@{@"orientation": orientation }  completion:^(NSDictionary *response, NSError *requestError) {
        
        
    }];
}


- (NSMutableArray *)_findElementsByText:(NSString *)text usingMethod:(NSString *)usingMethod {
    
    NSString *format = [usingMethod isEqualToString: @"class name"]? @"%@" : @"label=%@";
    NSMutableArray *array = [NSMutableArray array];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/elements", _sessionID] parameters:@{
                                                                                                                                     @"using" : usingMethod,
                                                                                                                                    @"value" : [NSString stringWithFormat:  format, text]
                                                                                                                                     } completion:^(NSDictionary *response, NSError *requestError) {
                                                                                                                                         
                                                                                                                                         //NSLog(@"elements = %@", response);
                                                                                                                                         NSDictionary *httpResJson  = @{};
                                                                                                                                         if ([WDUtils isResponseSuccess:response]) {
                                                                                                                                             
                                                                                                                                             httpResJson = [response objectForKey:WDHttpResponseKey];
                                                                                                                                             
                                                                                                                                             
                                                                                                                                             
                                                                                                                                         }
                                                                                                                                         WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
                                                                                                                                         
                                                                                                                                         [array addObjectsFromArray: httpResponse.elements];
                                                                                     
                                                                                                                                         [self addClientToElements: array];
                                                                                                                                         dispatch_semaphore_signal(signal);
                                                                                                                                     }];
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return array;
}

- (void)addClientToElements:(NSArray<WDElement *> *)elements {

    [elements addClient: self];
}

- (NSMutableArray *)findElementsByLinkText:(NSString *)linkText {
    return [self _findElementsByText:linkText usingMethod: @"link text"];
}


- (NSMutableArray *)findElementsByParticalLinkText:(NSString *)partialLinkText {
    //string match no contains
    return [self _findElementsByText:partialLinkText usingMethod: @"partial link text"];
}


- (NSMutableArray*)findElementsByClassName:(NSString *)className {
    return [self _findElementsByText:className usingMethod:@"class name"];
}

- (NSMutableArray<WDElement *> *)findButtonsWithContainsLabelText:(NSString *)labelText {
    return [self findButtonsWithContainsLabelTexts:@[labelText]];
}

- (NSMutableArray<WDElement *> *)findButtonsWithContainsLabelTexts:(NSArray<NSString *> *)labelTexts {
    NSArray *buttons = [self findElementsByClassName: kUIButton];
    NSMutableArray *findButtons = [NSMutableArray array];
    for (WDElement *element in buttons) {
        
        for (NSString *labelText in labelTexts) {
            if ([element.label containsString: labelText]) {
                [findButtons addObject: element];
            }
        }
    }
    return findButtons;
}

- (WDElement *)findFirstButtonWithContainsLabelText:(NSString *)labelText {
    return [[self findButtonsWithContainsLabelText:labelText] firstObject];
}

- (NSMutableArray *)findElementsByXPath:(NSString *)xpath {
    return [self _findElementsByText:xpath usingMethod:@"xpath"];
}


- (BOOL)_dealWithAlertWithActioin:(NSString *)action andSendMethod:(NSString *)method{
    __block BOOL showAlert = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/%@", _sessionID, action];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDPOST endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) showAlert = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return showAlert;
}

- (BOOL)showAlert {
    return [self _dealWithAlertWithActioin:@"alert_text" andSendMethod:kWDGET];
}

- (BOOL)acceptAlert {
    return [self _dealWithAlertWithActioin:@"accept_alert" andSendMethod:kWDPOST];
}

- (BOOL)dissmissAlert {
    return [self _dealWithAlertWithActioin:@"dismiss_alert" andSendMethod:kWDPOST];
}

- (CGSize)windowSize {
    __block WDSize *size = [WDSize new];
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/window/size", _sessionID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(@"%@", WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        size =httpResponse.size;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return (CGSize){size.width, size.height};
}

- (NSDictionary *)getSourceTree {
    __block NSMutableDictionary *tree = [NSMutableDictionary dictionary];
    NSString *endPoint = [NSString stringWithFormat:@"/source"];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(@"%@", WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
//        tree =httpResponse.size;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return tree;
}

- (NSMutableArray *)_findElementsByParticalLinkText:(NSString *)partialLinkText
                                    aboutClassType:(NSString *)classType {
   
   BOOL isFind = false;
   NSArray * elements = [self _findElementsByText:partialLinkText usingMethod: WDQuertElementWithPartialLinkText];
   NSMutableArray *array = [NSMutableArray array];
   for (WDElement *element in elements) {
        if ([element.type isEqualToString:classType]) {
            [array addObject:element];
            isFind = true;
            break;
        }
   }
   
  if (isFind) return array;
    
   elements = [self findElementsByClassName: classType];
   for (WDElement *element in elements) {
       if ([element.label containsString:partialLinkText]
           || [element.text containsString: partialLinkText]) {

           [array addObject:element];
           isFind = true;
           break;
       }else {
           
           NSArray *childrenElements = element.childrens;
           for (WDElement *childElement in childrenElements) {
               
               if ([childElement.label containsString:partialLinkText]
                   || [childElement.text containsString: partialLinkText]) {
                   
                   [array addObject: element];
                   isFind = true;
                   break;
               }
           }
           
           if (isFind) break;
       
       }
   }
   
   return array;
}

- (WDElement *)findElementByParticalLinkText:(NSString *)partialLinkText
                                    withClassType:(NSString *)classType {
    
  NSArray *elements = [self _findElementsByParticalLinkText:partialLinkText aboutClassType:classType];
  return elements.firstObject;
}



- (BOOL)runTask {

    [self screenshotWithFileName:@"install"];
    if (![self startApp]) {
        [WDUtils logError: START_APP_FAILED_MESSAGE];
        return false;
    }
    if (![self startMonkey]) {
        [WDUtils logError: START_MONKEY_FAILED_MESSAGE];
        return false;
    }
    return true;
    

}









@end
