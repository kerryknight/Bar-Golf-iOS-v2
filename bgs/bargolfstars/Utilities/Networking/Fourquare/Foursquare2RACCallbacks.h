//
//  Foursquare2RACCallbacks.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/12/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RACSubscriber;

Foursquare2Callback Foursquare2RACCallback(id<RACSubscriber> subscriber);
