//
//  KKLoginViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKLoginViewModel;

@interface KKLoginViewController : UIViewController

//exposing these simply for unit testing access to check connections
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *usernameBG;
@property (weak, nonatomic) IBOutlet UIView *passwordBG;
@property (weak, nonatomic) IBOutlet UIView *loginButtonBG;
@property (strong, nonatomic, readonly) KKLoginViewModel *viewModel;

@end
