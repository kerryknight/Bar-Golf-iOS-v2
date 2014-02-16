//
//  KKForgotPasswordViewControllerTests.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/16/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKImportHelper.h"
#import "KKForgotPasswordViewController.h"
#import "KKForgotPasswordViewModel.h"
#import "KKSignUpViewController.h"
#import "KKForgotPasswordViewController.h"

@interface KKForgotPasswordViewController (TestExtensions)
@property (strong, nonatomic, readwrite) KKForgotPasswordViewModel *viewModel;
- (RACDisposable *)sendResetLink;
@end

@interface KKForgotPasswordViewControllerTests : XCTestCase
@property (strong, nonatomic) KKForgotPasswordViewController *sut;
@end

@implementation KKForgotPasswordViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sut = [[KKForgotPasswordViewController alloc] init];
    //this forces iOS to load the nib, even though we’re not displaying anything
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidAppear:) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.sut = nil;
}

#pragma mark - IBOutlets connected
- (void)test_sendResetLinkButton_shouldBeConnected {
    XCTAssertTrue(self.sut.sendResetLinkButton != nil, @"Send reset link button should have an outlet.");
}

- (void)test_cancelButton_shouldBeConnected {
    XCTAssertTrue(self.sut.cancelButton != nil, @"Cancel button should have an outlet.");
}

- (void)test_containerView_shouldBeConnected {
    XCTAssertTrue(self.sut.container != nil, @"Container view should have an outlet.");
}

- (void)test_emailAddressBG_shouldBeConnected {
    XCTAssertTrue(self.sut.emailAddressBG != nil, @"EmailAddressBG view should have an outlet.");
}

#pragma mark - RACCommands added
- (void)test_sendResetLinkButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.sendResetLinkButton.rac_command != nil, @"Send reset link button should have a rac_command.");
}

- (void)test_cancelButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.cancelButton.rac_command != nil, @"Cancel button should have a rac_command.");
}

- (void)test_sendResetLinkButton_shouldBeDisabledIfEmailAddressFieldIncomplete {
    self.sut.viewModel.email = @"";
    XCTAssertTrue(self.sut.sendResetLinkButton.userInteractionEnabled == NO, @"Send reset link button should be disabled if email address is blank");
    
    self.sut.viewModel.email = @"woozykk@";
    XCTAssertTrue(self.sut.sendResetLinkButton.userInteractionEnabled == NO, @"Send reset link button should be disabled if email address is incomplete");
}

- (void)test_sendResetLinkButton_shouldBeEnabledIfEmailAddressFieldComplete {
    self.sut.viewModel.email = @"woozykk@hotmail.com";
    XCTAssertTrue(self.sut.sendResetLinkButton.userInteractionEnabled == YES, @"Send reset link button should be enable if email address is complete and password has length");
}

#pragma mark - Methods Return Signals
- (void)test_sendResetPasswordLinkMethod_shouldReturnRACDisposable {
    XCTAssertTrue([[self.sut sendResetLink] isKindOfClass:[RACDisposable class]], @"-sendResetLink method should return a RACDisposable");
}

#pragma mark - Signals are Signals
- (void)test_emailIsValidEmailSignal_shouldBeRACSignal {
    RACSignal *signal = self.sut.viewModel.emailIsValidEmailSignal;
    XCTAssertNotNil(signal, @"Valid email signal should be an object");
    XCTAssertTrue([[signal class] isSubclassOfClass:[RACSignal class]], @"Valid email signal should be a RACSignal.");
}

#pragma mark - View Model Initialization
- (void)test_viewModel_shouldBeActive {
    XCTAssertTrue(self.sut.viewModel.active == YES, @"View model should be active.");
}

@end
