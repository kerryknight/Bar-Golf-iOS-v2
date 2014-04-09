//
//  KKBarDetailViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 4/8/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarDetailViewController.h"
#import "KKBarAnnotation.h"

@interface KKBarDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *address1Label;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dialPhoneNumber:(id)sender;
@end

@implementation KKBarDetailViewController

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
    [self configureUI];
    [self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (KKBarDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KKBarDetailViewModel alloc] init];
    }
    
    return _viewModel;
}

#pragma mark - Private Methods
- (void)configureViewModel {
    self.viewModel.active = YES;
}

- (void)configureUI {
    //populate all our label text
    self.titleLabel.text = self.viewModel.bar.title ? self.viewModel.bar.title : @"";
    self.address1Label.text = self.viewModel.bar.subtitle ? self.viewModel.bar.subtitle : @"";
    self.address2Label.text = [NSString stringWithFormat:@"%@, %@ %@",
                               self.viewModel.bar.city ? self.viewModel.bar.city : @"",
                               self.viewModel.bar.state ? self.viewModel.bar.state : @"",
                               self.viewModel.bar.zip ? self.viewModel.bar.zip : @""];
    self.phoneLabel.text = self.viewModel.bar.formattedPhone ? self.viewModel.bar.formattedPhone : @"";
    self.distanceLabel.text = self.viewModel.bar ? [(FSVenue *)self.viewModel.bar convertDistanceToString] : @"";
    
    //add annotation for selected bar to map and zoom to it
    [self addBarAnnotationToMap];
    [self zoomToFitMapAnnotations:self.mapView];
}

- (void)configureTableView {
    
}

#pragma mark - IBActions
- (IBAction)dialPhoneNumber:(id)sender {
    if (self.phoneLabel.text.length > 0) {
        NSString *numberToDial = [NSString stringWithFormat:@"tel://%@", self.viewModel.bar.formattedPhone];
        numberToDial = [numberToDial stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberToDial = [numberToDial stringByReplacingOccurrencesOfString:@"-" withString:@""];
        numberToDial = [numberToDial stringByReplacingOccurrencesOfString:@"(" withString:@""];
        numberToDial = [numberToDial stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSURL *url = [[NSURL alloc] initWithString: numberToDial];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Map View Stuff
- (void)addBarAnnotationToMap {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    KKBarAnnotation *annotation = [[KKBarAnnotation alloc] init];
    [annotation setTitle:self.viewModel.bar.title];
    [annotation setSubtitle:self.viewModel.bar.subtitle];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.viewModel.bar.latitude doubleValue], [self.viewModel.bar.longitude doubleValue]);
    [annotation setCoordinate:coordinate];
    [self.mapView addAnnotation:annotation];
}

- (void)zoomToFitMapAnnotations:(MKMapView*)mapViewZoom {
    if([mapViewZoom.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (KKBarAnnotation *annotation in mapViewZoom.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) + 0.0003; //offset zoom a bit to see in mapview
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude);
    region.span.latitudeDelta = 0.0025;
    region.span.longitudeDelta = 0.0025;
    region = [mapViewZoom regionThatFits:region];
    [mapViewZoom setRegion:region animated:YES];
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
    
    return annotationView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
	}
    
	cell.textLabel.text = [NSString stringWithFormat:@"Cell: %li", (long)indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = kMedGray;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = kDrkGray;
    
	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
