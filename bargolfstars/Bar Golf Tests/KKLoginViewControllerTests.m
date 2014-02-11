//
//  Bar_Golf_Tests.m
//  Bar Golf Tests
//
//  Created by Kerry Knight on 2/10/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "XCTAsyncTestCase.h"

@interface KKLoginViewControllerTests : XCTAsyncTestCase

@end

@implementation KKLoginViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBlockSample {
    [self prepare];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        sleep(1.0);
        [self notify:kXCTUnitWaitStatusSuccess];
    });
    // Will wait for 2 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:2.0];
}

@end