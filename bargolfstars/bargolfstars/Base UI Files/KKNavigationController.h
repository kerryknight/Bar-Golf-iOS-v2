//
//  KKNavigationController.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/23/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//
//  This subclass will contain the gestures for opening and closing side panel
//  and contains the Find Bars/Taxis sub-toolbar; all other views will be loaded
//  into this main UI class

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface KKNavigationController : UINavigationController <ECSlidingViewControllerDelegate>
- (IBAction)menuButtonTapped:(id)sender;
@end
