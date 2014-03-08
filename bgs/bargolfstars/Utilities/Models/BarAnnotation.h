//
//  BarAnnotation.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface BarAnnotation : NSObject <MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSNumber *barDistance;
@property (copy, nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) int index;

@end


