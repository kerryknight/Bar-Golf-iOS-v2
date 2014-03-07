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
@property (copy, nonatomic) NSString *customTitle;
@end

@implementation KKNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController andTitle:(NSString *)title {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        _customTitle = title;
        [self configureUI];
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

#pragma mark - Private Methods
- (void)configureUI {
    [self configureNavBar];
    
    self.view.backgroundColor = kMedGray;
}

- (void)configureNavBar {
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = kLtGray;
    
    UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, self.navigationBar.frame.size.height)];
    [bigLabel setBackgroundColor:[UIColor clearColor]];
    [bigLabel setTextAlignment:NSTextAlignmentCenter];
    [bigLabel setContentMode:UIViewContentModeCenter];
    [bigLabel setFont:[UIFont fontWithName:kHelveticaLight size:18.0f]];
    [bigLabel setTextColor:[UIColor whiteColor]];
    [bigLabel setShadowColor:[UIColor darkGrayColor]];
    [bigLabel setShadowOffset:CGSizeMake(0, 1)];
    bigLabel.text = self.customTitle;
    
    [self.navigationBar addSubview:bigLabel];
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button

- (void)openDrawer:(id)sender
{
    [self.drawer open];
}

@end
