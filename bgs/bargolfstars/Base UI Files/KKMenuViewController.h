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
#import "KKWelcomeViewController.h"
#import "KKMyScorecardViewController.h"
#import "KKMyPlayerProfileViewController.h"
#import "KKBarListMapViewController.h"
#import "KKBarListViewController.h"

@interface KKMenuViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

- (void)configureAndLoadInitialWelcomeView;

@end