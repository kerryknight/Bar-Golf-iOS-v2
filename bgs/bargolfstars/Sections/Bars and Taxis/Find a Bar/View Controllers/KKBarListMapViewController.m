//
//  KKBarListMapViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarListMapViewController.h"
#import "WildcardGestureRecognizer.h"
#import "KKNavigationController.h"
#import "FSVenue.h"
#import "KKBarAnnotation.h"
#import "KKBarDetailViewController.h"

@interface KKBarListMapViewController ()
@property (assign, nonatomic) float deltaLatFor1px;
@property (strong, nonatomic) CLLocation *originalLocation;
@property (nonatomic, strong) WildcardGestureRecognizer *tapInterceptor;
@property (assign, nonatomic) BOOL viewHasBeenConfigured;
@property (assign, nonatomic) BOOL shouldRefreshMap;
@end

@implementation KKBarListMapViewController

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
    self.shouldRefreshMap = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.viewHasBeenConfigured) {
        //wait until the view is about to appear to configure the view model so that
        //we don't prematurely display the "Bar Golf Wants to Use Your Location"
        //alert to the user when the app launches for the first time; this makes
        //it a more proactive thing on the user and a better experience
        [self configureViewModel];
        [self configureMap];
        
        //since we don't configure until the view is about to appear, set a flag
        //so we'll know to only configure once should we pop backwards in view hierarchy
        self.viewHasBeenConfigured = YES;
    }
    
    [self hideMapViewAnnotationCallouts];
    
    //add our notifications back each time we come into view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapOffsetDidChange:) name:kScrollViewOffsetDidChangeForParallax object:nil];
    
    //add observer for refresh notification we might get from the our custom nav bar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowMapRefresh) name:kBarGolfRefreshButtonNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //post a notification to hide our address bar as casting then telling the nav controller directly
    //seems to be a bit unreliable in doing so; need to double post here and on list view as this only
    //gets called when the map view is closed
    [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfHideUserAddressBarNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)configureViewModel {
    @weakify(self)
    
    //center our map on the user's location anytime it updates
    [[[KKBarListAndMapViewModel sharedViewModel].updatedUserLocationSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDictionary *location) {
        @strongify(self)
        if (self.shouldRefreshMap) {
            //animate our user's location view in from the nav bar
            KKNavigationController *navController = (KKNavigationController *)self.pullDownController.navigationController;
            [navController showUserAddressBarWithAddress:location[@"address"]];
            
            //then center our map on the user's location as well
            [self centerMapOnUserLocation:(CLLocation *)location[@"location"] withAnimation:NO];
        }
    }];
    
    //update our map's dropped pins anytime we receive a new list of bars
    [[[KKBarListAndMapViewModel sharedViewModel].updatedBarListSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSArray *bars) {
        @strongify(self)
        if (self.shouldRefreshMap) {
            [self addMapAnnotationsForBarList:bars];
            
            //set our flag to create a kind of caching mechanism; we'll only
            //override it in viewDidLoad or by hitting the refresh button
            self.shouldRefreshMap = NO;
        }
    }];
}

- (void)allowMapRefresh {
    self.shouldRefreshMap = YES;
}

- (void)hideMapViewAnnotationCallouts {
    for (id currentAnnotation in self.mapView.annotations) {
        if ([currentAnnotation isKindOfClass:[KKBarAnnotation class]]) {
            [self.mapView deselectAnnotation:currentAnnotation animated:YES];
        } 
    }
}

- (void)mapOffsetDidChange:(NSNotification *)notification {
    NSDictionary *userDict = [notification userInfo];
    NSNumber *previous = userDict[@"previousOffset"];
    NSNumber *next = userDict[@"nextOffset"];
    [self parallaxMapViewForOldOffset:previous andNewOffset:next];
}

- (float)deltaLatFor1px {
    if (!_deltaLatFor1px) {
        // We compute how much latitude represent 1point.  so that we know how much
        // the center coordinate of the map should be moved
        // when being dragged.
        CLLocationCoordinate2D referencePosition = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
        CLLocationCoordinate2D referencePosition2 = [self.mapView convertPoint:CGPointMake(0, 100) toCoordinateFromView:self.mapView];
        _deltaLatFor1px = (referencePosition2.latitude - referencePosition.latitude)/100;
    }
    
    return _deltaLatFor1px;
}

- (void)parallaxMapViewForOldOffset:(NSNumber *)oldOffset andNewOffset:(NSNumber *)newOffset {
    double oldContentOffset = [oldOffset floatValue]/2;
    double newContentOffset = [newOffset floatValue]/2;
    double offsetDifference = 0;
    BOOL draggingDownwards = (newContentOffset < oldContentOffset) ? YES : NO;
    
    if (draggingDownwards) {
        offsetDifference = oldContentOffset - newContentOffset;
    } else {
        offsetDifference = newContentOffset - oldContentOffset;
    }
    
    CLLocationCoordinate2D mapCenter = self.mapView.centerCoordinate;
    CLLocationCoordinate2D newCenter;
    //we moved y pixels down, how much latitude is that ?
    double deltaLat = offsetDifference * self.deltaLatFor1px;
    
    // what direction did we drag?
    if (draggingDownwards) {
        //Move the center coordinate accordingly
        newCenter = CLLocationCoordinate2DMake(mapCenter.latitude - deltaLat, mapCenter.longitude);
    } else {
        newCenter = CLLocationCoordinate2DMake(mapCenter.latitude + deltaLat, mapCenter.longitude);
    }
    
    self.mapView.centerCoordinate = newCenter;
}

