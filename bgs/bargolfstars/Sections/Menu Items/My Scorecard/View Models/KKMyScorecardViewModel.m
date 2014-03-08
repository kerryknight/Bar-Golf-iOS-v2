//
//  KKMyScorecardViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/8/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMyScorecardViewModel.h"

@implementation KKMyScorecardViewModel

+ (KKMyScorecardViewModel *)sharedViewModel {
	static KKMyScorecardViewModel * _sharedViewModel = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedViewModel = [[KKMyScorecardViewModel alloc] init];
	});
    
	return _sharedViewModel;
}

@end
