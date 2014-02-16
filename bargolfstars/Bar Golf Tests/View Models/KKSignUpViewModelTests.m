//
//  KKSignUpViewModelTests.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/16/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKImportHelper.h"
#import "KKSignUpViewController.h"
#import "KKSignUpViewModel.h"


@interface KKSignUpViewModelTests : XCTestCase
@property (strong, nonatomic) KKSignUpViewModel *sut;
@property (strong, nonatomic) TRVSMonitor *monitor;
@end

@implementation KKSignUpViewModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.sut = [[KKSignUpViewModel alloc] init];
    self.monitor = [TRVSMonitor monitor];
    [PFUser logOut];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.sut = nil;
    self.monitor = nil;
}

#pragma mark - Helpers
- (RACSignal *)rac_deleteTestUserFromParse {
    return [[PFCloud rac_callFunction:kKKCloudCodeDeleteUserKey withParameters:@{}] deliverOn:[RACScheduler immediateScheduler]];
}

- (void)deleteDummyTestUser {
    if ([PFUser currentUser]) {
        DLogRed(@"delete the user now");
        [[self rac_deleteTestUserFromParse] subscribeNext:^(id x) {
            DLogGreen(@"delete success");
        } error:^(NSError *error) {
            DLogRed(@"delete error: %@", error.description);
        } completed:^{
            DLogGreen(@"delete success");
        }];
    }
}

#pragma mark - Methods Return Signals
- (void)test_rac_logIn_shouldReturnErrorIfIncompleteSignUpInfo {
    self.sut.username = @"";
    self.sut.password = @"";
    self.sut.confirmPassword = @"";
    self.sut.displayName = @"";
    
    [[self.sut rac_signUpNewUser] subscribeError:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_signUpNewUser method should return error for blank login info");
    }];
    
    self.sut.username = @"username";
    self.sut.password = @"pass";
    self.sut.confirmPassword = @"pass";
    self.sut.displayName = @"";
    
    [[self.sut rac_signUpNewUser] subscribeNext:^(id x) {
        XCTAssertTrue(FALSE, @"-rac_signUpNewUser method should return error for incomplete login info");
    } error:^(NSError *error) {
        XCTAssertTrue(TRUE, @"-rac_signUpNewUser method should return error for incomplete login info");
    }];
}

- (void)test_rac_logIn_shouldReturnTestUserAccountInfoIfSuccessfulSignUp {
    self.sut.username = @"kerry@bargolfstars.com";
    self.sut.password = @"testuser1";
    self.sut.confirmPassword = @"testuser1";

    [[self.sut rac_signUpNewUser] subscribeError:^(NSError *error) {
        DLogRed(@"error: %@", error.description);
        XCTAssertTrue(FALSE, @"-rac_signUpNewUser method should return correct user info for signed up user");
        [self.monitor signal];
    } completed:^{
        XCTAssertTrue([[PFUser currentUser][@"username"] isEqualToString:self.sut.username], @"-rac_signUpNewUser method should return correct user info for signed up user");
        [self deleteDummyTestUser];
        [self.monitor signal];
    }];
    
    [self.monitor wait];
}

@end
