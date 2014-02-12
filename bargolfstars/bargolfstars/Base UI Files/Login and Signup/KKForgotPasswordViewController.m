//
//  KKForgotPasswordViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKForgotPasswordViewController.h"
#import "KKForgotPasswordViewModel.h"
#import "JVFloatLabeledTextField+LabelText.h"

@interface KKForgotPasswordViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *emailAddressFloatTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendResetLinkButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *emailAddressBG;
@property (weak, nonatomic) IBOutlet UIView *sendResetLinkButtonBG;
@property (strong, nonatomic) KKForgotPasswordViewModel *viewModel;
    
@end

@implementation KKForgotPasswordViewController

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
    self.viewModel = [[KKForgotPasswordViewModel alloc] init];
    self.viewModel.active = YES;
}

- (void)rac_addButtonCommands {
    [self rac_createResetLinkButtonAndTextFieldViewModelBindings];
    [self rac_createCancelButtonSignal];}

- (void)rac_createResetLinkButtonAndTextFieldViewModelBindings {
    RAC(self.viewModel, email) = self.emailAddressFloatTextField.rac_textSignal;
    
    @weakify(self)
    self.sendResetLinkButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self dismissAnyKeyboard];
        [self sendResetLink];
        return [RACSignal empty];
    }];
    
    //only show the login button solid color if we have a valid email address and
    //something is entered in the password field in order to reduce erroneous and
    //wasteful parse api calls
    [self.viewModel.emailIsValidEmailSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            //fill in our log in button's bg
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.sendResetLinkButtonBG.alpha = 1.0;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                self.sendResetLinkButtonBG.alpha = 0.4;
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

- (RACDisposable *)sendResetLink {
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @strongify(self)
        //dismiss the spinner regardless of outcome
        MRProgressOverlayView *spinnerView = [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"Sending reset link...", Nil) mode:MRProgressOverlayViewModeIndeterminate animated:YES];
        [spinnerView setTintColor:kLtGreen];
    });
    
	return [[[self.viewModel rac_sendResetPasswordLink] deliverOn:[RACScheduler mainThreadScheduler]]
	        subscribeError:^(NSError *error) {
                @strongify(self)
                DLogRed(@"reset link send error show alert: %@", [error localizedDescription]);
                
                //dismiss the spinner regardless of outcome
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                
                //error logging in, show error message
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [error localizedDescription]];
                [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarError];
                
            } completed:^{
                @strongify(self)
                DLog(@"sent reset link successfully, go back to login view");
                
                [KKStatusBarNotification showWithStatus:NSLocalizedString(@"Email with reset link sent!", nil) dismissAfter:2.0 customStyleName:KKStatusBarSuccess];
                //successfully sent email
                [self.navigationController popViewControllerAnimated:YES];
                
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    @weakify(self)
    [self.viewModel.emailIsValidEmailSignal subscribeNext:^(id x) {
        @strongify(self)
        [self sendResetLink];
    }];
    return YES;
}

#pragma mark - UI Configuration
- (void)configureUI {
    //set initially to appear disabled
    self.sendResetLinkButtonBG.alpha = 0.4;
    
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
    self.emailAddressFloatTextField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                   CGRectMake(kWelcomeTextFieldMargin,
                                              self.emailAddressBG.frame.origin.y,
                                              self.container.frame.size.width - 2 * kWelcomeTextFieldMargin + 5,
                                              self.emailAddressBG.frame.size.height)];
    self.emailAddressFloatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailAddressFloatTextField.delegate = self;
    [self.emailAddressFloatTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailAddressFloatTextField.returnKeyType = UIReturnKeyGo;
    self.emailAddressFloatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //set our placeholder text color
    if ([self.emailAddressFloatTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.emailAddressFloatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", nil)
                                                                                            attributes:@{NSForegroundColorAttributeName: gray}];
    }
    [self.container addSubview:self.emailAddressFloatTextField];
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
