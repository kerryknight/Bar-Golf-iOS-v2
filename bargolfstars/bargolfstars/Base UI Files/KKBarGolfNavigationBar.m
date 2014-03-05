//
//  KKBarGolfNavigationBar.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/5/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarGolfNavigationBar.h"

@interface KKBarGolfNavigationBar ()
@property (assign, nonatomic) BOOL isVisible;
@end

@implementation KKBarGolfNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Methods
- (void)toggleToolbar {
    DLogGreen(@"");
    @weakify(self)
    
    if (self.isVisible) {
        CGRect frame = self.toolbarView.frame;
        frame.origin.y = self.frame.size.height;
        self.toolbarView.frame = frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect frame = self.toolbarView.frame;
            frame.origin.y = 0.;
            self.toolbarView.frame = frame;
        } completion:^(BOOL finished) {
            @strongify(self)
            self.isVisible = !self.isVisible;
            self.toolbarView.hidden = YES;
        }];
        
    } else {
        CGRect frame = self.toolbarView.frame;
        frame.origin.y = 0.;
        self.toolbarView.hidden = NO;
        self.toolbarView.frame = frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect frame = self.toolbarView.frame;
            frame.origin.y = self.frame.size.height;
            self.toolbarView.frame = frame;
        } completion:^(BOOL finished) {
            @strongify(self)
            self.isVisible = !self.isVisible;
        }];
    }
}

- (void)findBarsHandler {
    DLogCyan(@"");
}

- (void)findTaxisHandler {
    DLogCyan(@"");
}

- (void)configureDropDownToolBarView {
    DLogGreen(@"");
    self.toolbarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.toolbarView setBackgroundColor:kLtGreen];
    //    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    [self.toolbar setBackgroundColor:kLtGreen];
    
    //Make a custom UIButton for the navBar export button.
	self.findABarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width/2, self.toolbarView.frame.size.height)];
    //    findABarButton.frame = CGRectMake(0, 0, self.toolbar.frame.size.width/2,
    //    self.toolbar.frame.size.height); [findABarButton
    //    setBackgroundImage:[UIImage imageWithColor:kMedGreen
    //    andSize:findABarButton.frame.size] forState:UIControlStateHighlighted];
    //    [findABarButton setBackgroundImage:[UIImage imageWithColor:kMedGreen andSize:findABarButton.frame.size] forState:UIControlStateSelected];
	[self.findABarButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[self.findABarButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[self.findABarButton.titleLabel setTextColor:kMedGreen];
	[self.findABarButton setTitle:@"Find Bars" forState:UIControlStateNormal];
    
    @weakify(self)
    self.findABarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self findBarsHandler];
        return [RACSignal empty];
    }];
    
    
    
//	[self.findABarButton addTarget:self action:@selector(findBarsHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.findATaxiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.toolbarView.frame.size.width/2, 0, self.toolbarView.frame.size.width/2, self.toolbarView.frame.size.height)];
    //    findATaxiButton.frame = eight);
    //    [findATaxiButton setBackgroundImage:[UIImage imageWithColor:kMedGreen
    //    andSize:findATaxiButton.frame.size] forState:UIControlStateHighlighted];
    //    [findATaxiButton setBackgroundImage:[UIImage imageWithColor:kMedGreen andSize:findATaxiButton.frame.size] forState:UIControlStateSelected];
	[self.findATaxiButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[self.findATaxiButton.titleLabel setTextAlignment:NSTextAlignmentRight];
	[self.findATaxiButton.titleLabel setTextColor:kMedGreen];
	[self.findATaxiButton setTitle:@"Find Bars" forState:UIControlStateNormal];
//	[self.findATaxiButton addTarget:self action:@selector(findTaxisHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.findABarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self)
        [self findTaxisHandler];
        return [RACSignal empty];
    }];
    
//	//Assign it to the navBar.
//	//All we need to to now is change the text when appropriate.
//	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:findABarButton];
//	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:findATaxiButton];
//    
//	//add the buttons
//	self.toolbarView.items = ({@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                             leftButton,
//                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                             rightButton,
//                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];});
    
	self.toolbarView.userInteractionEnabled = YES;
    self.findABarButton.userInteractionEnabled = YES;
    self.findATaxiButton.userInteractionEnabled = YES;
	self.userInteractionEnabled = YES;
    
    [self.toolbarView addSubview:self.findABarButton];
    [self.toolbarView addSubview:self.findATaxiButton];
    
	[self addSubview:self.toolbarView];
    
}

@end
