// MEAnimationController.h
// TransitionFun
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)


#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"

@interface MEAnimationController : NSObject <UIViewControllerAnimatedTransitioning,
                                                 ECSlidingViewControllerDelegate,
                                                 ECSlidingViewControllerLayout>
@end
