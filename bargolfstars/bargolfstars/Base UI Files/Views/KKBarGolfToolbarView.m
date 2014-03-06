//
//  KKBarGolfToolbarView.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/5/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarGolfToolbarView.h"

@implementation KKBarGolfToolbarView

#pragma mark - Public Methods
- (void)configureToolbar {
//    [self adjustFrame];
    [self configureButtons];
}

#pragma mark - Private Methods
- (void)adjustFrame {
    //move frame slightly negative and expand so we don't have the slight
    //unhighlighting when clicking the buttons due to the flexible spaces added;
    //there didn't seem to be an easy way to fix this and fixed widths didn't
    //work at all as i wanted, e.g. to mimic a tab bar essentially
    CGRect f = self.frame;
    CGSize s = f.size;
    CGPoint p = f.origin;
    
    self.frame = CGRectMake(p.x - 1, p.y, s.width + 2, s.height);
}

- (void)configureButtons {
    //Make a custom UIButton for the navBar export button.
	UIButton *findABarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    [findABarButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
	[findABarButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[findABarButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[findABarButton.titleLabel setTextColor:kMedGreen];
	[findABarButton setTitle:@"Find a Bar" forState:UIControlStateNormal];
	[findABarButton addTarget:self action:@selector(findBarsHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *findATaxiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2 + 3, self.frame.size.height)];
    [findATaxiButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
	[findATaxiButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[findATaxiButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[findATaxiButton.titleLabel setTextColor:kMedGreen];
	[findATaxiButton setTitle:@"Call a Taxi" forState:UIControlStateNormal];
	[findATaxiButton addTarget:self action:@selector(findTaxisHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:findABarButton];
    [self addSubview:findATaxiButton];
    
//	//Assign it to the navBar.
//	//All we need to to now is change the text when appropriate.
//	self.findBarsBarButton = [[UIBarButtonItem alloc] initWithCustomView:findABarButton];
//	self.findTaxisBarButton = [[UIBarButtonItem alloc] initWithCustomView:findATaxiButton];
//    
//    //    UIBarButtonItem *middlFixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
//    //    middlFixedSpace.width = 0;
//    //    UIBarButtonItem *rightFixedSpace = [[UIBarButtonItem alloc]
//    //    initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self
//    //    action:nil];
//    //    rightFixedSpace.width = 0;
//    
//	//add the buttons
//    self.items = ({@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                     self.findBarsBarButton,
//                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                     self.findTaxisBarButton,
//                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];});
}

- (IBAction)findBarsHandler:(id)sender {
    DLogOrange(@"");
}

- (IBAction)findTaxisHandler:(id)sender {
    DLogOrange(@"");
}

@end
