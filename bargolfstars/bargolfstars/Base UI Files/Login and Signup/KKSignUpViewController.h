//
//  KKSignUpViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKSignUpViewModel;

@interface KKSignUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *usernameBG;
@property (weak, nonatomic) IBOutlet UIView *passwordBG;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordBG;
@property (weak, nonatomic) IBOutlet UIView *displayNameBG;
@property (weak, nonatomic) IBOutlet UIView *signUpButtonBG;
@property (strong, nonatomic, readonly) KKSignUpViewModel *viewModel;
@end
