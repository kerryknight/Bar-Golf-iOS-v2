//
//  Bar.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "Bar.h"

@implementation Bar

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"address1" : @"Addr1",
             @"address2" : @"Addr3",
             @"features" : @"Features",
             @"ID": @"Id",
             @"lat" : @"Lat",
             @"lng" : @"Long",
             @"name" : @"Name",
             @"open24HrsToday" : @"Open24HrsToday",
             @"openNow" : @"OpenNow",
             @"phone" : @"Phone",
             @"store" : @"Store"
             };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, ID: %@, name: %@>", NSStringFromClass([self class]), self, self.ID, self.name];
}

@end
