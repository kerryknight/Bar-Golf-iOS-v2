//
//  KKParallaxSignalViewModel.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/8/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKParallaxSignalViewModel.h"

@interface KKParallaxSignalViewModel()
@end

@implementation KKParallaxSignalViewModel

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    [self createRACBindings];
    
    return self;
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)createRACBindings {
    //bind to our front view's scrolling offset so that anytime it changes, we
    //can fire a signal that let's our map view know so it can create a slight
    //parallax effect on it's own
    [[RACObserve(self, frontViewOffset) combinePreviousWithStart:@0 reduce:^(NSNumber *previous, NSNumber *next) {
        NSDictionary *userInfo = @{@"previousOffset": previous, @"nextOffset": next};
        [[NSNotificationCenter defaultCenter] postNotificationName:kScrollViewOffsetDidChangeForParallax object:nil userInfo:userInfo];
        return [RACSignal empty];
    }] subscribeNext:^(id x) {
        //no op
    }];
}

@end