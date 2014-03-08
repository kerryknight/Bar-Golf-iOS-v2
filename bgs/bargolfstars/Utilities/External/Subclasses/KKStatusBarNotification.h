//
//  KKStatusBarNotification.h
//  Bar Golf
//
//  Created by Kerry Knight on 2/9/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "JDStatusBarNotification.h"

extern NSString *const KKStatusBarSuccess;
extern NSString *const KKStatusBarError;

@interface KKStatusBarNotification : JDStatusBarNotification

+ (void)showWithStatus:(NSString *)status customStyleName:(NSString *)styleName;
+ (void)showWithStatus:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval customStyleName:(NSString *)styleName;

@end
