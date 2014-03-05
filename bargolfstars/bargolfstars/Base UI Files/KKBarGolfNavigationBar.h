//
//  KKBarGolfNavigationBar.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/5/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBarGolfNavigationBar : UINavigationBar

@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *findABarButton;
@property (strong, nonatomic) UIButton *findATaxiButton;

- (void)configureDropDownToolBarView;
- (void)toggleToolbar;

@end
