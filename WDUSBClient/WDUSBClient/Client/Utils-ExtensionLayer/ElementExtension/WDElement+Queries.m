//
//  WDElement+Queries.m
//  WDUSBClient
//
//  Created by admini on 16/10/19.
//  Copyright © 2016年 netdragon. All rights reserved.
//

#import "WDElement+Queries.h"
#import "WDClient.h"
#import "WDUtils.h"
#import "YYModel.h"
#import "WDRect.h"
#import "WDHttpResponse.h"
#import "NSArray+AddClient.h"

NSString * const kWDUsing=@"using";
NSString * const kWDValue=@"value";
NSString * const kWDPOST=@"POST";
NSString * const kWDGET=@"GET";


NSString * const WDSwipeDirectionKey = @"direction";
NSString * const WDSwipeDirectionLeft = @"left";
NSString * const WDSwipeDirectionRight = @"right";
NSString * const WDSwipeDirectionUp = @"up";
NSString * const WDSwipeDirectionDown=@"down";

NSString * const WDErrorMessageWDANotStart = @"WDA Not Start!!!";

@implementation WDElement (Queries)
- (CGRect)rect {
    __block CGRect rect = (CGRect){0, 0, 0, 0};
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/rect", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        //NSLog(@"Rect = %@", response);
        NSDictionary *httpResJson  = @{};
        if ([WDUtils isResponseSuccess:response]) {
            
            httpResJson = [response objectForKey:WDHttpResponseKey];
    
        }
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        WDRect *wdRect =httpResponse.rect;
        rect = (CGRect){wdRect.x.integerValue, wdRect.y.integerValue,
            wdRect.width.integerValue, wdRect.height.integerValue};
        
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return rect;
}

- (CGSize)size {
    CGRect rect = self.rect;
    return rect.size;
}

- (CGPoint)location {
    CGPoint point = self.rect.origin;
    return point;
}

- (NSString *)text {
    __block NSString *text =@"";
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/text", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        text =httpResponse.text;
        dispatch_semaphore_signal(signal);

    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return text;
}


- (BOOL)displayed {
    __block BOOL display = false;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/displayed", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        display =httpResponse.displayed;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return display;
}

- (BOOL)accessible {
    //NSLog(@"%s", __func__);
    __block BOOL accessible = false;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/accessible", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        accessible =httpResponse.accessible;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return accessible;
}

- (BOOL)enabled {
    //NSLog(@"%s", __func__);
    __block BOOL enabled = false;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/enabled", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        enabled =httpResponse.enabled;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return enabled;
}

- (NSString *)name {
    __block NSString *name = @"";
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/attribute/name", self.client.sessionID, self.elementID];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        NSDictionary *httpResJson  = @{};
        if (![WDUtils isResponseSuccess:response]) {
            NSLog(WDErrorMessageWDANotStart);
        }
        httpResJson = [response objectForKey:WDHttpResponseKey];
        WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
        name =httpResponse.name;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return name;
}


- (BOOL)click {
    __block BOOL isClick = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/click", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) isClick = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isClick;
}

- (BOOL)typeText:(NSString *)text {
    NSArray *chars = [text componentsSeparatedByString: @""];
    __block BOOL isType = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/value", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{
                                                                       @"value" : chars
                                                                       } completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) isType = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isType;
}


- (BOOL)clearText {
    __block BOOL isClear = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/clear", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{} completion:^(NSDictionary *response, NSError *requestError) {
                                                                           if ([WDUtils isResponseSuccess: response]) isClear = true;
                                                                           dispatch_semaphore_signal(signal);
                                                                       }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isClear;
}

- (BOOL)scrollToDirection:(NSString *)direction {
    __block BOOL isScroll = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/uiaElement/%@/scroll", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{@"direction" : direction} completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) isScroll = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isScroll;
}


- (BOOL)dragFrom:(CGPoint)from to:(CGPoint)to forDuration:(CGFloat)duration {
    __block BOOL isDrag = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/uiaTarget/%@/dragfromtoforduration", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{
                                                                       @"fromX" : @(from.x),
                                                                       @"fromY" : @(from.y),
                                                                       @"toX"   : @(to.x),
                                                                       @"toY"   : @(to.y)
                                                                       } completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) isDrag = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isDrag;
}


- (BOOL)_swipeWithDirection:(NSString *)direction {

    __block BOOL isSendMessageSuccess = false;
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/swipe", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:kWDPOST endpoint:endPoint parameters:@{WDSwipeDirectionKey : direction} completion:^(NSDictionary *response, NSError *requestError) {
        if ([WDUtils isResponseSuccess: response]) isSendMessageSuccess = true;
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isSendMessageSuccess;

}

- (BOOL)swipeUp {
   return [self _swipeWithDirection: WDSwipeDirectionUp];
}

- (BOOL)swipeDown {
   return [self _swipeWithDirection: WDSwipeDirectionDown];
}

- (BOOL)swipeLeft {
    return [self _swipeWithDirection: WDSwipeDirectionLeft];
}

- (BOOL)swipeRight {
    return [self _swipeWithDirection: WDSwipeDirectionRight];
}


- (NSArray *)childrensWithSendMethod:(NSString *)sendMethod usingFindMethod:(NSString *)using value:(NSString *)value{
    NSMutableArray *elements = [NSMutableArray array];
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/element/%@/elements", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    [self.client dispatchMethod:sendMethod endpoint:endPoint parameters:
  @{ kWDUsing :  using,
     kWDValue :  value
     } completion:^(NSDictionary *response, NSError *requestError) {
         NSDictionary *httpResJson  = @{};
         if ([WDUtils isResponseSuccess:response]) {
             
             httpResJson = [response objectForKey:WDHttpResponseKey];
             
         }
         WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
         
         [elements addObjectsFromArray: httpResponse.elements];
         [elements addClient: self.client];
        dispatch_semaphore_signal(signal);
    }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return elements;
}

// update 2016-10-22
- (NSArray *)childrensWithClassType:(NSString *)classType {
    return [self childrensWithSendMethod:kWDPOST usingFindMethod:@"class name" value:classType];
}

- (NSArray *)childrens {
    return [self childrensWithClassType:kUIAny];
}


- (NSMutableArray *)getVisibleCells {
    
    NSString *endPoint = [NSString stringWithFormat:@"/session/%@/uiaElement/%@/getVisibleCells", self.client.sessionID, self.elementID];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSMutableArray *array = [NSMutableArray array];
    [self.client dispatchMethod:kWDGET endpoint:endPoint parameters:@{}
              completion:^(NSDictionary *response, NSError *requestError) {

                  NSDictionary *httpResJson  = @{};
                  if ([WDUtils isResponseSuccess:response]) {
                      
                      httpResJson = [response objectForKey:WDHttpResponseKey];
                      
                  }
                  WDHttpResponse *httpResponse = [WDHttpResponse yy_modelWithJSON:  httpResJson];
                  [array addObjectsFromArray: httpResponse.elements];
                  [array addClient: self.client];
                  dispatch_semaphore_signal(signal);
              }];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return array;
}




@end
