//
//  Bar.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@interface Bar : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *address1;
@property (nonatomic, copy, readonly) NSString *address2;
@property (nonatomic, copy, readonly) NSString *features;
@property (nonatomic, copy, readonly) NSNumber *ID;
@property (nonatomic, copy, readonly) NSNumber *lat;
@property (nonatomic, copy, readonly) NSNumber *lng;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *open24HrsToday;
@property (nonatomic, copy, readonly) NSNumber *openNow;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSString *store;
@property (nonatomic, copy, readwrite) NSNumber *distance;

@end
