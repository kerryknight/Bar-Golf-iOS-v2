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

@property (nonatomic, strong) UILabel *otherLoginsLabel;
@property (nonatomic, strong) UILabel *signupLabel;

@end

@implementation KKLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFLogInViewController class];
    
//    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kkMainBG.png"]]];
//    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kkTitleBarLogo.png"]]];
    
    
//    self.loginViewController = [[PFLogInViewController alloc] init];
//    [self.loginViewController setDelegate:self];
//    [self.loginViewController setFields:PFLogInFieldsFacebook];
//    [self.loginViewController setFacebookPermissions:[NSArray arrayWithObjects:@"user_about_me", nil]];
//    [self presentViewController:self.loginViewController animated:NO completion:NULL];
    
    
    UIColor *gray = [kMedWhite colorWithAlphaComponent:0.5];
    [[JVFloatLabeledTextField appearance] setFloatingLabelActiveTextColor:kLtGreen];
    [[JVFloatLabeledTextField appearance] setFloatingLabelTextColor:gray];
    [[JVFloatLabeledTextField appearance] setFloatingLabelFont:[UIFont fontWithName:kHelveticaLight size:12.0f]];
    [[JVFloatLabeledTextField appearance] setFloatingLabelYPadding:@(0)];
    [[JVFloatLabeledTextField appearance] setFont:[UIFont fontWithName:kHelveticaLight size:20.0f]];
    [[JVFloatLabeledTextField appearance] setTextColor:kMedWhite];
    
    //full view as dark gray
    self.view.backgroundColor = kDrkGray;
    
    //username text field background
    self.usernameBG = [[UIView alloc] initWithFrame:CGRectMake(25, 90, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.usernameBG.backgroundColor = kLtGray;
    [self.view addSubview:self.usernameBG];
    
    //add the username textfield
    self.usernameFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kWelcomeTextFieldMargin,
                                                      self.usernameBG.frame.origin.y,
                                                      self.view.frame.size.width - 2 * kWelcomeTextFieldMargin,
                                                      self.usernameBG.frame.size.height)];
    self.usernameFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameFloatTextField.floatingLabel.text = NSLocalizedString(@"Username", nil);
    
    //set our placeholder text color
    if ([self.usernameFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.usernameFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", @"")
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.view addSubview:self.usernameFloatTextField];
    
    //password text field background
    self.passwordBG = [[UIView alloc] initWithFrame:CGRectMake(25, 150, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.passwordBG.backgroundColor = kLtGray;
    [self.view addSubview:self.passwordBG];
    
    //add the password textfield
    self.passwordFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.passwordBG.frame.origin.y,
                                              self.view.frame.size.width - 2 * kWelcomeTextFieldMargin,
                                              self.passwordBG.frame.size.height)];
    self.passwordFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordFloatTextField.floatingLabel.text = NSLocalizedString(@"Password", nil);
    
    //set our placeholder text color
    if ([self.passwordFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.passwordFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.view addSubview:self.passwordFloatTextField];
    
    
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
    self.loginButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 210, kWelcomeButtonWidth, kWelcomButtonHeight)];
    self.loginButtonLabel.text = NSLocalizedString(@"Log in", @"");
    self.loginButtonLabel.textColor = kMedGray;
    self.loginButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.loginButtonLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0f];
    [self.view addSubview:self.loginButtonLabel];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Set buttons appearance
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateNormal];//fake; so it's invisible
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateHighlighted];//fake; so it's invisible
    [self.logInView.passwordForgottenButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"Forgot Password?" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];//fake; so it's invisible
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];//fake; so it's invisible
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateHighlighted];
    
    
    
    
    

    [self.logInView sendSubviewToBack:self.logInView.passwordForgottenButton];

    

    
    //was having trouble modifying pre-defined small labels so creating my own here
    //add the Log in header label
    self.otherLoginsLabel = [[UILabel alloc] initWithFrame:self.logInView.externalLogInLabel.frame];
    self.otherLoginsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.otherLoginsLabel.textAlignment = NSTextAlignmentCenter;
    self.otherLoginsLabel.backgroundColor = [UIColor clearColor];
    self.otherLoginsLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.otherLoginsLabel.text = @"You can also log in with:";
    [self.logInView addSubview:self.otherLoginsLabel];
    
    //add the Log in header label
    self.signupLabel = [[UILabel alloc] initWithFrame:self.logInView.signUpLabel.frame];
    self.signupLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.signupLabel.textAlignment = NSTextAlignmentCenter;
    self.signupLabel.backgroundColor = [UIColor clearColor];
    self.signupLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.signupLabel.text = @"Don't have an account yet?";
    [self.logInView addSubview:self.signupLabel];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:1.0]];
    
    //set keyboard type for username/email field
    [self.logInView.usernameField setKeyboardType:UIKeyboardTypeEmailAddress];
    
    //hide pre-defined labels
    self.logInView.externalLogInLabel.hidden = YES;
    [self.logInView.logo setHidden:YES];
    [self.logInView.facebookButton.titleLabel setHidden:YES];
    self.logInView.signUpLabel.hidden = YES;
    
    //use attributed strings to set color of placeholder text to darker
    UIColor *color = [UIColor colorWithRed:101.0f/255.0f green:101.0f/255.0f blue:101.0f/255.0f alpha:1.0];
    //username == email address for logging in
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    self.logInView.passwordForgottenButton.titleLabel.textColor = [UIColor darkGrayColor];
    self.logInView.passwordForgottenButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.logInView.passwordForgottenButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
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
//    //    NSLog(@"%s", __FUNCTION__);
    // Set frame for elements
    self.logInView.logInButton.frame = self.loginButtonLabel.frame;
    
    
