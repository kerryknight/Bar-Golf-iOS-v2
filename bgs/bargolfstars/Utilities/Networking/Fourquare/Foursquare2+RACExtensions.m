//
//  Foursquare2+RACExtensions.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/12/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "Foursquare2+RACExtensions.h"
#import "Foursquare2RACCallbacks.h"

@implementation Foursquare2 (RACExtensions)

#pragma mark - Public Methods
+ (RACSignal *)rac_queryFourquareForBarsNearLocation:(CLLocation *)location forSearchTerm:(NSString *)search {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *searchTerm = search ? search : nil;
        [self venueSearchNearByLatitude:@(location.coordinate.latitude)
                                     longitude:@(location.coordinate.longitude)
                                         query:searchTerm
                                         limit:@(20)
                                        intent:intentBrowse
                                        radius:@(3200)
                                    categoryId:[self getBarCategoryIDs]
                                      callback:Foursquare2RACCallback(subscriber)];
        return nil;
    }];
}

#pragma mark - Private Methods
//"4bf58dd8d48988d1e8931735" //piano bar
//"4bf58dd8d48988d1e3931735" //pool hall knightka - this was pulling a UNCW dorm listing
//"50327c8591d4c4b30a586d5d" //brewery
//"4e0e22f5a56208c4ea9a85a0" //distillery
//"4bf58dd8d48988d155941735" //gastro pub
//"4d4b7105d754a06376d81259" //nightlife spot //includes all below bar types (and others)
//"4bf58dd8d48988d116941735" //bar
//"4bf58dd8d48988d117941735" //beer garden
//"4bf58dd8d48988d11e941735" //cocktail bar
//"4bf58dd8d48988d118941735" //dive bar
//"4bf58dd8d48988d1d8941735" //gay bar
//"4bf58dd8d48988d1d5941735" //hotel bar
//"4bf58dd8d48988d120941735" //karaoke bar
//"4bf58dd8d48988d121941735" //lounge
//"4bf58dd8d48988d11f941735" //nightclub
//"4bf58dd8d48988d11b941735" //pub
//"4bf58dd8d48988d1d4941735" //speakeasy
//"4bf58dd8d48988d11d941735" //sportsbar
//"4bf58dd8d48988d122941735" //whiskey bar
//"4bf58dd8d48988d123941735" //wine bar
//"4bf58dd8d48988d14c941735" //wings joint, like WWC
//"4bf58dd8d48988d1db931735" //tapas restuarant like 1900
+ (NSString *)getBarCategoryIDs {
	return [NSString stringWithFormat:
           @"4bf58dd8d48988d1e8931735,4bf58dd8d48988d1e3931735,50327c8591d4c4b30a586d5d,4e0e22f5a56208c4ea9a85a0,4bf58dd8d48988d155941735,4d4b7105d754a06376d81259,4bf58dd8d48988d116941735,4bf58dd8d48988d117941735,4bf58dd8d48988d11e941735,4bf58dd8d48988d118941735,4bf58dd8d48988d1d8941735,4bf58dd8d48988d1d5941735,4bf58dd8d48988d120941735,4bf58dd8d48988d121941735,4bf58dd8d48988d11f941735,4bf58dd8d48988d11b941735,4bf58dd8d48988d1d4941735,4bf58dd8d48988d11d941735,4bf58dd8d48988d122941735,4bf58dd8d48988d123941735,4bf58dd8d48988d14c941735,4bf58dd8d48988d1db931735"];
}

@end
