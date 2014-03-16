//
//  Foursquare2RACCallbacks.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/12/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "Foursquare2RACCallbacks.h"

NSString * const Fourquare2RACErrorDomain = @"Fourquare2RACErrorDomain";
const NSUInteger Fourquare2RACUnknownError = 0;

static NSError *Fourquare2RACNormalizeError(NSError *error) {
	if (error == nil) return [NSError errorWithDomain:Fourquare2RACErrorDomain code:Fourquare2RACUnknownError userInfo:nil];
    
	if (error.userInfo[@"error"] == nil) return error;
    
	NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
	userInfo[NSLocalizedDescriptionKey] = userInfo[@"error"];
	return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
}

Foursquare2Callback Foursquare2RACCallback(id<RACSubscriber> subscriber) {
	return ^(BOOL success, id result) {
        
		if (success) {
			[subscriber sendNext:result];
			[subscriber sendCompleted];
		} else {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Foursquare nearby bars query failed." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:Fourquare2RACErrorDomain code:Fourquare2RACUnknownError userInfo:details];
			[subscriber sendError:Fourquare2RACNormalizeError(error)];
		}
	};
}

