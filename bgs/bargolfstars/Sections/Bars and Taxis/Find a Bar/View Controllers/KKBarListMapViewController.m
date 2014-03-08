//
//  KKBarListMapViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarListMapViewController.h"

@interface KKBarListMapViewController ()
@property (assign, nonatomic) float deltaLatFor1px;
@property (assign, nonatomic) CLLocationCoordinate2D originalCoordinate;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //wait until the view is about to appear to configure the view model so that
    //we don't prematurely display the "Bar Golf Wants to Use Your Location"
    //alert to the user when the app launches for the first time; this makes
    //it a more proactive thing on the user and a better experience
    [self configureViewModel];
    [self configureMap];
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
    [[[KKBarListAndMapViewModel sharedViewModel].updatedUserLocationSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(CLLocation *location) {
        @strongify(self)
        [self centerMapOnUserLocation:location withAnimation:NO];
    }];
    
    //update our map's dropped pins anytime we receive a new list of bars
    [[[KKBarListAndMapViewModel sharedViewModel].updatedBarListSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSArray *bars) {
        [self addMapAnnotationsForBarList:bars];
    }];
    
    //bind our to our view model's offset property so we can add a
    //parallax effect to our map view and re-center it as the view opens
    [[[KKBarListAndMapViewModel sharedViewModel].frontViewOffsetSignal combinePreviousWithStart:@0 reduce:^(NSNumber *previous, NSNumber *next) {
        @strongify(self)
        [self parallaxMapViewForOldOffset:previous andNewOffset:next];
        return [RACSignal empty];
    }] subscribeNext:^(id x) {
        //no op
    }];
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
    
    //bind to the view model's userLocation which will update our map
    [RACObserve([KKBarListAndMapViewModel sharedViewModel], userLocation) subscribeNext:^(CLLocation *location) {
        @strongify(self)
        [self centerMapOnUserLocation:location withAnimation:NO];
    }];
    
    self.mapView.showsUserLocation = YES;
    
    //only allow scrolling/zooming if our map view is open fully
    [[[RACObserve(self.pullDownController, open) deliverOn:[RACScheduler mainThreadScheduler]] skip:1] subscribeNext:^(id x) {
        @strongify(self)
        if (![x boolValue]) {
            [self.mapView setZoomEnabled:NO];
            [self.mapView setScrollEnabled:NO];
            [self performSelector:@selector(resetMapToStartingPosition) withObject:nil afterDelay:0.5];
        } else {
            [self.mapView setZoomEnabled:YES];
            [self.mapView setScrollEnabled:YES];
            [self.mapView setNeedsLayout];
        }
    }];
}

- (void)resetMapToStartingPosition {
    @weakify(self)
    //this is definitely getting kinda hackish trying to synchronize map
    //animations that don't have completion callbacks here, but it works for
    //the most part; not perfectly smooth but workable
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            @strongify(self)
            [self setMapRegionForLocation:[KKBarListAndMapViewModel sharedViewModel].userLocation withAnimation:NO];
        } completion:^(BOOL finished) {
            @strongify(self)
            [self.mapView setCenterCoordinate:self.originalCoordinate animated:YES];
        }];
    });
}

- (void)setMapRegionForLocation:(CLLocation *)location withAnimation:(BOOL)animation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), 3000, 3000);
	[self.mapView setRegion:region animated:animation];
}

- (void)centerMapOnUserLocation:(CLLocation *)location withAnimation:(BOOL)animation {
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];

    [self setMapRegionForLocation:location withAnimation:animation];
    
    //since we initially show the map in a smaller view, we need to center but
    //offset vertically slightly
    CGPoint fakecenter = CGPointMake(self.view.frame.size.width/2, 470);
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:fakecenter toCoordinateFromView:self.mapView];
    self.originalCoordinate = coordinate;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    //attempt to zoom around the pins; if there are none, nothing will happen
    [self zoomMapViewToFitAnnotationsWithUserLocation:location];
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
    DLogOrange(@"bars: %@", list);
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    DLogOrange(@"");
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (!annotationView) {
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        
    } else {
        annotationView.annotation = annotation;
    }
    
//    StoreAnnotation *ann = (StoreAnnotation *)annotation;
    
//    BOOL isOpen = ann.isOpen;
    
//    [annotationView setImage:[UIImage imageNamed: isOpen ? @"pinOn" : @"pinOff"]];
    
//    UIImage *leftImage = [UIImage circleImageWithSize:32 color: isOpen ? self.navigationController.view.tintColor : [UIColor lightGrayColor]];
//    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:leftImage];
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    annotationView.leftCalloutAccessoryView = leftIconView;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    DLogOrange(@"");
//    __weak typeof(self) weakSelf = self;
//    [self closeMapViewWithCompletion:^{
//        
//        typeof(self) strongSelf = weakSelf;
//        StoreAnnotation *annotation = (StoreAnnotation *)pin.annotation;
//        Store *store = [self.stores objectAtIndex:annotation.index];
//        DetailViewController *detailViewController = [[DetailViewController alloc] init];
//        [detailViewController setStore:store];
//        [strongSelf.navigationController pushViewController:detailViewController animated:YES];
//        
//    }];
}
@end
