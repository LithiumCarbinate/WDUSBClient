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
#import <objc/message.h>


NSString * const WDWindowWidthKey = @"WDWindowWidth";
NSString * const WDWindowHeightKey = @"WDWindowHeight";
NSString * const WDMonkeyRunningTimeKey = @"WDMonkeyRunningTime";
int32_t width;
int32_t height;
@interface FBCustomCommands ()


@end

@implementation FBCustomCommands

+ (NSArray *)routes
{
  return
  @[
    // for monkey
    [[FBRoute POST:@"/monkey"] respondWithTarget:self action:@selector(handleMonkey:)],
    [[FBRoute POST:@"/homescreen"].withoutSession respondWithTarget:self action:@selector(handleHomescreenCommand:)],
    [[FBRoute POST:@"/deactivateApp"] respondWithTarget:self action:@selector(handleDeactivateAppCommand:)],
    [[FBRoute POST:@"/timeouts"] respondWithTarget:self action:@selector(handleTimeouts:)],
  ];
}


#pragma mark - Commands

+ (id<FBResponsePayload>)handleMonkey:(FBRouteRequest *)request
{
    [FBLogger log:@"开始monkey测试"];
    
    width = [request.parameters[WDWindowWidthKey] intValue];
    height = [request.parameters[WDWindowHeightKey] intValue];
    
    [FBLogger logFmt:@"屏幕为%d * %d", width, height];
    NSArray *method = @[@"_tap", @"_drag", @"_orientation", @"_swipeRight"];
    
    NSInteger methodLen = method.count;
    NSInteger numberOfEventsPerMin = 60 * 100 / 110;
    NSInteger defaultMiniute = 5;
    NSInteger defaultNumberOfEvents = defaultMiniute * numberOfEventsPerMin;
    NSInteger numberofEvents = defaultNumberOfEvents;
    if ([request.parameters objectForKey: WDMonkeyRunningTimeKey]) {
        numberofEvents = [[request.parameters objectForKey: WDMonkeyRunningTimeKey] integerValue] * numberOfEventsPerMin;
    }
    
    for (NSInteger i = 0; i < numberofEvents; i++) {
        NSString *callM = method[ i % methodLen];
        if ([callM isEqualToString:@"_tap"]) [self _tap: request];
        if ([callM isEqualToString:@"_drag"]) [self _drag: request];
        if ([callM isEqualToString:@"_orientation"]) [self _orientation: request];
        if ([callM isEqualToString:@"_swipeRight"]) [self _swipeRight: request];
    }
    [FBLogger log:@"monkey测试结束"];
    return FBResponseWithOK();
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



+ (void)_tap:(FBRouteRequest *)request {
    
    FBSession *session = request.session;

    uint32_t x = arc4random_uniform(width);
    uint32_t y = arc4random_uniform(height);;
    
    NSString *strX = @(x).stringValue;
    NSString *strY = @(y).stringValue;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *tapCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:CGVectorMake(strX.floatValue, strY.floatValue)];
    [FBLogger logFmt:@"tap at (%f, %f)", strX.floatValue, strY.floatValue];
    [tapCoordinate tap];
}

+ (void)_swipeRight:(FBRouteRequest *)request {
    
    FBSession *session = request.session;
    NSInteger fromX = 0;//arc4random_uniform(width);
    NSInteger fromY = height / 2;
    
    NSInteger toX = width - 2 ;
    NSInteger toY = height / 2;
    
    CGVector startPoint = CGVectorMake((double)fromX, (double)fromY);
    CGVector endPoint = CGVectorMake(toX, toY);
    NSTimeInterval duration = 0.18;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *endCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:endPoint];
    XCUICoordinate *startCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:startPoint];
    [FBLogger logFmt:@"drag from (%@, %@) to (%@, %@)", @(fromX), @(fromY), @(toX), @(toY)];
    [startCoordinate pressForDuration:duration thenDragToCoordinate:endCoordinate];
    
}

+ (void)_drag:(FBRouteRequest *)request {
    
    FBSession *session = request.session;
    NSInteger fromX = arc4random_uniform(width);
    NSInteger fromY = arc4random_uniform(height);

    
    NSInteger toX = arc4random_uniform(width);
    NSInteger toY = arc4random_uniform(height);
    
    if (fromY < 20) fromY += 5;
    if (toY < 20 ) toY +=5;
    if (fromY < 1) fromY += 5;
    if (toY < 1) toY += 5;
    
    CGVector startPoint = CGVectorMake((double)fromX, (double)fromY);
    CGVector endPoint = CGVectorMake(toX, toY);
    NSTimeInterval duration = 0.18;
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:session.application normalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *endCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:endPoint];
    XCUICoordinate *startCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:startPoint];
    [FBLogger logFmt:@"drag from (%@, %@) to (%@, %@)", @(fromX), @(fromY), @(toX), @(toY)];
    [startCoordinate pressForDuration:duration thenDragToCoordinate:endCoordinate];
}

+ (void)_orientation:(FBRouteRequest *)request {
    NSArray *oris = @[@"PORTRAIT", @"LANDSCAPE",
                      @"UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT", @"UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN"];
    NSInteger index = arc4random_uniform(4);
    [request setValue:@{@"orientation" : oris[index]} forKey:@"parameters"];
    if ([FBOrientationCommands handleSetOrientation: request]) {
        [FBLogger logFmt:@"%@ success", oris[index]];
    }else {
        [FBLogger log:@"oritentaion failed"];
    }
}

@end
