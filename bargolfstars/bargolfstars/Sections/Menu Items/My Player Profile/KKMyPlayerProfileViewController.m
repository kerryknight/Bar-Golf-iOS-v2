//
//  KKMyPlayerProfileViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/6/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMyPlayerProfileViewController.h"

@interface KKMyPlayerProfileViewController ()
@end

@implementation KKMyPlayerProfileViewController

#pragma mark - Life Cycle and Lazy Instantiation
- (void)viewDidLoad {
    DLog(@"");
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Private Methods
- (void)configureUI {
    self.navigationController.title = @"My Profile";
}

#pragma mark - Public Methods

@end