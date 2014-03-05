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
@property (nonatomic, strong) UINavigationController *navController;
@property (assign, nonatomic, readonly) int networkStatus;

- (void)showMainInterface;
- (BOOL)isParseReachable;
- (void)logOut;

@end
