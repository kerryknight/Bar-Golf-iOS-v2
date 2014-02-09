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
@property(nonatomic, strong) RACSignal *displayNameIsValidSignal;
@property (strong, nonatomic, readwrite) RACSignal *allFieldsCombinedSignal;
@property (strong, nonatomic, readwrite) RACSignal *sendErrorSignal;
@end

@implementation KKSignUpViewModel

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    self.sendErrorSignal = [[RACSubject subject] setNameWithFormat:@"KKSignUpViewModel sendErrorSignal"];
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        //no op
    }];
    
    return self;
}


#pragma mark - Public Methods
- (RACSignal *)rac_signUp {
    return nil;
//    return [PFUser rac_logInWithUsername:self.username password:self.password];
}

#pragma mark - Public Signal Properties
- (RACSignal *)allFieldsCombinedSignal {
    return [RACSignal combineLatest:@[self.usernameIsValidEmailSignal, self.passwordIsValidSignal, RACObserve(self, confirmPassword), self.displayNameIsValidSignal]
                             reduce:^(NSNumber *user, NSNumber *pass, NSString *confirmPass, NSNumber *displayName) {
                                 BOOL passesEqual = ([self.password isEqualToString:confirmPass] && self.password.length > 0);
                                 int total = user.intValue + pass.intValue + passesEqual + displayName.intValue;
                                
                                 return @(total == 4);
                             }];
}

#pragma mark - Private Methods
- (BOOL)isValidPassword:(NSString *)password {
    BOOL isValid = YES;
    //ensure password is long enough
    if (password.length < kKKMinimumPasswordLength || password.length > kKKMaximumPasswordLength) {
        isValid = NO;
        return isValid;
    }
    
    //check the characters used in the password field; new passwords must contain at least 1 digit
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    if ([password rangeOfCharacterFromSet:set].location == NSNotFound) {
        //no numbers found
        isValid = NO;
        return isValid;
    }
    
    //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
    set = [NSCharacterSet characterSetWithCharactersInString:@" "];
    if ([password rangeOfCharacterFromSet:set].location != NSNotFound) {
        //special characters found
        NSString *error = [NSString stringWithFormat:NSLocalizedString(@"Passwords can't contain spaces.", nil)];
        [(RACSubject *)self.sendErrorSignal sendNext:error];
        
        #warning should change the color of the placeholder string to red when this happens
        isValid = NO;
        return isValid;
    }
    return isValid;
}


- (BOOL)isValidDisplayName:(NSString *)displayName {
    BOOL isValid = YES;
    //ensure password is long enough
    if (displayName.length < kKKMinimumDisplayNameLength || displayName.length > kKKMaximumDisplayNameLength) {
        isValid = NO;
        return isValid;
    }
    
    //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([displayName rangeOfCharacterFromSet:set].location != NSNotFound) {
        //special characters found
        NSString *error = [NSString stringWithFormat:NSLocalizedString(@"Display names can contain letters, numbers and spaces only.", nil)];
        [(RACSubject *)self.sendErrorSignal sendNext:error];
        
#warning should change the color of the placeholder string to red when this happens
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

- (RACSignal *)displayNameIsValidSignal {
	if (!_displayNameIsValidSignal) {
		_displayNameIsValidSignal = [RACObserve(self, displayName) map:^id(NSString *name) {
			return @([self isValidDisplayName:name]);
		}];
	}
	return _displayNameIsValidSignal;
}

@end
