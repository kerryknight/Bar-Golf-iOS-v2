//
//  KKForgotPasswordViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKForgotPasswordViewModel.h"
#import "NSString+EmailAdditions.h"

@interface KKForgotPasswordViewModel ()
@property (strong, nonatomic, readwrite) RACSignal *emailIsValidEmailSignal;
@end

@implementation KKForgotPasswordViewModel

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    return self;
}

#pragma mark - Public
- (RACSignal *)rac_sendResetPasswordLink {
    DLogBlue(@"email: %@", self.email);
    return [PFUser rac_requestPasswordResetForEmail:self.email];
}

#pragma mark - Private
- (RACSignal *)emailIsValidEmailSignal {
	if (!_emailIsValidEmailSignal) {
		_emailIsValidEmailSignal = [RACObserve(self, email) map: ^id (NSString *emailAddress) {
		    return @([emailAddress isValidEmail]);
		}];
	}
	return _emailIsValidEmailSignal;
}

@end
