// KKMenuViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAppDelegate.h"
#import "KKNavigationController.h"
#import "ICSDrawerController.h"
#import "KKMyScorecardViewController.h"
#import "KKMyPlayerProfileViewController.h"

@interface KKMenuViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end