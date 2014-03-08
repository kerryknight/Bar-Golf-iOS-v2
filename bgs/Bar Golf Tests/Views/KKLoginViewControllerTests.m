//
//  KKLoginViewControllerTests.m
//  Bar Golf Tests
//
//  Created by Kerry Knight on 2/10/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKImportHelper.h"
#import "KKLoginViewController.h"
#import "KKLoginViewModel.h"
#import "KKSignUpViewController.h"
#import "KKForgotPasswordViewController.h"

@interface KKLoginViewController (TestExtensions)
@property (strong, nonatomic, readwrite) KKLoginViewModel *viewModel;
- (RACDisposable *)logIn;
@end

@interface KKLoginViewControllerTests : XCTestCase
@property (strong, nonatomic) KKLoginViewController *sut;
@end

@implementation KKLoginViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sut = [[KKLoginViewController alloc] init];
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
- (void)test_loginButton_shouldBeConnected {
    XCTAssertTrue(self.sut.loginButton != nil, @"Log In button should have an outlet.");
}

- (void)test_forgotPasswordButton_shouldBeConnected {
    XCTAssertTrue(self.sut.forgotPasswordButton != nil, @"Forgot password button should have an outlet.");
}

- (void)test_signUpButton_shouldBeConnected {
    XCTAssertTrue(self.sut.signUpButton != nil, @"Sign up button should have an outlet.");
}

- (void)test_facebookButton_shouldBeConnected {
    XCTAssertTrue(self.sut.facebookButton != nil, @"Facebook button should have an outlet.");
}

- (void)test_containerView_shouldBeConnected {
    XCTAssertTrue(self.sut.container != nil, @"Container view should have an outlet.");
}

- (void)test_usernameBG_shouldBeConnected {
    XCTAssertTrue(self.sut.usernameBG != nil, @"UsernameBG view should have an outlet.");
}

- (void)test_passwordBG_shouldBeConnected {
    XCTAssertTrue(self.sut.passwordBG != nil, @"PasswordBG view should have an outlet.");
}

- (void)test_loginButtonBG_shouldBeConnected {
    XCTAssertTrue(self.sut.loginButtonBG != nil, @"LoginButtonBG view should have an outlet.");
}

#pragma mark - RACCommands added
- (void)test_forgotPasswordButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.forgotPasswordButton.rac_command != nil, @"Forgot password button should have a rac_command.");
}

- (void)test_signUpButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.signUpButton.rac_command != nil, @"Sign Up button should have a rac_command.");
}

- (void)test_facebookButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.facebookButton.rac_command != nil, @"Facebook button should have a rac_command.");
}

- (void)test_logInButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.loginButton.rac_command != nil, @"Log In button should have a rac_command.");
}

- (void)test_loginButton_shouldBeDisabledIfEmailAddressFieldIncomplete {
    self.sut.viewModel.username = @"";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == NO, @"Log In button should be disabled if email address is blank");
    
    self.sut.viewModel.username = @"woozykk@";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == NO, @"Log In button should be disabled if email address is incomplete");
}

- (void)test_loginButton_shouldBeDisabledIfPasswordFieldIncomplete {
    self.sut.viewModel.password = @"";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == NO, @"Log In button should be disabled if password is blank");
    
    self.sut.viewModel.password = @"password";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == NO, @"Log In button should be disabled if password is not valid");
}

- (void)test_loginButton_shouldBeDisabledIfEmailAddressFieldCompleteButPasswordBlank {
    self.sut.viewModel.username = @"woozykk@hotmail.com";
    self.sut.viewModel.password = @"";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == NO, @"Log In button should be disabled if email address is complete but password blank");
}

- (void)test_loginButton_shouldBeEnabledIfEmailAddressFieldCompleteAndPasswordHasLength {
    self.sut.viewModel.username = @"woozykk@hotmail.com";
    self.sut.viewModel.password = @"p";
    XCTAssertTrue(self.sut.loginButton.userInteractionEnabled == YES, @"Log In button should be enable if email address is complete and password has length");
}

#pragma mark - Methods Return Signals
- (void)test_logInMethod_shouldReturnRACDisposable {
    XCTAssertTrue([[self.sut logIn] isKindOfClass:[RACDisposable class]], @"-logIn method should return a RACDisposable");
}

#pragma mark - Signals are Signals
- (void)test_usernameAndPasswordCombinedSignal_shouldBeRACSignal {
    RACSignal *signal = self.sut.viewModel.usernameAndPasswordCombinedSignal;
    XCTAssertNotNil(signal, @"Username and password combined signal should be an object");
    XCTAssertTrue([[signal class] isSubclassOfClass:[RACSignal class]], @"Username and password combined signal should be a RACSignal.");
}

#pragma mark - View Model Initialization
- (void)test_viewModel_shouldBeActive {
    XCTAssertTrue(self.sut.viewModel.active == YES, @"View model should be active.");
}

@end