//    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 245.0f, 44.0f)];
//    self.signupLabel.frame = self.logInView.signUpLabel.frame;
//    
//    
//    
//    //position Log in button
//    CGRect loginButtonFrame = self.logInView.logInButton.frame;
//    [self.logInView.logInButton setFrame:CGRectMake(loginButtonFrame.origin.x,
//                                                    150,
//                                                    loginButtonFrame.size.width,
//                                                    loginButtonFrame.size.height)];
//    
//    //position forgot password button just below Log in button
//    [self.logInView.passwordForgottenButton setFrame:CGRectMake(self.logInView.logInButton.frame.origin.x + self.logInView.logInButton.frame.size.width - 120.0f,
//                                                                self.logInView.logInButton.frame.origin.y + self.logInView.logInButton.frame.size.height,
//                                                                120.0f,
//                                                                20.0f)];
//    
//    // Move all fields down
//    float yOffset = 0.0f;
//    CGRect fieldFrame = self.logInView.usernameField.frame;
//    [self.logInView.usernameField setFrame:CGRectMake(fieldFrame.origin.x+5.0f,
//                                                      fieldFrame.origin.y-8.0f+yOffset,
//                                                      fieldFrame.size.width-10.0f,
//                                                      fieldFrame.size.height)];
//    yOffset += fieldFrame.size.height - 10;
//    
//    [self.logInView.passwordField setFrame:CGRectMake(fieldFrame.origin.x+5.0f,
//                                                      fieldFrame.origin.y+0.0f+yOffset,
//                                                      fieldFrame.size.width-10.0f,
//                                                      fieldFrame.size.height)];
//    
//    //move other login label and other login buttons down a little bit
//    CGRect otherLoginFrame = self.logInView.externalLogInLabel.frame;
//    [self.otherLoginsLabel setFrame:CGRectMake(otherLoginFrame.origin.x,
//                                               otherLoginFrame.origin.y + 10.0f,
//                                               otherLoginFrame.size.width,
//                                               otherLoginFrame.size.height)];
//    
//    //fb button
//    CGRect fbButtonFrame = self.logInView.facebookButton.frame;
//    [self.logInView.facebookButton setFrame:CGRectMake(fbButtonFrame.origin.x,
//                                                       fbButtonFrame.origin.y + 10.0f,
//                                                       fbButtonFrame.size.width,
//                                                       fbButtonFrame.size.height)];
//    
//    //twitter button
//    CGRect twitterButtonFrame = self.logInView.twitterButton.frame;
//    [self.logInView.twitterButton setFrame:CGRectMake(twitterButtonFrame.origin.x,
//                                                      twitterButtonFrame.origin.y + 10.0f,
//                                                      twitterButtonFrame.size.width,
//                                                      twitterButtonFrame.size.height)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
