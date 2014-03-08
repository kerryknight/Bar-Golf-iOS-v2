//
//  KKSignUpViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKSignUpViewController.h"
#import "KKSignUpViewModel.h"
#import "KKAppDelegate.h"
#import "JVFloatLabeledTextField+LabelText.h"
#import "NimbusCore.h"
#import "NimbusAttributedLabel.h"

@interface KKSignUpViewController () <UITextFieldDelegate, NIAttributedLabelDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameFloatTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordFloatTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPasswordFloatTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *displayNameFloatTextField;
@property (strong, nonatomic, readwrite) KKSignUpViewModel *viewModel;
@end

@implementation KKSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureUI];
    [self configureViewModel];
    [self rac_addButtonCommands];
    [self rac_racifyInputTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Private Methods
- (void)configureViewModel {
    self.viewModel = [[KKSignUpViewModel alloc] init];
    self.viewModel.active = YES;
    
    //subscribe to our viewModel's signal
    [[self.viewModel.sendErrorSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id error) {
        //post error to status bar notification
        NSString *message = [NSString stringWithFormat:@"%@", error];
        [KKStatusBarNotification showWithStatus:message dismissAfter:2.0
                                customStyleName:KKStatusBarError];
    }];
}

- (void)rac_addButtonCommands {
    [self rac_createSignUpButtonAndTextFieldViewModelBindings];
    [self rac_createCancelButtonSignal];}

- (void)rac_createSignUpButtonAndTextFieldViewModelBindings {
    RAC(self.viewModel, username) = self.usernameFloatTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordFloatTextField.rac_textSignal;
    RAC(self.viewModel, confirmPassword) = self.confirmPasswordFloatTextField.rac_textSignal;
    RAC(self.viewModel, displayName) = self.displayNameFloatTextField.rac_textSignal;
    
    @weakify(self)
    self.signUpButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self signUp];
        return [RACSignal empty];
    }];
    
    //only show the login button solid color if we have a valid email address and
    //something is entered in the password field in order to reduce erroneous and
    //wasteful parse api calls
    [self.viewModel.allFieldsCombinedSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            @strongify(self)
            self.signUpButton.userInteractionEnabled = YES;
            //fill in our log in button's bg
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.signUpButtonBG.alpha = 1.0;
            }];
        } else {
            @strongify(self)
            self.signUpButton.userInteractionEnabled = NO;
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.signUpButtonBG.alpha = 0.4;
            }];
        }
    }];
    
}

- (void)rac_createCancelButtonSignal {
    @weakify(self)
    self.cancelButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
}

- (RACDisposable *)signUp {
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @strongify(self)
        //show the spinner
        MRProgressOverlayView *spinnerView = [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"Signing up...", Nil) mode:MRProgressOverlayViewModeIndeterminate animated:YES];
        [spinnerView setTintColor:kLtGreen];
    });
    
	return [[[self.viewModel rac_signUpNewUser] deliverOn:[RACScheduler mainThreadScheduler]]
	        subscribeError:^(NSError *error) {
                @strongify(self)
                DLogRed(@"sign up error and show alert: %@", [error localizedDescription]);
                
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //error logging in, show error message
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [error localizedDescription]];
                [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarError];
                
            } completed: ^{
                @strongify(self)
                DLog(@"sign up completed successfully, so show main interface");
                
                [KKStatusBarNotification showWithStatus:NSLocalizedString(@"Success! Welcome, new bar golfer!", nil) dismissAfter:2.0 customStyleName:KKStatusBarSuccess];
                //successfully logged in
                
                //also, save the Display Name for the new user; we'll do this in the background on view model
                [self.viewModel saveDisplayNameForNewlySignedUpUser];
                
                //post a notification that our main interface should show which our
                //menu view controller will observe and load as needed
                [[NSNotificationCenter defaultCenter] postNotificationName:kMenuShouldShowMainInterfaceNotification object:nil];
            }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissAnyKeyboard];
    [super touchesBegan:touches withEvent:event];
}

