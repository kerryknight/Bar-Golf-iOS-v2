//
//  KKNavigationController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/23/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKNavigationController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface KKNavigationController ()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation KKNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController andTitle:(NSString *)title {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self configureUI];
        _titleLabel.text = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Public Methods

- (void)setTitleLabelText:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - Private Methods
- (void)configureUI {
    [self configureNavBar];
    
    self.view.backgroundColor = kMedGray;
}

- (void)configureNavBar {
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = kLtGray;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, self.navigationBar.frame.size.height)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setFont:[UIFont fontWithName:kHelveticaLight size:18.0f]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [self.navigationBar addSubview:self.titleLabel];
}

#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController {
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button
- (void)openDrawer:(id)sender {
    [self.drawer open];
}

@end
