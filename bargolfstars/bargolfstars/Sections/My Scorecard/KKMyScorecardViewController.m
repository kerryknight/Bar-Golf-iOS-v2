//
//  KKMyScorecardViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMyScorecardViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "MEAnimationController.h"

@interface KKMyScorecardViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) MEDynamicTransition *dynamicTransition;
@property (nonatomic, strong) MEAnimationController *animationController;
@end

@implementation KKMyScorecardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    DLog(@"");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    DLog(@"");
    [super viewDidLoad];
    
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius  = 10.0f;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.view.layer.shadowPath    = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (void)viewDidLayoutSubviews {
    DLog(@"");
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureGestures];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)configureGestures {
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}
- (MEDynamicTransition *)dynamicTransition {
    if (_dynamicTransition) return _dynamicTransition;
    
    _dynamicTransition = [[MEDynamicTransition alloc] init];
    
    return _dynamicTransition;
}

- (MEAnimationController *)animationController {
    if (_animationController) return _animationController;
    
    _animationController = [[MEAnimationController alloc] init];
    
    return _animationController;
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