- (void)configureMap {
    @weakify(self)
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    //add the tap gesture recognizer that opens the map fully
    self.tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    self.tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        @strongify(self)
        //only open if we're aren't already open
        if (!self.pullDownController.open) {
            [self.pullDownController setOpen:YES animated:YES];
        }
    };
    [self.mapView addGestureRecognizer:self.tapInterceptor];
    
    //bind to the view model's userLocation which will update our map
    [RACObserve([KKBarListAndMapViewModel sharedViewModel], userLocation) subscribeNext:^(CLLocation *location) {
        @strongify(self)
        if (self.shouldRefreshMap) {
            [self centerMapOnUserLocation:location withAnimation:NO];
        }
    }];
    
    //only allow scrolling/zooming if our map view is open fully
    [[[RACObserve(self.pullDownController, open) deliverOn:[RACScheduler mainThreadScheduler]] skip:1] subscribeNext:^(id x) {
        @strongify(self)
        if (![x boolValue]) {
            [self.mapView setZoomEnabled:NO];
            [self.mapView setScrollEnabled:NO];
            [self performSelector:@selector(resetMapToStartingLocation:) withObject:self.originalLocation afterDelay:0.75];
            
            //only enable map tap gesture to open when the map is in closed state
            self.tapInterceptor.enabled = YES;
            
        } else {
            [self.mapView setZoomEnabled:YES];
            [self.mapView setScrollEnabled:YES];
            [self.mapView setNeedsLayout];
            [self performSelector:@selector(zoomMapViewToFitAnnotationsWithUserLocation:) withObject:@YES afterDelay:0.5];
            
            //only enable map tap gesture to open when the map is in closed state
            self.tapInterceptor.enabled = NO;
        }
    }];
}

- (void)resetMapToStartingLocation:(CLLocation *)location {
    @weakify(self)
    //this is definitely getting kinda hackish trying to synchronize map
    //animations that don't have completion callbacks here, but it works for
    //the most part; not perfectly smooth but workable
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            @strongify(self)
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        } completion:^(BOOL finished) {
            @strongify(self)
            [self setMapRegionForLocation:location withAnimation:YES];
        }];
    });
}

- (void)setMapRegionForLocation:(CLLocation *)location withAnimation:(BOOL)animation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), 3000, 3000);
	[self.mapView setRegion:region animated:animation];
}

- (void)centerMapOnUserLocation:(CLLocation *)location withAnimation:(BOOL)animation {
    [self.mapView setCenterCoordinate:location.coordinate animated:NO];

    [self setMapRegionForLocation:location withAnimation:animation];
    
    //since we initially show the map in a smaller view, we need to center but
    //offset vertically slightly
    CGPoint fakecenter = CGPointMake(self.view.frame.size.width/2, 400);
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:fakecenter toCoordinateFromView:self.mapView];
    
    //keep track of originally set offset location so we can animate back to it if user opens map up and moves around in it
    self.originalLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:location.altitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy course:location.course speed:location.speed timestamp:location.timestamp];
    
    if (location) {
        //only animate to position if location isn't null
        [self resetMapToStartingLocation:self.originalLocation];
    }
}

- (void)zoomMapViewToFitAnnotationsWithUserLocation:(BOOL)fitToUserLocation {
    if ([self.mapView.annotations count] > 1) {
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            if (fitToUserLocation) {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.2, 0.2);
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
            } else {
                if (![annotation isKindOfClass:[MKUserLocation class]] ) {
                    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.2, 0.2);
                    if (MKMapRectIsNull(zoomRect)) {
                        zoomRect = pointRect;
                    } else {
                        zoomRect = MKMapRectUnion(zoomRect, pointRect);
                    }
                }
            }
        }
        
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }
}

- (void)addMapAnnotationsForBarList:(NSArray *)list {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //add each annotation one by one after setting its index
    for (FSVenue *venue in list) {
        KKBarAnnotation *annotation = [[KKBarAnnotation alloc] init];
        [annotation setTitle:venue.title];
        [annotation setSubtitle:venue.subtitle];
        [annotation setIndex:(int)[list indexOfObject:venue]];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([venue.latitude doubleValue], [venue.longitude doubleValue]);
        [annotation setCoordinate:coordinate];
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.draggable = NO;
        
    } else {
        annotationView.annotation = annotation;
    }
    
    UIImage *leftImage = [UIImage imageNamed:@"bgsLogoSmall"];
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:leftImage];
    leftIconView.frame = CGRectMake(0, 0, 80, 80);
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.leftCalloutAccessoryView = leftIconView;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    KKBarAnnotation *annotation = (KKBarAnnotation *)pin.annotation;
    int indexForVenue = annotation.index;
    NSArray *tempArray = (NSArray *)[KKBarListAndMapViewModel sharedViewModel].barList;
    FSVenue *bar = (FSVenue *)[tempArray objectAtIndex:indexForVenue];
    KKBarDetailViewController *detailViewController = [[KKBarDetailViewController alloc] init];
    detailViewController.viewModel.bar = bar;
    [self.navigationController pushViewController:detailViewController animated:YES];
}
@end
