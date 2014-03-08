//
//  KKBarListMapViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarListMapViewController.h"

@interface KKBarListMapViewController ()

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
    self.viewModel = [[KKBarListAndMapViewModel alloc] init];
    self.viewModel.active = YES;
    
    //subscribe to our viewModel's signal
    [[self.viewModel.updatedBarListSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSArray *bars) {
        DLogOrange(@"bars: %@", bars);
    }];
}

- (void)configureMap {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.viewModel.location.coordinate.latitude, self.viewModel.location.coordinate.longitude), 2000, 2000);
	[self.mapView setRegion:region animated:NO];
    
//    for (Store *store in self.stores) {
//        
//        StoreAnnotation *annotation = [[StoreAnnotation alloc] init];
//        [annotation setTitle:store.name];
//        [annotation setSubtitle:store.address1];
//        [annotation setIsOpen:[store.openNow boolValue]];
//        [annotation setIndex:[self.stores indexOfObject:store]];
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([store.lat doubleValue], [store.lng doubleValue]);
//        [annotation setCoordinate:coordinate];
//        [self.mapView addAnnotation:annotation];
//        
//    }
//    
//    self._tapInterceptor = [[WildcardGestureRecognizer alloc] init];
//    __weak WildcardGestureRecognizer *tapInterceptor = self._tapInterceptor;
//    __weak typeof(self) weakSelf = self;
//    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
//        typeof(self) strongSelf = weakSelf;
//        [strongSelf.mapView removeGestureRecognizer:tapInterceptor];
//        strongSelf._tapInterceptor = nil;
//        [strongSelf openMapView];
//    };
//    [self.mapView addGestureRecognizer:tapInterceptor];
//    
//    if(![self.stores count]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Empty results", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    
//    [self zoomMapViewToFitAnnotationsWithUserLocation:self.includeUserLocation];
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
