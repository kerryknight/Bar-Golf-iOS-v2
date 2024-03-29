//
//  KKAppDelegate.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKNavigationController.h"

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
- (void)logOut;
- (void)showSpinnerWithMessage:(NSString *)message;
- (void)hideSpinner;

@end