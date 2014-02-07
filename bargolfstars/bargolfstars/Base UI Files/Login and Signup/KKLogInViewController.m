//
//  KKLoginViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKLoginViewController.h"

@interface KKLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameFloatTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordFloatTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *usernameBG;
@property (weak, nonatomic) IBOutlet UIView *passwordBG;
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
    [self rac_addSubscribers];
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    NSInteger startingY = IS_IPHONE_TALL ? 60 : 30;
    self.container.frame = CGRectMake(self.container.frame.origin.x,
                                      startingY,
                                      self.container.frame.size.width,
                                      self.container.frame.size.height);
}


#pragma mark - UI Configuration
- (void)configureUI {
    DLogGreen(@"");
    
    // ********** FLOATING LABEL TEXT FIELDS ********************** //
    UIColor *gray = [kMedWhite colorWithAlphaComponent:0.5];
    [[JVFloatLabeledTextField appearance] setFloatingLabelActiveTextColor:kLtGreen];
    [[JVFloatLabeledTextField appearance] setFloatingLabelTextColor:gray];
    [[JVFloatLabeledTextField appearance] setFloatingLabelFont:[UIFont fontWithName:kHelveticaLight size:12.0f]];
    [[JVFloatLabeledTextField appearance] setFloatingLabelYPadding:@(0)];
    [[JVFloatLabeledTextField appearance] setFont:[UIFont fontWithName:kHelveticaLight size:20.0f]];
    [[JVFloatLabeledTextField appearance] setTextColor:kMedWhite];
    
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
    [self.container addSubview:self.usernameFloatTextField];
    
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
    [self.container addSubview:self.passwordFloatTextField];
    
    // ********** FLOATING LABEL TEXT FIELDS ********************** //
}

#pragma mark - RAC Stuff
- (void)rac_addSubscribers {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
