//
//  KKForgotPasswordViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKForgotPasswordViewModel;

@interface KKForgotPasswordViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendResetLinkButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *emailAddressBG;
@property (weak, nonatomic) IBOutlet UIView *sendResetLinkButtonBG;
@property (strong, nonatomic, readonly) KKForgotPasswordViewModel *viewModel;
@end
