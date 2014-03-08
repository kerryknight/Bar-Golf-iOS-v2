//
//  KKForgotPasswordViewModelTests.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/16/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKImportHelper.h"
#import "KKForgotPasswordViewController.h"
#import "KKForgotPasswordViewModel.h"


@interface KKForgotPasswordViewModelTests : XCTestCase
@property (strong, nonatomic) KKForgotPasswordViewModel *sut;
@property (strong, nonatomic) TRVSMonitor *monitor;
@end

@implementation KKForgotPasswordViewModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.sut = [[KKForgotPasswordViewModel alloc] init];
    self.monitor = [TRVSMonitor monitor];
    [PFUser logOut];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.sut = nil;
    self.monitor = nil;
}

#pragma mark - Methods Return Signals
- (void)test_rac_sendResetPasswordLink_shouldReturnErrorIfIncompleteLoginInfo {
    self.sut.email = @"";
    
    [[self.sut rac_sendResetPasswordLink] subscribeError:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_sendResetPasswordLink method should return error for blank forgot password info");
    }];
    
    self.sut.email = @"woozykk@hotmail";
    
    [[self.sut rac_sendResetPasswordLink] subscribeNext:^(id x) {
        XCTAssertTrue(FALSE, @"-rac_sendResetPasswordLink method should return error for incomplete forgot password info");
    } error:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_sendResetPasswordLink method should return error for incomplete forgot password info");
    }];
}

- (void)test_rac_sendResetPasswordLink_shouldReturnTestUserAccountInfoIfCompleteLoginInfo {
    self.sut.email = @"woozykk@hotmail.com";
    
    [[self.sut rac_sendResetPasswordLink] subscribeError:^(NSError *error) {
        XCTAssertTrue(FALSE, @"-rac_sendResetPasswordLink method should return complete on successful email send");
        [self.monitor signal];
    } completed:^{
        XCTAssertTrue(TRUE, @"-rac_sendResetPasswordLink method should return complete on successful email send");
        [self.monitor signal];
    }];
    
    [self.monitor wait];
}

@end
