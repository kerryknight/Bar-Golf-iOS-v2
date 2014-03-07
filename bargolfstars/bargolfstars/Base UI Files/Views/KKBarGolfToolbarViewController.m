//
//  KKBarGolfToolbarViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/6/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarGolfToolbarViewController.h"

@interface KKBarGolfToolbarViewController ()

@end

@implementation KKBarGolfToolbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)configureButtons {
    //Make a custom UIButton for the navBar export button.
    [self.findBarsButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    @weakify(self)
    self.findBarsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self findBarsHandler:nil];
        return [RACSignal empty];
    }];

    [self.findTaxisButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    self.findTaxisButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self findTaxisHandler:nil];
        return [RACSignal empty];
    }];
}

- (IBAction)findBarsHandler:(id)sender {
    DLogOrange(@"");
}

- (IBAction)findTaxisHandler:(id)sender {
    DLogOrange(@"");
}

@end
