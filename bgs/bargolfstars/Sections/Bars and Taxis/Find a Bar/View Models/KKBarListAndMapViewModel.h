//
//  KKBarListAndMapViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "RVMViewModel.h"

@interface KKBarListAndMapViewModel : RVMViewModel
@property (strong, nonatomic, readonly) CLLocation *userLocation;
@property (assign, nonatomic) NSInteger frontViewOffset;
@property (strong, nonatomic, readonly) RACSignal *updatedUserLocationSignal;
@property (strong, nonatomic, readonly) RACSignal *updatedBarListSignal;
@property (strong, nonatomic, readonly) RACSignal *sendErrorSignal;
@property (strong, nonatomic, readonly) RACSignal *frontViewOffsetSignal;

@end
