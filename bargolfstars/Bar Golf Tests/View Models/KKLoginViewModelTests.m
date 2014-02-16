//
//  KKLoginViewModelTests.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/11/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKImportHelper.h"
#import "KKLoginViewController.h"
#import "KKLoginViewModel.h"


@interface KKLoginViewModelTests : XCTestCase
@property (strong, nonatomic) KKLoginViewModel *sut;
@property (strong, nonatomic) TRVSMonitor *monitor;
@end

@implementation KKLoginViewModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.sut = [[KKLoginViewModel alloc] init];
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
- (void)test_rac_logIn_shouldReturnErrorIfIncompleteLoginInfo {
    self.sut.username = @"";
    self.sut.password = @"";
    
    [[self.sut rac_logIn] subscribeError:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_logIn method should return error for blank login info");
    }];
    
    self.sut.username = @"username";
    self.sut.password = @"pass";
    
    [[self.sut rac_logIn] subscribeNext:^(id x) {
        XCTAssertTrue(FALSE, @"-rac_logIn method should return error for incomplete login info");
    } error:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_logIn method should return error for incomplete login info");
    }];
}

- (void)test_rac_logIn_shouldReturnTestUserAccountInfoIfCompleteLoginInfo {
    self.sut.username = @"test@testuser.com";
    self.sut.password = @"testuser";
    
    [[self.sut rac_logIn] subscribeNext:^(PFUser *user) {
        XCTAssertTrue([user[@"username"] isEqualToString:self.sut.username], @"-rac_logIn method should return correct user info for logged in user");
        [self.monitor signal];
    } error:^(NSError *error) {
        XCTAssertTrue(FALSE, @"-rac_logIn method should return correct user info for logged in user");
        [self.monitor signal];
    } completed:^{
        //no op
    }];
    
    [self.monitor wait];
}

//- (void)test_rac_logInWithFacebook_shouldLogUserInWithFacebookSDK {
//    XCTAssertTrue(FALSE, @"-rac_logInWithFacebook should log the user in with Facebook");
//}

@end
