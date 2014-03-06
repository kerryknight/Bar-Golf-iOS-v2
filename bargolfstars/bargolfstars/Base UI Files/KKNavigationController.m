//
//  KKNavigationController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/23/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKNavigationController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "MEAnimationController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface KKNavigationController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (strong, nonatomic) MEDynamicTransition *dynamicTransition;
@property (strong, nonatomic) MEAnimationController *animationController;
//@property (weak, nonatomic) IBOutlet KKBarGolfNavigationBar *navBar;
@property (unsafe_unretained, nonatomic) BOOL isVisible;
@end

@implementation KKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewDidLayoutSubviews {
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureGestures];
//    [self configureDropDownToolBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self toggleToolbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//#pragma mark - Public Methods
- (void)toggleToolbar {
    DLogOrange(@"");
    @weakify(self)
    if (self.isVisible) {
        CGRect frame = self.toolbar.frame;
        frame.origin.y = self.navigationBar.frame.size.height;
        self.toolbar.frame = frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect frame = self.toolbar.frame;
            frame.origin.y = 0.;
            self.toolbar.frame = frame;
        } completion:^(BOOL finished) {
            @strongify(self)
            self.isVisible = !self.isVisible;
            self.toolbar.hidden = YES;
        }];
        
    } else {
        CGRect frame = self.toolbar.frame;
        frame.origin.y = 0.;
        self.toolbar.hidden = NO;
        self.toolbar.frame = frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect frame = self.toolbar.frame;
            frame.origin.y = self.navigationBar.frame.size.height;
            self.toolbar.frame = frame;
        } completion:^(BOOL finished) {
            @strongify(self)
            self.isVisible = !self.isVisible;
        }];
    }
}


#pragma mark - Private Methods
- (void)findBarsHandler {
    DLogCyan(@"");
}

- (void)findTaxisHandler {
    DLogCyan(@"");
}

- (void)configureUI {
    [self configureSlidingView];
//    [self.navBar configureDropDownToolBar];
}

- (void)configureSlidingView {
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius  = 10.0f;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.view.layer.shadowPath    = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
}

- (void)configureDropDownToolBar {
    DLogOrange(@"");
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.toolbar setBarTintColor:kLtGreen];
//    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.toolbar setBackgroundColor:kLtGreen];
    
    //Make a custom UIButton for the navBar export button.
	UIButton *findABarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.toolbar.frame.size.width/2, self.toolbar.frame.size.height)];
//    findABarButton.frame = CGRectMake(0, 0, self.toolbar.frame.size.width/2,
//    self.toolbar.frame.size.height); [findABarButton
//    setBackgroundImage:[UIImage imageWithColor:kMedGreen
//    andSize:findABarButton.frame.size] forState:UIControlStateHighlighted];
//    [findABarButton setBackgroundImage:[UIImage imageWithColor:kMedGreen andSize:findABarButton.frame.size] forState:UIControlStateSelected];
	[findABarButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[findABarButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[findABarButton.titleLabel setTextColor:kMedGreen];
	[findABarButton setTitle:@"Find Bars" forState:UIControlStateNormal];
	[findABarButton addTarget:self action:@selector(findBarsHandler) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *findATaxiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.toolbar.frame.size.width/2, 0, self.toolbar.frame.size.width/2, self.toolbar.frame.size.height)];
//    findATaxiButton.frame = eight);
//    [findATaxiButton setBackgroundImage:[UIImage imageWithColor:kMedGreen
//    andSize:findATaxiButton.frame.size] forState:UIControlStateHighlighted];
//    [findATaxiButton setBackgroundImage:[UIImage imageWithColor:kMedGreen andSize:findATaxiButton.frame.size] forState:UIControlStateSelected];
	[findATaxiButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[findATaxiButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[findATaxiButton.titleLabel setTextColor:kMedGreen];
	[findATaxiButton setTitle:@"Find Bars" forState:UIControlStateNormal];
	[findATaxiButton addTarget:self action:@selector(findTaxisHandler) forControlEvents:UIControlEventTouchUpInside];

	//Assign it to the navBar.
	//All we need to to now is change the text when appropriate.
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:findABarButton];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:findATaxiButton];
    
	//add the buttons
	self.toolbar.items = ({@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
	                            leftButton,
	                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
	                            rightButton,
	                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];});

	self.toolbar.userInteractionEnabled = YES;
	self.navigationBar.userInteractionEnabled = YES;

	[self.navigationBar insertSubview:self.toolbar atIndex:0];
    
    [self.toolbar setNeedsDisplay];
    [self.toolbar setNeedsLayout];
    
}

- (void)configureGestures {
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [self.view addGestureRecognizer:self.dynamicTransitionPanGesture];
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
