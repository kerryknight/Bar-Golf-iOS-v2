//
//  FSVenue.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/13/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "FSVenue.h"

@implementation FSVenue

#define METERS_TO_FEET  3.2808399
#define METERS_TO_MILES 0.000621371192
#define METERS_CUTOFF   1000
#define FEET_CUTOFF     3281
#define FEET_IN_MILES   5280

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"venueId": @"id",
             @"title": @"name",
             @"phone": @"contact.phone",
             @"formattedPhone": @"contact.formattedPhone",
             @"subtitle": @"location.address",
             @"latitude": @"location.lat",
             @"longitude": @"location.lng",
             @"distance": @"location.distance",
             @"zip": @"location.postalCode",
             @"cc": @"location.cc",
             @"city": @"location.city",
             @"state": @"location.state",
             @"country": @"location.country",
             @"url": @"url",
             @"totalCheckins": @"stats.checkinsCount",
             @"totalUsers": @"stats.usersCount",
             @"usersHereNow": @"hereNow.count",
             @"country": @"location.cc",
             @"imageURLSmall": @"photo.standardEmailPhotoUrl"};
}

- (CLLocationCoordinate2D)coordinate {
    if (!_coordinate.latitude) {
        _coordinate = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    }
    return _coordinate;
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSString *)convertDistanceToString {
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    
    NSString *format;
    double distanceForConversion = self.distance;
    
    if (isMetric) {
        if (distanceForConversion < METERS_CUTOFF) {
            format = @"%@m away";
        } else {
            format = @"%@km away";
            distanceForConversion = distanceForConversion / 1000;
        }
    } else {
        distanceForConversion = distanceForConversion * METERS_TO_FEET;
        if (distanceForConversion < FEET_CUTOFF) {
            format = @"%@ft away";
        } else {
            format = @"%@mi away";
            distanceForConversion = distanceForConversion / FEET_IN_MILES;
        }
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    return [NSString stringWithFormat:format, [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distanceForConversion]]];
}


@end
