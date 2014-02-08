//
//  KKLoginViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@interface KKLoginViewModel : RVMViewModel

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *forgottenEmail;
@property(nonatomic, strong) RACSignal *usernameAndPasswordCombinedSignal;

- (RACSignal *)rac_logIn;
- (RACSignal *)rac_forgotPassword;
- (RACSignal *)rac_signUp;
- (RACSignal *)rac_logInWithFacebook;


@end