- (void)dismissAnyKeyboard {
	NSArray *subviews = [self.container subviews];
	
    for (UIView *aview in subviews) {
		
        if ([aview isKindOfClass: [JVFloatLabeledTextField class]]) {
			JVFloatLabeledTextField *textField = (JVFloatLabeledTextField *)aview;
			
            if ([textField isEditing]) {
                
				[textField resignFirstResponder];
			}
		}
	}
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.passwordFloatTextField) {
        if (self.viewModel.passwordTextLengthIsUnderLimit) {
            //always allow changes if we're under our character limit
            return YES;
        } else {
            //if, at our limit, should still always allow backspacing (will be passed in as @"" string)
            return [string isEqualToString:@""] ? YES : NO;
        }
    }
    
    if (textField == self.displayNameFloatTextField) {
        //check if we're under our limit, only allow insertions if so
        if (self.viewModel.displayNameTextLengthIsUnderLimit && [self.viewModel isValidDisplayNameCharacter:string]) {
            //always allow changes if we're under our character limit
            return YES;
        } else {
            return [string isEqualToString:@""] ? YES : NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.passwordFloatTextField) {
        [self.passwordFloatTextField bgs_setFloatingLabelText:NSLocalizedString(@"Password (Minimum 7 characters and 1 number)", nil)];
    }
    
    if (textField == self.displayNameFloatTextField) {
        [self.displayNameFloatTextField bgs_setFloatingLabelText:NSLocalizedString(@"Display Name (This will be visible to others)", nil)];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI Configuration
- (void)configureUI {
    //set initially to appear disabled
    self.signUpButtonBG.alpha = 0.4;
    
    // ********** FLOATING LABEL TEXT FIELDS ********************** //
    UIColor *gray = [kMedWhite colorWithAlphaComponent:0.5];
    [[JVFloatLabeledTextField appearance] setFloatingLabelActiveTextColor:kLtGreen];
    [[JVFloatLabeledTextField appearance] setFloatingLabelTextColor:gray];
    [[JVFloatLabeledTextField appearance] setFloatingLabelFont:[UIFont fontWithName:kHelveticaLight size:12.0f]];
    [[JVFloatLabeledTextField appearance] setFloatingLabelYPadding:@(0)];
    [[JVFloatLabeledTextField appearance] setFont:[UIFont fontWithName:kHelveticaLight size:20.0f]];
    [[JVFloatLabeledTextField appearance] setTextColor:kMedWhite];
    [JVFloatLabeledTextField appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    
    //add the username textfield
    self.usernameFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.usernameBG.frame.origin.y,
                                              self.container.frame.size.width - 2 * kWelcomeTextFieldMargin + 5,
                                              self.usernameBG.frame.size.height)];
    self.usernameFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameFloatTextField.delegate = self;
    [self.usernameFloatTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.usernameFloatTextField.returnKeyType = UIReturnKeyDone;
    self.usernameFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.usernameFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.usernameFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.container addSubview:self.usernameFloatTextField];
    
    //add the password textfield
    self.passwordFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.passwordBG.frame.origin.y,
                                              self.container.frame.size.width - 2 * kWelcomeTextFieldMargin + 5,
                                              self.passwordBG.frame.size.height)];
    self.passwordFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordFloatTextField.delegate = self;
    self.passwordFloatTextField.returnKeyType = UIReturnKeyDone;
    self.passwordFloatTextField.secureTextEntry = YES;
    self.passwordFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.passwordFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.passwordFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    
    [self.container addSubview:self.passwordFloatTextField];
    
    //add the password confirmation textfield
    self.confirmPasswordFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                          CGRectMake(kWelcomeTextFieldMargin,
                                                     self.confirmPasswordBG.frame.origin.y,
                                                     self.container.frame.size.width - 2 * kWelcomeTextFieldMargin + 5,
                                                     self.confirmPasswordBG.frame.size.height)];
    self.confirmPasswordFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPasswordFloatTextField.delegate = self;
    self.confirmPasswordFloatTextField.returnKeyType = UIReturnKeyDone;
    self.confirmPasswordFloatTextField.secureTextEntry = YES;
    self.confirmPasswordFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.confirmPasswordFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.confirmPasswordFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Confirm Password", nil)
                                                                                                   attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.container addSubview:self.confirmPasswordFloatTextField];
    
    //add the password confirmation textfield
    self.displayNameFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                      CGRectMake(kWelcomeTextFieldMargin,
                                                 self.displayNameBG.frame.origin.y,
                                                 self.container.frame.size.width - 2 * kWelcomeTextFieldMargin + 5,
                                                 self.displayNameBG.frame.size.height)];
    self.displayNameFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.displayNameFloatTextField.delegate = self;
    self.displayNameFloatTextField.returnKeyType = UIReturnKeyDone;
    self.displayNameFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.displayNameFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.displayNameFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Display Name", nil)
                                                                                               attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.container addSubview:self.displayNameFloatTextField];
    
    // ********** FLOATING LABEL TEXT FIELDS ********************** //
    
    [self configureAgreementAttributedString];
    
}

