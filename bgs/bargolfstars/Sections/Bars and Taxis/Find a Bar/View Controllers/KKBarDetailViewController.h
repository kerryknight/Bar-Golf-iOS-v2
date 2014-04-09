//
//  KKBarDetailViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 4/8/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBarDetailViewModel.h"
@import MapKit;

@interface KKBarDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) KKBarDetailViewModel *viewModel;
@end
