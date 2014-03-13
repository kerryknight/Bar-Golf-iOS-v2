//
//  KKBarListAndMapViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarListAndMapViewModel.h"
@import CoreLocation;

@interface KKBarListAndMapViewModel() <CLLocationManagerDelegate>
@property (strong, nonatomic, readwrite) CLLocation *userLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic, readwrite) RACSignal *updatedBarListSignal;
@property (strong, nonatomic, readwrite) RACSignal *updatedUserLocationSignal;
@property (strong, nonatomic, readwrite) RACSignal *sendErrorSignal;
@end

@implementation KKBarListAndMapViewModel

#pragma mark - Life Cycle and Lazy Instantiation
+ (KKBarListAndMapViewModel *)sharedViewModel {
	static KKBarListAndMapViewModel * _sharedViewModel = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedViewModel = [[KKBarListAndMapViewModel alloc] init];
	});
    
	return _sharedViewModel;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    self.updatedBarListSignal = [[RACSubject subject] setNameWithFormat:@"KKBarListAndMapViewModel updatedBarListSignal"];
    self.updatedUserLocationSignal = [[RACSubject subject] setNameWithFormat:@"KKBarListAndMapViewModel updatedUserLocationSignal"];
    self.sendErrorSignal = [[RACSubject subject] setNameWithFormat:@"KKBarListAndMapViewModel sendErrorSignal"];
    
    [self getUserLocation];
    
    return self;
}

- (CLLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[CLLocation alloc] init];
    }
    return _userLocation;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        /* Notify changes when device has moved x meters.
         * Default value is kCLDistanceFilterNone: all movements are reported.
         */
        _locationManager.distanceFilter = 50.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)getUserLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)getBarsForLocation:(CLLocation *)location {
    // Use Foursquare2 library and map results to convert into an array of Mantle objects
    [[[Foursquare2 rac_queryFourquareForBarsNearLocation:location forSearchTerm:nil]
    map:^id(NSDictionary *json) {
        // Build a sequence from the list of raw JSON
        RACSequence *list = [json[@"response"][@"venues"] rac_sequence];
        
        // Use a function to map results from JSON to Mantle objects
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[FSVenue class] fromJSONDictionary:item error:nil];
        }] array];
    }] subscribeNext:^(NSArray *barList) {
        //send our signal so our map view can know to update itself
        [(RACSubject *)self.updatedBarListSignal sendNext:barList];
        
    } error:^(NSError *error) {
        DLogRed(@"error: %@", error);
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.userLocation = [locations lastObject];
    
    //send our signal so our map view can know to update itself
    [(RACSubject *)self.updatedUserLocationSignal sendNext:self.userLocation];
    
    //query foursquare for nearby bar list whenever our location updates
    [self getBarsForLocation:self.userLocation];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLogRed(@"location error: %@", error);
    NSString *loc = [NSString stringWithFormat:@"Error: "];
    NSString *err = [NSString stringWithFormat:@"%@%@", loc, NSLocalizedString([error localizedDescription], nil)];
    [(RACSubject *)self.sendErrorSignal sendNext:err];
}


@end
