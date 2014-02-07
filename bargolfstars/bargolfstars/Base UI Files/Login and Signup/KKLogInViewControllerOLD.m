//
//  KKLogInViewController.m
//  Kollections
//
//  Created by Kerry Knight on 12/10/12.
//  Copyright (c) 2012 Kerry Knight. All rights reserved.
//

#import "KKLogInViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface KKLogInViewController () {
    
}

@property (strong, nonatomic) UIView *usernameBG;
@property (strong, nonatomic) UIView *passwordBG;
@property (strong, nonatomic) JVFloatLabeledTextField *usernameFloatTextField;
@property (strong, nonatomic) JVFloatLabeledTextField *passwordFloatTextField;
@property (strong, nonatomic) UILabel *loginButtonLabel;
@property (strong, nonatomic) UILabel *signUpButtonLabel;
@property (strong, nonatomic) UILabel *otherLoginsLabel;
@property (strong, nonatomic) UILabel *veteranLabel;
@property (strong, nonatomic) UILabel *signupLabel;
@property (strong, nonatomic) UIImageView *fbLogoImageView;

@end

@implementation KKLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [PFLogInViewController class];
    
//    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kkMainBG.png"]]];
//    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kkTitleBarLogo.png"]]];
    
    [self configureUI];
    [self rac_addSubscribers];
}

#pragma mark - RAC Stuff
- (void)rac_addSubscribers {
    RAC(self.logInView.usernameField, text) = RACObserve(self.usernameFloatTextField, text);
    RAC(self.logInView.passwordField, text) = RACObserve(self.passwordFloatTextField, text);
    
    [RACObserve(self.usernameFloatTextField, text) subscribeNext:^(id x) {
        DLogYellow(@"x: %@", x);
    }];
    
    [RACObserve(self.passwordFloatTextField, text) subscribeNext:^(id x) {
        DLogYellow(@"x: %@", x);
    }];
}

#pragma mark - Private Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissAnyKeyboard];
    [super touchesBegan:touches withEvent:event];
}

- (void) dismissAnyKeyboard {
	NSArray *subviews = [self.view subviews];
	for (UIView *aview in subviews) {
		if ([aview isKindOfClass: [UITextField class]]) {
			UITextField *textField = (UITextField *)aview;
			if ([textField isEditing]) {
                
				[textField resignFirstResponder];
			}
		}
	}
}

