//
//  KKForgotPasswordViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@interface KKForgotPasswordViewModel : RVMViewModel

@property (copy, nonatomic) NSString *email;
@property (strong, nonatomic, readonly) RACSignal *emailIsValidEmailSignal;

- (RACSignal *)rac_sendResetPasswordLink;

@end
