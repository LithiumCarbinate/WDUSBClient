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
NSString * const WDOrientationPORTRAIT = @"PORTRAIT";
NSString * const WDOrientationLANDSCAPE = @"LANDSCAPE";
NSString * const WDOrientationUIA_DEVICE_ORIENTATION_LANDSCAPERIGHT = @"UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT";
NSString * const WDOrientationUIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN = @"UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN";


NSString * const WDHttpResponseKey = @"httpResponse";
NSString * const WDSessionIDKey = @"sessionId";
NSString * const WDStatusKey = @"status";
NSString * const WDStatusCodeKey = @"statusCode";
NSString * const WDUUIDKey = @"uuid";

NSString * const WDSendHttpMsgWithPOST = @"POST";
NSString * const WDSendHttpMsgWithGET = @"GET";

@interface WDClient()



@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *statusCode;

@property (nonatomic, strong) dispatch_semaphore_t sema;

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
    [self dispatchMethod:@"POST" endpoint:@"/session" parameters:@{@"desiredCapabilities" : @{
                                                                                      @"bundleId":self.bundleID
                                                                                      }}  completion:^(NSDictionary *response, NSError *requestError) {
                                                                                          if ([response objectForKey: WDStatusCodeKey]) {
                                                                                              
                                                                                              _statusCode =[[response objectForKey: WDStatusCodeKey] stringValue];
                                                                                              if (![_statusCode isEqualToString:@"200"]) {
                                                                                                  NSLog(@"启动失败");
                                                                                              }else {

                                                                                                  NSDictionary *httpRes = response[WDHttpResponseKey];
                                                                                                  
                                                                                                  if ([httpRes objectForKey:WDSessionIDKey]) {
                                                                                                      _sessionID = httpRes[WDSessionIDKey];
                                                                                                  }
                                                                                                  
                                                                                                  
                                                                                            
                                                                                              }
                                                                                              
                                                                                              
                                                                                              
                                                                                          }
                                                                                          
                                                                                          
                                                                                          //NSLog(@"res = %@",response);
                                                                                          dispatch_semaphore_signal(_sema);
                                                                                      }];
    
   dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);

}

- (void)startMonkey {
    
}


- (void)screenshot {
    [self dispatchMethod:@"POST" endpoint:@"/screenshot" parameters:@{}  completion:^(NSDictionary *response, NSError *requestError) {
        
        //NSLog(@"picture = %@", response);
                                                                           }];
}

- (void)pressHome {
    [self dispatchMethod:@"POST" endpoint:@"/homescreen" parameters:@{}  completion:^(NSDictionary *response, NSError *requestError) {
                                                                                  
        
                                                                              }];
}

- (void)deactiveAppWithDuration:(NSInteger)duration {
    [self dispatchMethod:@"POST" endpoint:@"" parameters:@{@"duration":@(duration)}  completion:^(NSDictionary *response, NSError *requestError) {
        
    
    }];
}

- (void)setOrientation:(NSString *)orientation {
    _orientation = orientation;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/orientation", _sessionID];
    [self dispatchMethod:@"POST" endpoint:endPoint parameters:@{@"orientation": orientation }  completion:^(NSDictionary *response, NSError *requestError) {
        
        
    }];
}


- (NSMutableArray *)_findElementsByText:(NSString *)text usingMethod:(NSString *)usingMethod {
    
    NSString *format = [usingMethod isEqualToString: @"class name"]? @"%@" : @"label=%@";
    NSMutableArray *array = [NSMutableArray array];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:WDSendHttpMsgWithPOST endpoint:[NSString stringWithFormat:@"/session/%@/elements", _sessionID] parameters:@{
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

- (NSMutableArray *)getVisibleCells {
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/uiaElement/:id/getVisibleCells", _sessionID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSMutableArray *array = [NSMutableArray array];
    [self dispatchMethod:@"GET" endpoint:endPoint parameters:@{}
              completion:^(NSDictionary *response, NSError *requestError) {
                 
                  //NSLog(@"cells = %@", response);
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

- (BOOL)_dealWithAlertWithActioin:(NSString *)action andSendMethod:(NSString *)method{
    __block BOOL showAlert = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/%@", _sessionID, action];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:@"POST" endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) showAlert = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return showAlert;
}

- (BOOL)showAlert {
    return [self _dealWithAlertWithActioin:@"alert_text" andSendMethod:@"GET"];
}

- (BOOL)acceptAlert {
    return [self _dealWithAlertWithActioin:@"accept_alert" andSendMethod:@"POST"];
}

- (BOOL)dissmissAlert {
    return [self _dealWithAlertWithActioin:@"dismiss_alert" andSendMethod:@"POST"];
}

- (CGSize)windowSize {
    __block WDSize *size = [WDSize new];
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/window/size", _sessionID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self dispatchMethod:@"GET" endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(@"获取节点显示属性失败");
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
    [self dispatchMethod:@"GET" endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(@"获取节点显示属性失败");
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
//        tree =httpResponse.size;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return tree;
}








@end
