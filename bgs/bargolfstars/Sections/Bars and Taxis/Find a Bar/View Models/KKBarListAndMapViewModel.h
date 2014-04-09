//
//  KKBarListAndMapViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "RVMViewModel.h"
#import "KKParallaxSignalViewModel.h"

@interface KKBarListAndMapViewModel : KKParallaxSignalViewModel
@property (strong, nonatomic, readonly) CLLocation *userLocation;
@property (strong, nonatomic, readonly) RACSignal *updatedUserLocationSignal;
@property (strong, nonatomic, readonly) RACSignal *updatedBarListSignal;
@property (strong, nonatomic, readonly) RACSignal *sendErrorSignal;
@property (copy, nonatomic, readonly) NSArray *barList;

+ (KKBarListAndMapViewModel *)sharedViewModel;
- (void)getUserLocation;

@end
