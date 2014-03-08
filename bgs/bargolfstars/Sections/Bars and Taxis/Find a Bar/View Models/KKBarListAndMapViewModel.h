//
//  KKBarListAndMapViewModel.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "RVMViewModel.h"

@interface KKBarListAndMapViewModel : RVMViewModel
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) RACSignal *updatedBarListSignal;
@end
