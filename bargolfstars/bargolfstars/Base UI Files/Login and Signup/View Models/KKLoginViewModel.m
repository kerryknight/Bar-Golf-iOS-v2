//
//  KKLoginViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKLoginViewModel.h"
#import "NSString+EmailAdditions.h"

@interface KKLoginViewModel ()
@property (strong, nonatomic) RACSignal *usernameIsValidEmailSignal;
@property (strong, nonatomic) RACSignal *passwordExistsSignal;
@end

@implementation KKLoginViewModel

#pragma mark - Lazy Instantiation


#pragma mark - Public Methods
- (RACSignal *)rac_logIn {
    return [PFUser rac_logInWithUsername:self.username password:self.password];
}

- (RACSignal *)rac_forgotPassword {
    return [RACSignal empty];
}

- (RACSignal *)rac_signUp {
    return [RACSignal empty];
}

- (RACSignal *)rac_logInWithFacebook {
    return [RACSignal empty];
}

#pragma mark - Public Signal Properties
- (RACSignal *)usernameAndPasswordCombinedSignal {
    return [RACSignal combineLatest:@[self.usernameIsValidEmailSignal, self.passwordExistsSignal]
                             reduce:^(NSNumber *user, NSNumber *pass) {
                                 return @(user.intValue > 0 && pass.intValue > 0);//both must be 1 to enable
                             }];
}

#pragma mark - Private Methods

#pragma mark - Private Signal Properties
- (RACSignal *)usernameIsValidEmailSignal {
	if (!_usernameIsValidEmailSignal) {
		_usernameIsValidEmailSignal = [RACObserve(self, username) map:^id(NSString *user) {
			return @([user isValidEmail]);
		}];
	}
	return _usernameIsValidEmailSignal;
}

- (RACSignal *)passwordExistsSignal {
	if (!_passwordExistsSignal) {
		_passwordExistsSignal = [RACObserve(self, password) map:^id(NSString *pass) {
			return @(pass.length > 0);
		}];
	}
	return _passwordExistsSignal;

}

@end
