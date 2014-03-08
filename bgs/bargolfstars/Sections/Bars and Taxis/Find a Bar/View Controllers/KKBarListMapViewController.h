//
//  KKBarListMapViewController.h
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KKBarListAndMapViewModel.h"

@interface KKBarListMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (unsafe_unretained, nonatomic, readonly) BOOL mapViewIsOpen;
@end
