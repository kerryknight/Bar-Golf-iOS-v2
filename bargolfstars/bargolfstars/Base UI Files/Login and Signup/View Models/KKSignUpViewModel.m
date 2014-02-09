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
@property (strong, nonatomic, readwrite) RACSignal *usernameIsValidEmailSignal;
@property (strong, nonatomic, readwrite) RACSignal *passwordIsValidSignal;
@property (strong, nonatomic, readwrite) RACSignal *confirmPasswordMatchesSignal;
@property (strong, nonatomic, readwrite) RACSignal *displayNameIsValidSignal;
@property (strong, nonatomic, readwrite) RACSignal *allFieldsCombinedSignal;
@property (strong, nonatomic, readwrite) RACSignal *sendErrorSignal;
@property (assign, nonatomic, readwrite) BOOL passwordTextLengthIsUnderLimit;
@property (assign, nonatomic, readwrite) BOOL displayNameTextLengthIsUnderLimit;
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

#pragma mark - Public Normal Properties
- (BOOL)passwordTextLengthIsUnderLimit {
    BOOL underLimit = (self.password.length < kKKMaximumPasswordLength);
    if (!underLimit) {
        NSString *characterLimit = [NSString stringWithFormat:@"Password limit is %i characters", kKKMaximumPasswordLength];
        [(RACSubject *)self.sendErrorSignal sendNext:characterLimit];
    }
    
    return underLimit;
}

- (BOOL)displayNameTextLengthIsUnderLimit {
    BOOL underLimit = (self.displayName.length < kKKMaximumDisplayNameLength);
    if (!underLimit) {
        NSString *characterLimit = [NSString stringWithFormat:@"Display name limit is %i characters", kKKMaximumDisplayNameLength];
        [(RACSubject *)self.sendErrorSignal sendNext:characterLimit];
    }
    
    return underLimit;
}

#pragma mark - Public Signal Properties
- (RACSignal *)allFieldsCombinedSignal {
    return [RACSignal combineLatest:@[self.usernameIsValidEmailSignal, self.passwordIsValidSignal, self.confirmPasswordMatchesSignal, self.displayNameIsValidSignal]
                             reduce:^(NSNumber *user, NSNumber *pass, NSNumber *confirmPass, NSNumber *displayName) {
                                 //only count passwords matching if we have a valid password
                                 BOOL passesMatch = (confirmPass.intValue > 0 && pass.intValue > 0);
                                 int total = user.intValue + pass.intValue + passesMatch + displayName.intValue;
                                
                                 return @(total == 4);
                             }];
}

#pragma mark - Private Methods
- (BOOL)isValidPassword {
    BOOL isValid = YES;
    //ensure password is long enough
    if (self.password.length < kKKMinimumPasswordLength || self.password.length > kKKMaximumPasswordLength) {
        isValid = NO;
        return isValid;
    }
    
    //check the characters used in the password field; new passwords must contain at least 1 digit
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    if ([self.password rangeOfCharacterFromSet:set].location == NSNotFound) {
        //no numbers found
        isValid = NO;
        return isValid;
    }
    
    //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
    set = [NSCharacterSet characterSetWithCharactersInString:@" "];
    if ([self.password rangeOfCharacterFromSet:set].location != NSNotFound) {
        //special characters found
        NSString *error = [NSString stringWithFormat:NSLocalizedString(@"Passwords can't contain spaces.", nil)];
        [(RACSubject *)self.sendErrorSignal sendNext:error];
        isValid = NO;
        return isValid;
    }
    return isValid;
}


- (BOOL)isValidDisplayName {
    BOOL isValid = YES;
    //ensure password is long enough
    if (self.displayName.length < kKKMinimumDisplayNameLength || self.displayName.length > kKKMaximumDisplayNameLength) {
        isValid = NO;
        return isValid;
    }
    
    //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([self.displayName rangeOfCharacterFromSet:set].location != NSNotFound) {
        //special characters found
        NSString *error = [NSString stringWithFormat:NSLocalizedString(@"Display names can contain letters, numbers and spaces only.", nil)];
        [(RACSubject *)self.sendErrorSignal sendNext:error];
        isValid = NO;
        return isValid;
    }
    return isValid;
}

- (BOOL)confirmPasswordMatchesPassword {
    return [self.password isEqualToString:self.confirmPassword];
}

#pragma mark - Private Signal Properties
- (RACSignal *)usernameIsValidEmailSignal {
	if (!_usernameIsValidEmailSignal) {
		_usernameIsValidEmailSignal = [RACObserve(self, username) map: ^id (NSString *user) {
		    return @([user isValidEmail]);
		}];
	}
	return _usernameIsValidEmailSignal;
}

- (RACSignal *)passwordIsValidSignal {
	if (!_passwordIsValidSignal) {
         @weakify(self)
		_passwordIsValidSignal = [RACObserve(self, password) map: ^id (NSString *pass) {
            @strongify(self)
		    return @([self isValidPassword]);
		}];
	}
	return _passwordIsValidSignal;
}

- (RACSignal *)confirmPasswordMatchesSignal {
	if (!_confirmPasswordMatchesSignal) {
        @weakify(self)
		_confirmPasswordMatchesSignal = [RACSignal combineLatest:@[self.passwordIsValidSignal,
		                                                           RACObserve(self, confirmPassword)]
		                                                  reduce: ^(NSNumber *pass, NSString *confirmPass) {
                                                              @strongify(self)
                                                              //only care about matching passwords if the password is valid
                                                              return @(([self confirmPasswordMatchesPassword] && pass.intValue > 0));
                                                          }];
	}
	return _confirmPasswordMatchesSignal;
}

- (RACSignal *)displayNameIsValidSignal {
	if (!_displayNameIsValidSignal) {
         @weakify(self)
		_displayNameIsValidSignal = [RACObserve(self, displayName) map: ^id (NSString *name) {
            @strongify(self)
		    return @([self isValidDisplayName]);
		}];
	}
	return _displayNameIsValidSignal;
}

@end
