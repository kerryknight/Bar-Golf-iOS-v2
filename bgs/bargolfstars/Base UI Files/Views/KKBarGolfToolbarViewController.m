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
    //set touch down coloring to darker
    [self.findBarsButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    [self.findBarsButton setTitleColor:kDrkGreen forState:UIControlStateHighlighted];
    
    //set touch down coloring to darker
    [self.findTaxisButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    [self.findTaxisButton setTitleColor:kDrkGreen forState:UIControlStateHighlighted];
    
    self.findBarsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        //post a notification to let our menu view controller know we should
        //load the find a bar list view controller
        DLogPurple(@"");
        [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfShowBarsNotification object:nil];
        return [RACSignal empty];
    }];

    self.findTaxisButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        //post a notification to let our menu view controller know we should
        //load the find a taxi list view controller
        [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfShowTaxisNotification object:nil];
        return [RACSignal empty];
    }];
}

@end
