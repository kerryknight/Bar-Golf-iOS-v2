//
//  FSVenue.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/13/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "FSVenue.h"

@implementation FSVenue

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
             @"country": @"location.cc",
             @"country": @"location.cc",
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


@end
