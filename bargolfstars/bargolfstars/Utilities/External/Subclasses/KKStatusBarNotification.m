//
//  KKStatusBarNotification.m
//  Bar Golf
//
//  Created by Kerry Knight on 2/9/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKStatusBarNotification.h"

@implementation KKStatusBarNotification

NSString *const KKStatusBarSuccess = @"KKStatusBarSuccess";
NSString *const KKStatusBarError = @"KKStatusBarError";

#pragma mark - Life Cyle and Private Customization
+ (KKStatusBarNotification *)sharedInstance {
    static dispatch_once_t once;
    static KKStatusBarNotification *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[KKStatusBarNotification alloc] init];
        [self addCustomStyles];
    });
    return sharedInstance;
}

+ (void)addCustomStyles {
    //custom success style
    [JDStatusBarNotification addStyleNamed:KKStatusBarSuccess
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = kLtGreen;
                                       style.textColor = [UIColor whiteColor];
                                       return style;
                                   }];
    
    //custom error style
    [JDStatusBarNotification addStyleNamed:KKStatusBarError
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = kErrorRed;
                                       style.textColor = [UIColor whiteColor];
                                       return style;
                                   }];
}

#pragma mark - Public Methods
+ (void)showWithStatus:(NSString *)status customStyleName:(NSString*)styleName {
    return [[self sharedInstance] sharedInstanceShowWithStatus:status customStyleName:styleName];
}

+ (void)showWithStatus:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval customStyleName:(NSString*)styleName {
    return [[self sharedInstance] sharedInstanceShowWithStatus:status dismissAfter:timeInterval customStyleName:styleName];
}


#pragma mark - Private Methods
- (void)sharedInstanceShowWithStatus:(NSString *)status customStyleName:(NSString*)styleName {
    [JDStatusBarNotification showWithStatus:status styleName:styleName];
}

- (void)sharedInstanceShowWithStatus:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval customStyleName:(NSString*)styleName {
    [JDStatusBarNotification showWithStatus:status dismissAfter:timeInterval styleName:styleName];
}

@end
