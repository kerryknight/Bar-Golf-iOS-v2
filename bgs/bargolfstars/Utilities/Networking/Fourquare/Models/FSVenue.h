//
//  FSVenue.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/13/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "MTLModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FSVenue : MTLModel <MTLJSONSerializing, MKAnnotation>

@property (copy, nonatomic) NSString *venueId;
@property (copy, nonatomic) NSString *title;//actually the FS 'name' but renamed for MKAnnotation
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *formattedPhone;
@property (copy, nonatomic) NSString *subtitle;//actually the FS 'address' but renamed for MKAnnotation
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSNumber *distance;
@property (copy, nonatomic) NSString *zip;
@property (copy, nonatomic) NSString *cc;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSURL *url;
@property (copy, nonatomic) NSNumber *totalCheckins;
@property (copy, nonatomic) NSNumber *totalUsers;
@property (copy, nonatomic) NSNumber *usersHereNow;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
