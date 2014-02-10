//
//  KKSignUpViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@interface KKSignUpViewModel : RVMViewModel

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *confirmPassword;
@property (copy, nonatomic) NSString *displayName;
@property (strong, nonatomic, readonly) RACSignal *allFieldsCombinedSignal;
@property (strong, nonatomic, readonly) RACSignal *usernameIsValidEmailSignal;
@property (strong, nonatomic, readonly) RACSignal *passwordIsValidSignal;
@property (strong, nonatomic, readonly) RACSignal *confirmPasswordMatchesSignal;
@property (strong, nonatomic, readonly) RACSignal *displayNameIsValidSignal;
@property (strong, nonatomic, readonly) RACSignal *sendErrorSignal;
@property (assign, nonatomic, readonly) BOOL passwordTextLengthIsUnderLimit;
@property (assign, nonatomic, readonly) BOOL displayNameTextLengthIsUnderLimit;

- (BOOL)isValidPassword;
- (BOOL)isValidDisplayNameLength;
- (BOOL)isValidDisplayNameCharacter:(NSString *)characters;
- (BOOL)confirmPasswordMatchesPassword;
- (void)saveDisplayNameForNewlySignedUpUser;
- (RACSignal *)rac_signUpNewUser;

@end
