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
@property (strong, nonatomic, readwrite) RACSignal *frontViewOffsetSignal;
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
    self.frontViewOffsetSignal = [[RACSubject subject] setNameWithFormat:@"KKBarListAndMapViewModel frontViewOffsetSignal"];
    
    [self createRACBindings];
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
- (void)createRACBindings {
    //bind to our front view's scrolling offset so that anytime it changes, we
    //can fire a signal that let's our map view know so it can create a slight
    //parallax effect on it's own
    [RACObserve(self, frontViewOffset) subscribeNext:^(NSValue *offset) {
        [(RACSubject *)self.frontViewOffsetSignal sendNext:offset];
    }];
}

- (void)getUserLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)getBarsForLocation:(CLLocation *)location {
//    DLogBlue(@"location: %@", location);
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
