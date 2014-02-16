//
//  KKSignUpViewControllerTests.m
//  Bar Golf Tests
//
//  Created by Kerry Knight on 2/10/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKImportHelper.h"
#import "KKSignUpViewModel.h"
#import "KKSignUpViewController.h"

@interface KKSignUpViewController (TestExtensions)
@property (strong, nonatomic, readwrite) KKSignUpViewModel *viewModel;
- (RACDisposable *)signUp;
@end

@interface KKSignUpViewControllerTests : XCTestCase
@property (strong, nonatomic) KKSignUpViewController *sut;
@end

@implementation KKSignUpViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sut = [[KKSignUpViewController alloc] init];
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
- (void)test_signUpButton_shouldBeConnected {
    XCTAssertTrue(self.sut.signUpButton != nil, @"Sign up button should have an outlet.");
}

- (void)test_cancelButton_shouldBeConnected {
    XCTAssertTrue(self.sut.cancelButton != nil, @"Cancel password button should have an outlet.");
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

- (void)test_confirmPasswordBG_shouldBeConnected {
    XCTAssertTrue(self.sut.confirmPasswordBG != nil, @"ConfirmPasswordBG view should have an outlet.");
}

- (void)test_displayNameBG_shouldBeConnected {
    XCTAssertTrue(self.sut.displayNameBG != nil, @"DisplayNameBG view should have an outlet.");
}

- (void)test_signUpButtonBG_shouldBeConnected {
    XCTAssertTrue(self.sut.signUpButtonBG != nil, @"SignUpButtonBG view should have an outlet.");
}



#pragma mark - RACCommands added
- (void)test_signUpButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.signUpButton.rac_command != nil, @"Sign Up button should have a rac_command.");
}

- (void)test_cancelButtonRACCommand_shouldNotBeNil {
    XCTAssertTrue(self.sut.cancelButton.rac_command != nil, @"Cancel button should have a rac_command.");
}

- (void)test_signUpButton_shouldBeDisabledIfEmailAddressFieldIncomplete {
    self.sut.viewModel.username = @"";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if email address is blank");
    
    self.sut.viewModel.username = @"woozykk@";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if email address is incomplete");
}

- (void)test_signUpButton_shouldBeDisabledIfPasswordFieldIncomplete {
    self.sut.viewModel.password = @"";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if password is blank");
    
    self.sut.viewModel.password = @"password";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if password is not valid");
}

- (void)test_signUpButton_shouldBeDisabledIfConfirmPasswordFieldIncomplete {
    self.sut.viewModel.confirmPassword = @"";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if confirm password is blank");
    
    self.sut.viewModel.confirmPassword = @"password";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if confirm password is not valid");
}

- (void)test_signUpButton_shouldBeDisabledDisplayNameFieldBlank {
    self.sut.viewModel.displayName = @"";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == NO, @"Sign Up button should be disabled if display name field blank");
}

- (void)test_loginButton_shouldBeEnabledIfEmailAddressFieldCompleteAndPasswordIsValidAndConfirmPasswordMatchesPasswordAndDisplayNameNotEmpty {
    self.sut.viewModel.username = @"woozykk@hotmail.com";
    self.sut.viewModel.password = @"password1";
    self.sut.viewModel.confirmPassword = self.sut.viewModel.password;
    self.sut.viewModel.displayName = @"K";
    XCTAssertTrue(self.sut.signUpButton.userInteractionEnabled == YES, @"Sign Up button should be enable if email address is complete, password is valid, confirm password matches and display name has length");
}

#pragma mark - Methods Return Signals
- (void)test_signUpMethod_shouldReturnRACDisposable {
    XCTAssertTrue([[self.sut signUp] isKindOfClass:[RACDisposable class]], @"-signUp method should return a RACDisposable");
}

#pragma mark - Signals are Signals
- (void)test_usernameAndPasswordCombinedSignal_shouldBeRACSignal {
    RACSignal *signal = self.sut.viewModel.allFieldsCombinedSignal;
    XCTAssertNotNil(signal, @"All fields combined signal should be an object");
    XCTAssertTrue([[signal class] isSubclassOfClass:[RACSignal class]], @"All fields combined signal should be a RACSignal.");
}

#pragma mark - View Model Initialization
- (void)test_viewModel_shouldBeActive {
    XCTAssertTrue(self.sut.viewModel.active == YES, @"View model should be active.");
}

@end



