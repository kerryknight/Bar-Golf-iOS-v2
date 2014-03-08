//
//  KKBarGolfToolbarViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/6/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarGolfToolbarViewController.h"

@interface KKBarGolfToolbarViewController ()

@end

@implementation KKBarGolfToolbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureToolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewOffsetDidChange:) name:kScrollViewOffsetDidChangeForParallax object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)configureToolbar {
    @weakify(self)
    //set touch down coloring to darker
    [self.findBarsButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    [self.findBarsButton setTitleColor:kDrkGreen forState:UIControlStateHighlighted];
    
    //set touch down coloring to darker
    [self.findTaxisButton setBackgroundImage:[UIImage imageWithColor:kMedGreen] forState:UIControlStateHighlighted];
    [self.findTaxisButton setTitleColor:kDrkGreen forState:UIControlStateHighlighted];
    
    self.findBarsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        //post a notification to let our menu view controller know we should
        //load the find a bar list view controller
        [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfShowBarsNotification object:nil];
        return [RACSignal empty];
    }];

    self.findTaxisButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        //post a notification to let our menu view controller know we should
        //load the find a taxi list view controller
        [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfShowTaxisNotification object:nil];
        return [RACSignal empty];
    }];
    
    //only allow scrolling/zooming if our map view is open fully
    [[[RACObserve(self.pullDownController, open) deliverOn:[RACScheduler mainThreadScheduler]] skip:1] subscribeNext:^(id x) {
//        @strongify(self)
        if ([x boolValue]) {
//            [self performSelector:@selector(setToolBarToOpenState) withObject:nil afterDelay:0.5];
        } else {
        }
    }];
}

- (void)setToolBarToOpenState {
    DLogOrange(@"");
    //set our toolbar to -64 to allow for parallaxing
    self.toolBarView.frame = CGRectMake(self.toolBarView.frame.origin.x,
                                        64,
                                        self.toolBarView.frame.size.width,
                                        self.toolBarView.frame.size.height);
}

- (void)scrollViewOffsetDidChange:(NSNotification *)notification {
    NSDictionary *userDict = [notification userInfo];
    NSNumber *previous = userDict[@"previousOffset"];
    NSNumber *next = userDict[@"nextOffset"];
    [self parallaxMapViewForOldOffset:previous andNewOffset:next];
}

- (void)parallaxMapViewForOldOffset:(NSNumber *)oldOffset andNewOffset:(NSNumber *)newOffset {
    float oldContentOffset = [oldOffset floatValue];
    float newContentOffset = [newOffset floatValue];
    float offsetDifference = 0;
    BOOL draggingDownwards = (newContentOffset < oldContentOffset) ? YES : NO;
    
    if (draggingDownwards) {
        offsetDifference = oldContentOffset - newContentOffset;
    } else {
        offsetDifference = newContentOffset - oldContentOffset;
    }
    
    CGRect toolBarFrame = self.toolBarView.frame;
    CGPoint toolBarOrigin = toolBarFrame.origin;
    
    CGSize toolbarSize = toolBarFrame.size;
    CGRect newToolBarFrame;
    
#warning this is still not working 100%; i think it is due to round of offset coming in b/c they're nsnumbers so i never get the 0.5 numbers and thus it sometimes can't tell if we're dragging up or down b/c the different between the next and previous offset rounds to 0.0
    // what direction did we drag?
    if (draggingDownwards) {
//        DLog(@"offsetDifference: on up: %0.f", offsetDifference);
        //only move down it if the current toolbar's y position is < 64
        if (toolBarOrigin.y < 64) {
            //Move the frame y accordingly
            newToolBarFrame = CGRectMake(toolBarOrigin.x, toolBarOrigin.y + (offsetDifference/5), toolbarSize.width, toolbarSize.height);
        } else {
            return;
        }
    } else {
        DLog(@"offsetDifference: on up: %0.f", offsetDifference);
        if (toolBarOrigin.y > 44) {
            //Move the frame y accordingly
            newToolBarFrame = CGRectMake(toolBarOrigin.x, toolBarOrigin.y - (offsetDifference/5), toolbarSize.width, toolbarSize.height);
        } else {
            return;
        }
    }
    
    self.toolBarView.frame = newToolBarFrame;
//    [self.toolBarView setNeedsLayout];
//    [self.toolBarView setNeedsDisplay];
}

@end
