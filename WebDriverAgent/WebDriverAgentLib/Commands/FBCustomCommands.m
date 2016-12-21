/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBCustomCommands.h"

#import <XCTest/XCUIDevice.h>

#import "FBApplication.h"
#import "FBConfiguration.h"
#import "FBExceptionHandler.h"
#import "FBKeyboard.h"
#import "FBResponsePayload.h"
#import "FBRoute.h"
#import "FBRouteRequest.h"
#import "FBSession.h"
#import "FBSpringboardApplication.h"
#import "XCUIApplication+FBHelpers.h"
#import "XCUIDevice+FBHelpers.h"
#import "XCUIElement.h"
#import "XCUIElementQuery.h"
#import "FBLogger.h"
#import "XCUIElement+FBWebDriverAttributes.h"
#import "XCUICoordinate.h"
#import "FBOrientationCommands.h"
#import "FBFindElementCommands.h"
#import "FBRouteRequest-Private.h"
#import <objc/message.h>
#import "WDClassType.h"
#import "XCUIElement+Property.h"
#import <mach/mach.h>
#import "FBResponseJSONPayload.h"
NSString * const WDWindowWidthKey = @"WDWindowWidth";
NSString * const WDWindowHeightKey = @"WDWindowHeight";
NSString * const WDMonkeyRunningTimeKey = @"WDMonkeyRunningTime";

BOOL _isStopMonkey = false;
@interface FBCustomCommands ()


@end

@implementation FBCustomCommands

+ (NSArray *)routes
{
  return
  @[
    // for monkey
    [[FBRoute POST:@"/randomTap"] respondWithTarget:self action:@selector(handleTapCommand:)],
    [[FBRoute POST:@"/randomSwipeLeft"] respondWithTarget:self action:@selector(_swipeLeft:)],
    [[FBRoute POST:@"/randomSwipeRight"] respondWithTarget:self action:@selector(_swipeRight:)],
    [[FBRoute POST:@"/randomDrag"] respondWithTarget:self action:@selector(_drag:)],
    [[FBRoute POST:@"/randomOrientation"] respondWithTarget:self action:@selector(_orientation:)],
    
    
    [[FBRoute POST:@"/tap"] respondWithTarget:self action:@selector(handleTap:)],
    
    [[FBRoute POST:@"/homescreen"].withoutSession respondWithTarget:self action:@selector(handleHomescreenCommand:)],
    [[FBRoute POST:@"/deactivateApp"] respondWithTarget:self action:@selector(handleDeactivateAppCommand:)],
    [[FBRoute POST:@"/timeouts"] respondWithTarget:self action:@selector(handleTimeouts:)],
    [[FBRoute POST:@"/getMemory"] respondWithTarget:self action:@selector(getMemory:)]
//    [[FBRoute POST:@"/exitWDA"] respondWithTarget:self action:@selector(handleExitWDACommand:)],
  ];
}


#pragma mark - Commands
+ (id<FBResponsePayload>)handleTap:(FBRouteRequest *)request {
    
    FBSession *session = request.session;
    
    int32_t x = [request.parameters[@"x"] intValue];
    int32_t y = [request.parameters[@"y"] intValue];
    NSString *strX = @(x).stringValue;
    NSString *strY = @(y).stringValue;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *tapCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:CGVectorMake(strX.floatValue, strY.floatValue)];
    [FBLogger logFmt:@"tap at (%f, %f)", strX.floatValue, strY.floatValue];
    [tapCoordinate tap];
    return FBResponseWithOK();
}



+ (id<FBResponsePayload>)getMemory:(FBRouteRequest *)request {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %lu", info.resident_size);
        return [[FBResponseJSONPayload alloc] initWithDictionary:@{
                                                                   @"memoryUsage" : [NSString stringWithFormat:@"Memory in use (in bytes): %lu", info.resident_size]
                                                                   }];
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        return [[FBResponseJSONPayload alloc] initWithDictionary:@{
                                                                   @"memoryUsage" : [NSString stringWithFormat:@"Error with task_info(): %s", mach_error_string(kerr)]
                                                                   }];
    }
}


+ (id<FBResponsePayload>)handleHomescreenCommand:(FBRouteRequest *)request
{
  NSError *error;
  if (![[XCUIDevice sharedDevice] fb_goToHomescreenWithError:&error]) {
    return FBResponseWithError(error);
  }
  return FBResponseWithOK();
}

+ (id<FBResponsePayload>)handleDeactivateAppCommand:(FBRouteRequest *)request
{
  NSNumber *requestedDuration = request.arguments[@"duration"];
  NSTimeInterval duration = (requestedDuration ? requestedDuration.doubleValue : 3.);
  NSError *error;
  if (![request.session.application fb_deactivateWithDuration:duration error:&error]) {
    return FBResponseWithError(error);
  }
  return FBResponseWithOK();
}

