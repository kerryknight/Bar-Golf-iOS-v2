//
//  KKAppDelegate.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@import UIKit;

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *welcomeNavigationController;
@property (assign, nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
- (void)logOut;

@end
