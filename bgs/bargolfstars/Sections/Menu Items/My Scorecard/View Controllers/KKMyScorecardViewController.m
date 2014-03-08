//
//  KKMyScorecardViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMyScorecardViewController.h"

static NSString *const kScorecardViewControllerCellReuseId = @"KKScorecardCell";

@interface KKMyScorecardViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KKMyScorecardViewController

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //have to set our custom nav controller's title by hand each time by
    //casting to it for forward and backward navigation compatibility
    KKNavigationController *navController = (KKNavigationController *)self.navigationController;
    [navController setTitleLabelText:@"My Scorecard"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)configureViewModel {
    //bind our view model to our tableview content offset so we can add a
    //parallax effect to our map view and recenter it was the view opens
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(NSValue *value) {
        NSInteger y = floor(self.tableView.contentOffset.y);
        [KKMyScorecardViewModel sharedViewModel].frontViewOffset = y;
    }];
}

- (void)configureUI {
    self.tableView.backgroundColor = kMedGray;
    self.tableView.delegate = self;
    self.view.backgroundColor = kMedGray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScorecardViewControllerCellReuseId];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kScorecardViewControllerCellReuseId];
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

#pragma mark - ScrollView Delegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    DLogBlue(@"");
//    double contentOffset = scrollView.contentOffset.y;
//    _lastDragOffset = contentOffset;
//    
//    if(contentOffset < kKIPTRTableViewContentInsetX*-1)
//    {
//        [self zoomMapToFitAnnotations];
//        [_mapView setUserInteractionEnabled:YES];
//        
//        [UIView animateWithDuration:kKIPTRAnimationDuration
//                         animations:^()
//         {
//             [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.bounds.size.height,0,0,0)];
//             [self.tableView scrollsToTop];
//         }];
//    }
//    else if (contentOffset >= kKIPTRTableViewContentInsetX*-1)
//    {
//        [_mapView setUserInteractionEnabled:NO];
//        
//        [UIView animateWithDuration:kKIPTRAnimationDuration
//                         animations:^()
//         {
//             [self.tableView setContentInset:UIEdgeInsetsMake(kKIPTRTableViewContentInsetX,0,0,0)];
//             
//         }];
//        
//        if(_centerUserLocation)
//        {
//            [self centerToUserLocation];
//            [self zoomToUserLocation];
//        }
//        
//        [self.tableView scrollsToTop];
//    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    DLogBlue(@"");
    float contentOffset = scrollView.contentOffset.y;
    DLogBlue(@"offset: %0.0f", contentOffset);
//    if (contentOffset < _lastDragOffset)
//        _scrollViewIsDraggedDownwards = YES;
//    else
//        _scrollViewIsDraggedDownwards = NO;
//    
//    if (!_scrollViewIsDraggedDownwards)
//    {
//        [_mapView setFrame:
//         CGRectMake(0, self.tableView.contentInset.top*-1, self.tableView.bounds.size.width, self.tableView.contentInset.top)
//         ];
//        [_mapView setUserInteractionEnabled:NO];
//        
//        [self.tableView setContentInset:UIEdgeInsetsMake(kKIPTRTableViewContentInsetX,0,0,0)];
//        
//        if(_centerUserLocation)
//        {
//            [self centerToUserLocation];
//            [self zoomToUserLocation];
//        }
//        
//        [self.tableView scrollsToTop];
//    }
//    
//    if(contentOffset >= -50)
//    {
//        [_toolbar removeFromSuperview];
//        [_toolbar setFrame:CGRectMake(0, contentOffset, self.tableView.bounds.size.width, 50)];
//        [self.tableView addSubview:_toolbar];
//    }
//    else if(contentOffset < 0)
//    {
//        [_toolbar removeFromSuperview];
//        [_toolbar setFrame:CGRectMake(0, -50, self.tableView.bounds.size.width, 50)];
//        [self.tableView insertSubview:_toolbar aboveSubview:self.tableView];
//        
//        // Resize map to viewable size
//        [_mapView setFrame:
//         CGRectMake(0, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, contentOffset*-1)
//         ];
//        [self zoomMapToFitAnnotations];
//    }
//    
//    if(_centerUserLocation)
//    {
//        [self centerToUserLocation];
//        [self zoomToUserLocation];
//        [self displayMapViewAnnotationsForTableViewCells];
//    }
}


@end