#pragma mark - UI Configuration
- (void)configureUI {
    // ********** LOGIN SECTION ********************** //
    UIColor *gray = [kMedWhite colorWithAlphaComponent:0.5];
    [[JVFloatLabeledTextField appearance] setFloatingLabelActiveTextColor:kLtGreen];
    [[JVFloatLabeledTextField appearance] setFloatingLabelTextColor:gray];
    [[JVFloatLabeledTextField appearance] setFloatingLabelFont:[UIFont fontWithName:kHelveticaLight size:12.0f]];
    [[JVFloatLabeledTextField appearance] setFloatingLabelYPadding:@(0)];
    [[JVFloatLabeledTextField appearance] setFont:[UIFont fontWithName:kHelveticaLight size:20.0f]];
    [[JVFloatLabeledTextField appearance] setTextColor:kMedWhite];
    
    //full view as dark gray
    self.view.backgroundColor = kDrkGray;
    
    NSInteger startingY = IS_IPHONE_TALL ? 60 : 30;
    
    self.veteranLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, startingY, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.veteranLabel.font = [UIFont fontWithName:kHelveticaLight size:16.0f];
    self.veteranLabel.textAlignment = NSTextAlignmentCenter;
    self.veteranLabel.backgroundColor = [UIColor clearColor];
    self.veteranLabel.textColor = gray;
    self.veteranLabel.text = NSLocalizedString(@"Veteran bar golfer login:", nil);
    [self.logInView addSubview:self.veteranLabel];
    
    
    //username text field background
    self.usernameBG = [[UIView alloc] initWithFrame:CGRectMake(25, self.veteranLabel.frame.origin.y + 38, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.usernameBG.backgroundColor = kLtGray;
    [self.logInView addSubview:self.usernameBG];
    
    //add the username textfield
    self.usernameFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.usernameBG.frame.origin.y,
                                              self.view.frame.size.width - 2 * kWelcomeTextFieldMargin,
                                              self.usernameBG.frame.size.height)];
    self.usernameFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameFloatTextField.delegate = self;
    self.usernameFloatTextField.floatingLabel.text = NSLocalizedString(@"Email Address", nil);
    [self.usernameFloatTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.usernameFloatTextField.returnKeyType = UIReturnKeyGo;
    self.usernameFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.usernameFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.usernameFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.logInView addSubview:self.usernameFloatTextField];
    
    //password text field background
    self.passwordBG = [[UIView alloc] initWithFrame:CGRectMake(25, self.usernameBG.frame.origin.y + 60, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.passwordBG.backgroundColor = kLtGray;
    [self.logInView addSubview:self.passwordBG];
    
    //add the password textfield
    self.passwordFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.passwordBG.frame.origin.y,
                                              self.view.frame.size.width - 2 * kWelcomeTextFieldMargin,
                                              self.passwordBG.frame.size.height)];
    self.passwordFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordFloatTextField.delegate = self;
    self.passwordFloatTextField.returnKeyType = UIReturnKeyGo;
    self.passwordFloatTextField.secureTextEntry = YES;
    self.passwordFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordFloatTextField.floatingLabel.text = NSLocalizedString(@"Password", nil);
    
    //set our placeholder text color
    if ([self.passwordFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.passwordFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.logInView addSubview:self.passwordFloatTextField];
    
    //configure login button
    [self.logInView.logInButton setBackgroundImage:[KKUtility imageFromColor:kMedWhite] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[KKUtility imageFromColor:[kMedWhite colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitleColor:kDrkGray forState:UIControlStateNormal];
    [self.logInView.logInButton setTitleShadowColor:nil forState:UIControlStateNormal];
    self.logInView.logInButton.titleLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    self.logInView.logInButton.titleLabel.textColor = kDrkGray;
    //hide the fucking button title cuz the fucker won't format easily for me
    CALayer *layer = self.logInView.logInButton.titleLabel.layer;
    layer.opacity = 0;
    //create a label for the button's title instead of attempting to set the button's title directly as
    //it was being a little bitch trying to format it's color and remove dropshadow
    self.loginButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.passwordBG.frame.origin.y + 60, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.loginButtonLabel.text = NSLocalizedString(@"Log in", nil);
    self.loginButtonLabel.textColor = kMedGray;
    self.loginButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.loginButtonLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0f];
    [self.logInView addSubview:self.loginButtonLabel];
    
    // Set password buttons appearance
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateNormal];//fake; so it's invisible
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateHighlighted];//fake; so it's invisible
    [self.logInView.passwordForgottenButton setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateHighlighted];
    self.logInView.passwordForgottenButton.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:14.0f];
    [self.logInView sendSubviewToBack:self.logInView.passwordForgottenButton];
    
    // ********** LOGIN SECTION ********************** //
    
    // ********** SIGN UP BUTTON SECTION ********************** //
    //add the "Don't have an account yet?" label
    self.signupLabel = [[UILabel alloc] initWithFrame:self.loginButtonLabel.frame];
    self.signupLabel.center = CGPointMake(self.signupLabel.center.x, self.signupLabel.center.y + 80);
    self.signupLabel.font = [UIFont fontWithName:kHelveticaLight size:16.0f];
    self.signupLabel.textAlignment = NSTextAlignmentCenter;
    self.signupLabel.backgroundColor = [UIColor clearColor];
    self.signupLabel.textColor = gray;
    self.signupLabel.text = NSLocalizedString(@"Don't have an account yet, rookie?", nil);
    [self.logInView addSubview:self.signupLabel];
    
    // configure sign up button
    [self.logInView.signUpButton setBackgroundImage:[KKUtility imageFromColor:kLtGreen] forState:UIControlStateNormal];//fake; so it's invisible
    [self.logInView.signUpButton setBackgroundImage:[KKUtility imageFromColor:kLtGreen] forState:UIControlStateHighlighted];//fake; so it's invisible
    [self.logInView.signUpButton setTitleColor:kDrkGray forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleShadowColor:nil forState:UIControlStateNormal];
    self.logInView.signUpButton.titleLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    self.logInView.signUpButton.titleLabel.textColor = kDrkGray;
    //hide the fucking button title cuz the fucker won't format easily for me
    layer = self.logInView.signUpButton.titleLabel.layer;
    layer.opacity = 0;
    //create a label for the button's title instead of attempting to set the button's title directly as
    //it was being a little bitch trying to format it's color and remove dropshadow
    self.signUpButtonLabel = [[UILabel alloc] initWithFrame:self.loginButtonLabel.frame];
    self.signUpButtonLabel.center = CGPointMake(self.signUpButtonLabel.center.x, self.signUpButtonLabel.center.y + 118);
    self.signUpButtonLabel.text = NSLocalizedString(@"Sign Up", nil);
    self.signUpButtonLabel.textColor = kLtWhite;
    self.signUpButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.signUpButtonLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0f];
    [self.logInView addSubview:self.signUpButtonLabel];
    // ********** SIGN UP BUTTON SECTION ********************** //
    
    // ********** FACEBOOK BUTTON SECTION ********************** //
    //was having trouble modifying pre-defined small labels so creating my own here
    self.otherLoginsLabel = [[UILabel alloc] initWithFrame:self.signupLabel.frame];
    self.otherLoginsLabel.center = CGPointMake(self.otherLoginsLabel.center.x, self.otherLoginsLabel.center.y + 90);
    self.otherLoginsLabel.font = [UIFont fontWithName:kHelveticaLight size:16.0f];
    self.otherLoginsLabel.textAlignment = NSTextAlignmentCenter;
    self.otherLoginsLabel.backgroundColor = [UIColor clearColor];
    self.otherLoginsLabel.textColor = gray;
    self.otherLoginsLabel.text = NSLocalizedString(@"You can also sign in with:", nil);
    [self.logInView addSubview:self.otherLoginsLabel];
    
    // configure facebook button
    [self.logInView.facebookButton setBackgroundImage:[KKUtility imageFromColor:kFBBlue] forState:UIControlStateNormal];//fake; so it's invisible
    [self.logInView.facebookButton setBackgroundImage:[KKUtility imageFromColor:kFBBlue] forState:UIControlStateHighlighted];//fake; so it's invisible
    [self.logInView.facebookButton setTitleColor:kDrkGray forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitleShadowColor:nil forState:UIControlStateNormal];
    self.logInView.facebookButton.titleLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    self.logInView.facebookButton.titleLabel.textColor = kDrkGray;
    //hide the fucking button title cuz the fucker won't format easily for me
    layer = self.logInView.facebookButton.titleLabel.layer;
    layer.opacity = 0;
    
    self.fbLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fbLogo"]];
    self.fbLogoImageView.frame= CGRectMake(92, self.otherLoginsLabel.frame.origin.y + 40, 136, 46);
    [self.logInView addSubview:self.fbLogoImageView];
    // ********** FACEBOOK BUTTON SECTION ********************** //
    
    //hide the parse provided fields as we'll simply make their values equal to our floating label text fields with RAC
    self.logInView.usernameField.alpha = 0.0;
    self.logInView.passwordField.alpha = 0.0;
    
    //hide pre-defined labels
    self.logInView.externalLogInLabel.hidden = YES;
    [self.logInView.logo setHidden:YES];
    [self.logInView.facebookButton.titleLabel setHidden:YES];
    self.logInView.signUpLabel.hidden = YES;
    
    CALayer *forgotLayer = self.logInView.passwordForgottenButton.titleLabel.layer;
    forgotLayer.shadowRadius = 0.4;
    forgotLayer.shadowOffset = CGSizeMake(0, -1);
    forgotLayer.shadowOpacity = 0.6f;
    
    // Remove text shadows
    layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    self.logInView.logInButton.frame = self.loginButtonLabel.frame;
    self.logInView.signUpButton.frame = self.signUpButtonLabel.frame;
    self.logInView.facebookButton.frame = CGRectMake(self.signUpButtonLabel.frame.origin.x,
                                                     self.fbLogoImageView.frame.origin.y - 2,
                                                     self.signUpButtonLabel.frame.size.width,
                                                     self.signUpButtonLabel.frame.size.height);
    
    //position forgot password button just below Log in button
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(self.logInView.logInButton.frame.origin.x + self.logInView.logInButton.frame.size.width - 115.0f,
                                                                self.logInView.logInButton.frame.origin.y + self.logInView.logInButton.frame.size.height + 5,
                                                                120.0f,
                                                                20.0f)];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    DLogYellow(@"");
    
    [textField resignFirstResponder];
    
    if (self.usernameFloatTextField.text.length > 0 && self.passwordFloatTextField.text.length > 6) {
        DLogGreen(@"");
        [PFUser logInWithUsername:self.usernameFloatTextField.text password:self.passwordFloatTextField.text];
    }
    
    return YES;
}

#pragma mark - Autorotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
