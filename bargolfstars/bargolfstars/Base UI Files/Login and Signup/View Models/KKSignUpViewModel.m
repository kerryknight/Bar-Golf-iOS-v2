//
//  KKSignUpViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKSignUpViewModel.h"
#import "NSString+EmailAdditions.h"

@interface KKSignUpViewModel ()
@property(nonatomic, strong) RACSignal *usernameIsValidEmailSignal;
@property(nonatomic, strong) RACSignal *passwordIsValidSignal;
@property(nonatomic, strong) RACSignal *confirmPasswordMatchesSignal;
@end

@implementation KKSignUpViewModel

#pragma mark - Lazy Instantiation


#pragma mark - Public Methods
- (RACSignal *)rac_signUp {
    return nil;
//    return [PFUser rac_logInWithUsername:self.username password:self.password];
}

#pragma mark - Public Signal Properties
- (RACSignal *)allFieldsCombinedSignal {
    return [RACSignal combineLatest:@[self.usernameIsValidEmailSignal, self.passwordIsValidSignal, self.confirmPasswordMatchesSignal]
                             reduce:^(NSNumber *user, NSNumber *pass, NSNumber *confirmPass) {
                                 return @(user.intValue > 0 && pass.intValue > 0 && confirmPass.intValue > 0);//both must be 1 to enable
                             }];
}

#pragma mark - Private Methods
- (BOOL)isValidPassword:(NSString *)password {
    BOOL isValid = YES;
    //ensure password is long enough
    if (password.length < kKKMinimumPasswordLength) {
//        alertMessage(@"Password must be at least %i characters.", kKKMinimumPasswordLength);
        isValid = NO;
        return isValid;
    }
    
    //check the characters used in the password field; new passwords must contain at least 1 digit
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    if ([password rangeOfCharacterFromSet:set].location == NSNotFound) {
        //no numbers found
//        alertMessage(@"Password must contain at least one number");
        isValid = NO;
        return isValid;
    }
    
    //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
    set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([password rangeOfCharacterFromSet:set].location != NSNotFound) {
        //special characters found
//        alertMessage(@"Display names can only contain letters and numbers.");
        isValid = NO;
        return isValid;
    }
    return isValid;
}

#pragma mark - Private Signal Properties
- (RACSignal *)usernameIsValidEmailSignal {
	if (!_usernameIsValidEmailSignal) {
		_usernameIsValidEmailSignal = [RACObserve(self, username) map:^id(NSString *user) {
			return @([user isValidEmail]);
		}];
	}
	return _usernameIsValidEmailSignal;
}

- (RACSignal *)passwordIsValidSignal {
	if (!_passwordIsValidSignal) {
		_passwordIsValidSignal = [RACObserve(self, password) map:^id(NSString *pass) {
			return @([self isValidPassword:pass]);
		}];
	}
	return _passwordIsValidSignal;
}

- (RACSignal *)confirmPasswordMatchesSignal {
	if (!_confirmPasswordMatchesSignal) {
		_confirmPasswordMatchesSignal = [RACObserve(self, confirmPassword) map:^id(NSString *confirmPass) {
			return @([confirmPass isEqualToString:self.password]);
		}];
	}
	return _confirmPasswordMatchesSignal;
}


@end
