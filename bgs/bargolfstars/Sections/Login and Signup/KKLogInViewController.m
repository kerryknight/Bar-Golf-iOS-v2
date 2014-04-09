//
//  KKLoginViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKLoginViewController.h"
#import "KKLoginViewModel.h"
#import "KKAppDelegate.h"
#import "STPSlideUpTransition.h"
#import "KKSignUpViewController.h"
#import "KKForgotPasswordViewController.h"

@interface KKLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameFloatTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordFloatTextField;
@property (strong, nonatomic, readwrite) KKLoginViewModel *viewModel;
@end

@implementation KKLoginViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Private Methods
- (void)configureViewModel {
    self.viewModel = [[KKLoginViewModel alloc] init];
    self.viewModel.active = YES;
}

- (void)rac_addButtonCommands {
    [self rac_createLoginButtonAndTextFieldViewModelBindings];
    [self rac_createForgotPasswordButtonSignal];
    [self rac_createSignUpButtonSignal];
    [self rac_createFacebookButtonSignal];
}

- (void)rac_createLoginButtonAndTextFieldViewModelBindings {
    RAC(self.viewModel, username) = self.usernameFloatTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordFloatTextField.rac_textSignal;
    
    @weakify(self)
    self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self logIn];
        return [RACSignal empty];
    }];
    
    //only show the login button solid color if we have a valid email address and
    //something is entered in the password field in order to reduce erroneous and
    //wasteful parse api calls
    [self.viewModel.usernameAndPasswordCombinedSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            @strongify(self)
            self.loginButton.userInteractionEnabled = YES;
            //fill in our log in button's bg
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.loginButtonBG.alpha = 1.0;
            }];
            
        } else {
            @strongify(self)
            self.loginButton.userInteractionEnabled = NO;
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.loginButtonBG.alpha = 0.05;
            }];
        }
    }];
    
}

- (void)rac_createForgotPasswordButtonSignal {
    @weakify(self)
    self.forgotPasswordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self loadForgotPasswordView];
        return [RACSignal empty];
    }];
}

- (void)rac_createSignUpButtonSignal {
    @weakify(self)
    self.signUpButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        
        [self loadSignUpView];
        return [RACSignal empty];
    }];
}

- (void)rac_createFacebookButtonSignal {
    @weakify(self)
    self.facebookButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self logInWithFacebook];
        return [RACSignal empty];
    }];
}

- (RACDisposable *)logIn {
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @strongify(self)
        //show the spinner
        MRProgressOverlayView *spinnerView = [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"Logging in...", Nil) mode:MRProgressOverlayViewModeIndeterminate animated:YES];
        [spinnerView setTintColor:kLtGreen];
    });
    
	return [[self.viewModel rac_logIn]
	        subscribeNext:^(PFUser *user) {
                @strongify(self)
                
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //error logging in, show error message
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Welcome back, %@!", nil), user[@"displayName"]];
                [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarSuccess];
                
            } error:^(NSError *error) {
                @strongify(self)
                DLogRed(@"login error and show alert: %@", [error localizedDescription]);
                
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //error logging in, show error message
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [error localizedDescription]];
                [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarError];
            } completed:^{
                DLog(@"log in completed successfully, so show main interface");
                //successfully logged in
                //post a notification that our main interface should show which our
                //menu view controller will observe and load as needed
                [[NSNotificationCenter defaultCenter] postNotificationName:kMenuShouldShowMainInterfaceNotification object:nil];
            }];
}

- (RACDisposable *)logInWithFacebook {
    DLogGreen(@"");
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @strongify(self)
        //show the spinner
        MRProgressOverlayView *spinnerView = [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"Logging in...", Nil) mode:MRProgressOverlayViewModeIndeterminate animated:YES];
        [spinnerView setTintColor:kLtGreen];
    });
    
	return [[self.viewModel rac_logInWithFacebook]
            subscribeNext:^(id x) {
                DLog(@"rac_logInWithFacebook subscribeNext:");
            }
	        error:^(NSError *error) {
                @strongify(self)
                
                NSString *message;
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //check if the error was caused by the use disallowing FB integration within their device settings
                if ([[error userInfo][@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:SystemLoginDisallowedWithoutError"]) {
                    //alert user to allow facebook integration in Settings > Facebook > ApplicationName (NO)
                    message = NSLocalizedString(@"Enable logging into Bar Golf with Facebook by going to Settings > Facebook > and ensuring Bar Golf is turned ON.", nil);
                } else {
                    //error logging in, show error message
                    message = [NSString stringWithFormat:NSLocalizedString(@"Error: %@ \n\nPlease try again.", nil), [error localizedDescription]];
                }
                
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Facebook Login Error" andMessage:message];
                [alertView addButtonWithTitle:@"OK"
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                          //called when button pressed
                                      }];
                alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                [alertView show];
                
            } completed:^{
                DLog(@"rac_logInWithFacebook completed successfully, so show main interface");
                //successfully logged in
                @strongify(self)
                
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //error logging in, show error message
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Welcome to Bar Golf, %@!", nil), [PFUser currentUser][@"displayName"]];
                [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarSuccess];
                
                //post a notification that our main interface should show which our
                //menu view controller will observe and load as needed
                [[NSNotificationCenter defaultCenter] postNotificationName:kMenuShouldShowMainInterfaceNotification object:nil];
            }];
}

- (void)loadSignUpView {
    self.navigationController.delegate = [STPTransitionCenter sharedInstance];
    STPCardTransition *transition = [STPCardTransition new];
    transition.reverseTransition = [STPCardTransition new];
    
    KKSignUpViewController *signUpViewController = [[KKSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController
                                  usingTransition:transition];
}

- (void)loadForgotPasswordView {
    self.navigationController.delegate = [STPTransitionCenter sharedInstance];
    STPCardTransition *transition = [STPCardTransition new];
    transition.reverseTransition = [STPCardTransition new];
    
    KKForgotPasswordViewController *forgotPasswordViewController = [[KKForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgotPasswordViewController
                                  usingTransition:transition];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI Configuration
- (void)configureUI {
    //set initially to appear disabled
    self.loginButtonBG.alpha = 0.05;
    
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
    self.usernameFloatTextField.floatingLabel.text = NSLocalizedString(@"Email Address", nil);
    [self.usernameFloatTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.usernameFloatTextField.returnKeyType = UIReturnKeyGo;
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
    self.passwordFloatTextField.returnKeyType = UIReturnKeyGo;
    self.passwordFloatTextField.secureTextEntry = YES;
    self.passwordFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordFloatTextField.floatingLabel.text = NSLocalizedString(@"Password", nil);
    
    //set our placeholder text color
    if ([self.passwordFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.passwordFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.container addSubview:self.passwordFloatTextField];
    
    // ********** FLOATING LABEL TEXT FIELDS ********************** //
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