+ (id<FBResponsePayload>)handleTimeouts:(FBRouteRequest *)request
{
  // This method is intentionally not supported.
  return FBResponseWithOK();
}

#pragma mark - monkey method


+ (id<FBResponsePayload>)handleTapCommand:(FBRouteRequest *)request {
    
    [FBLogger log:@"monkey version 6.0"];
    FBSession *session = request.session;
    
    int32_t width = [request.parameters[@"width"] intValue];
    int32_t height = [request.parameters[@"height"] intValue];
    uint32_t x = arc4random_uniform(width);
    uint32_t y = arc4random_uniform(height);;
    
    NSString *strX = @(x).stringValue;
    NSString *strY = @(y).stringValue;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *tapCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:CGVectorMake(strX.floatValue, strY.floatValue)];
    [FBLogger logFmt:@"tap at (%f, %f)", strX.floatValue, strY.floatValue];
//    [tapCoordinate pressForDuration:0.1];
    [tapCoordinate doubleTap];

    return FBResponseWithOK();
}

+ (id<FBResponsePayload>)_swipe:(FBRouteRequest *)request
         fromX:(NSInteger)fromX fromY:(NSInteger)fromY
           toX:(NSInteger)toX toY:(NSInteger)toY {

    FBSession *session = request.session;

    CGVector startPoint = CGVectorMake((double)fromX, (double)fromY);
    CGVector endPoint = CGVectorMake(toX, toY);
    NSTimeInterval duration = 0.005;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *endCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:endPoint];
    XCUICoordinate *startCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:startPoint];
    [FBLogger logFmt:@"drag from (%@, %@) to (%@, %@)", @(fromX), @(fromY), @(toX), @(toY)];
    [startCoordinate pressForDuration:duration thenDragToCoordinate:endCoordinate];
    return FBResponseWithOK();
}

+ (id<FBResponsePayload>)_swipeLeft:(FBRouteRequest *)request {
    int32_t width = [request.parameters[@"width"] intValue];
    int32_t height = [request.parameters[@"height"] intValue];
    NSInteger fromX = width - 2;
    NSInteger fromY = height / 2;
    NSInteger toX =  0;
    NSInteger toY = height / 2;
    [self _swipe:request fromX:fromX fromY:fromY toX:toX toY:toY];
    return FBResponseWithOK();
}

+ (id<FBResponsePayload>)_swipeRight:(FBRouteRequest *)request {
    int32_t width = [request.parameters[@"width"] intValue];
    int32_t height = [request.parameters[@"height"] intValue];
    NSInteger fromX = 0;
    NSInteger fromY = height / 2;
    
    NSInteger toX = width - 2 ;
    NSInteger toY = height / 2;
    [self _swipe:request fromX:fromX fromY:fromY toX:toX toY:toY];
    return FBResponseWithOK();
}

+ (id<FBResponsePayload>)_drag:(FBRouteRequest *)request {
    int32_t width = [request.parameters[@"width"] intValue];
    int32_t height = [request.parameters[@"height"] intValue];
    FBSession *session = request.session;
    NSInteger fromX = arc4random_uniform(width);
    NSInteger fromY = arc4random_uniform(height);
    NSInteger toX = arc4random_uniform(width);
    NSInteger toY = arc4random_uniform(height);
    
    if (fromY < 20) fromY += 15;
    if (toY > height - 10 ) toY -=15;
//    if (fromX < 1) fromX += 5;
//    if (toX < 1) toX += 5;
    
    CGVector startPoint = CGVectorMake((double)fromX, (double)fromY);
    CGVector endPoint = CGVectorMake(toX, toY);
    NSTimeInterval duration = 0.005;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *endCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:endPoint];
    XCUICoordinate *startCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:startPoint];
    [FBLogger logFmt:@"drag from (%@, %@) to (%@, %@)", @(fromX), @(fromY), @(toX), @(toY)];
    [startCoordinate pressForDuration:duration thenDragToCoordinate:endCoordinate];
    return FBResponseWithOK();
}

+ (id<FBResponsePayload>)_orientation:(FBRouteRequest *)request {
    NSArray *oris = @[@"PORTRAIT", @"LANDSCAPE",
                      @"UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT", @"UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN"];
    NSInteger index = arc4random_uniform(4);
    [request setValue:@{@"orientation" : oris[index]} forKey:@"parameters"];
    if ([FBOrientationCommands handleSetOrientation: request]) {
        [FBLogger logFmt:@"%@ success", oris[index]];
    }else {
        [FBLogger log:@"oritentaion failed"];
    }
    return FBResponseWithOK();
}

@end
