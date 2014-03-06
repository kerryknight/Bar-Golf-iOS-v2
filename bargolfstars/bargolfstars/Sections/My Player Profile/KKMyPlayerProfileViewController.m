//
//  KKMyPlayerProfileViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMyPlayerProfileViewController.h"

@interface KKMyPlayerProfileViewController ()
@property (weak, nonatomic) IBOutlet KKBarGolfToolbarView *toolBar;
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
    [self.toolBar configureToolbar];
}

#pragma mark - Public Methods

@end
