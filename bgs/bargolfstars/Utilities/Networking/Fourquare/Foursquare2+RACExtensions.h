//
//  Foursquare2+RACExtensions.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/12/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "Foursquare2.h"

@class RACSignal;
@interface Foursquare2 (RACExtensions)

+ (RACSignal *)rac_queryFourquareForBarsNearLocation:(CLLocation *)location forSearchTerm:(NSString *)search;

@end
