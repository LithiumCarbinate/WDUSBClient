//
//  WDClient.m
//  HttpDemo
//
//  Created by admini on 16/10/17.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDClient.h"

#import "YYModel.h"
#import "WDHttpResponse.h"
#import "WDUtils.h"
#import "WDSize.h"
#import "NSArray+AddClient.h"
#import <AppKit/AppKit.h>
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

@property (nonatomic, strong) dispatch_semaphore_t sema;


@property (nonatomic, strong) NSArray *methods;

@end

@implementation WDClient


- (instancetype)initWithDeviceUDID:(NSString *)deviceUDID {
    
    if (self = [super initWithDeviceUDID:deviceUDID]) {
    
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

- (void)startApp {
    
    _sema = dispatch_semaphore_create(0);
    [self dispatchMethod:kWDPOST endpoint:@"/session" parameters:@{@"desiredCapabilities" : @{
                                                                                      @"bundleId":self.bundleID
                                                                                      }}  completion:^(NSDictionary *response, NSError *requestError) {
                                                                                          if ([response objectForKey: WDStatusCodeKey]) {
                                                                                              
                                                                                              _statusCode =[[response objectForKey: WDStatusCodeKey] stringValue];
                                                                                              if (![_statusCode isEqualToString:@"200"]) {
                                                                                                  NSLog(@"启动失败");
                                                                                              }else {

                                                                                                  NSDictionary *httpRes = response[WDHttpResponseKey];
                                                                                                  NSLog(@"启动成功");
                                                                                                  if ([httpRes objectForKey:WDSessionIDKey]) {
                                                                                                      _sessionID = httpRes[WDSessionIDKey];
                                                                                                  }
                                                                                                  
                                                                                                  
                                                                                            
                                                                                              }
                                                                                              
                                                                                              
                                                                                              
                                                                                          }
                                                                                          
                                                                                          
                                                                                          
                                                                                          dispatch_semaphore_signal(_sema);
                                                                                      }];
    
   dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
}



- (void)startMonkey {
    [self startMonkeyWithMinute: 5];
}

- (void)startMonkeyWithMinute:(NSInteger)minute {
    
    CGSize size = self.windowSize;
    [self dispatchMethod:kWDPOST endpoint:[NSString stringWithFormat:@"/session/%@/monkey", _sessionID] parameters:@{ WDWindowWidthKey : @(size.width),
        WDWindowHeightKey : @(size.height),
        WDMonkeyRunningTimeKey: @(minute)
        } completion:^(NSDictionary *response, NSError *requestError) {
            
                                                }];
    

}

- (void)screenshot {
    
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
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Image options:1];
        image = [[NSImage alloc] initWithData: imageData];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *desktopDir = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
        NSString *fileName = [NSString stringWithFormat:@"WD%u.png",arc4random_uniform(-1)];
        NSString *fullPath = [[desktopDir stringByAppendingString:@"/"] stringByAppendingString:fileName];
        if (_pathForStoreImages) {
            fullPath = [[_pathForStoreImages stringByAppendingString:@"/"]
                        stringByAppendingString: fileName];
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
//    for (WDElement *element in elements ) {
//        element.client = self;
//    }
    [elements addClient: self];
}

- (NSMutableArray *)findElementsByLinkText:(NSString *)linkText {
    return [self _findElementsByText:linkText usingMethod: @"link text"];
}


- (NSMutableArray *)findElementsByParticalLinkText:(NSString *)partialLinkText {
    //string match no contains
    return [self _findElementsByText:partialLinkText usingMethod: @"partial link text"];
}


- (NSMutableArray *)findElementsByClassName:(NSString *)className {
    return [self _findElementsByText:className usingMethod:@"class name"];
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








@end