- (void)rac_racifyInputTextFields {
    @weakify(self)
    //change the password font color from white to green when it's a legal password
    [self.viewModel.passwordIsValidSignal subscribeNext:^(id x) {
        @strongify(self)
        
        if ([x boolValue]) {
            //it's a valid password, turn it green
            self.passwordFloatTextField.textColor = kLtGreen;
        } else {
            //not valid, keep white
            self.passwordFloatTextField.textColor = kLtWhite;
        }
    }];
    
    //change the confirm password font color from white to green when it matches password
    [self.viewModel.confirmPasswordMatchesSignal  subscribeNext:^(id x) {
        @strongify(self)
        
        if ([x boolValue]) {
            //it matches, turn it green
            self.confirmPasswordFloatTextField.textColor = kLtGreen;
        } else {
            //not valid, keep white
            self.confirmPasswordFloatTextField.textColor = kLtWhite;
        }
    }];
}

#pragma mark - Attributed String Agreement label
- (void)configureAgreementAttributedString {
    
    //add the password footer label
    NIAttributedLabel *agreementLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(self.displayNameBG.frame.origin.x,
                                                                                            self.displayNameBG.frame.origin.y + self.displayNameBG.frame.size.height + 5,
                                                                                            self.displayNameBG.frame.size.width,
                                                                                            self.displayNameBG.frame.size.height)];
    agreementLabel.font = [UIFont fontWithName:kHelveticaLight size:13.0f];
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    agreementLabel.backgroundColor = [UIColor clearColor];
    agreementLabel.textColor = kLtWhite;
    CALayer *agreementLayer = agreementLabel.layer;
    agreementLayer.shadowOpacity = 0.0f;
    agreementLabel.lineBreakMode = NSLineBreakByWordWrapping;
    agreementLabel.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    agreementLabel.numberOfLines = 0;
    
    // Set link's color
    agreementLabel.linkColor = kLtGreen;
    
    // When the user taps a link we can change the way the link text looks.
    agreementLabel.attributesForHighlightedLink = [NSDictionary dictionaryWithObject:(id)kLtGreen.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    
    // In order to handle the events generated by the user tapping a link we must implement the
    // delegate.
    agreementLabel.delegate = self;
    
    // By default the label will not automatically detect links. Turning this on will cause the label
    // to pass through the text with an NSDataDetector, highlighting any detected URLs.
    agreementLabel.autoDetectLinks = YES;
    
    // By default links do not have underlines and this is generally accepted as the standard on iOS.
    // If, however, you do wish to show underlines, you can enable them like so:
    //    self.agreementLabel.linksHaveUnderlines = YES;
    
    agreementLabel.text = @"By signing up, you accept Bar Golf's\nTerms of Service and Privacy Policy.";
    
    NSRange linkRange = [agreementLabel.text rangeOfString:@"Terms of Service"];
    
    // Explicitly adds a link at a given range.
    [agreementLabel addLink:[NSURL URLWithString:@"http://www.bargolfstars.com/terms"] range:linkRange];
    
    NSRange linkRange2 = [agreementLabel.text rangeOfString:@"Privacy Policy"];
    
    // Explicitly adds a link at a given range.
    [agreementLabel addLink:[NSURL URLWithString:@"http://www.bargolfstars.com/privacy"] range:linkRange2];
    [self.container addSubview:agreementLabel];
}

#pragma mark - NIAttributedLabelDelegate

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    // In a later example we will show how to push a Nimbus web controller onto the navigation stack
    // rather than punt the user out of the application to Safari.
    [[UIApplication sharedApplication] openURL:result.URL];
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    NSInteger startingY = IS_IPHONE_TALL ? 60 : 30;
    self.container.frame = CGRectMake(self.container.frame.origin.x,
                                      startingY,
                                      self.container.frame.size.width,
                                      self.container.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
