//
//  KKBarListViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 3/7/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKBarListViewController.h"
#import "KKAppDelegate.h"

static NSString *const kScorecardViewControllerCellReuseId = @"KKScorecardCell";

@interface KKBarListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KKBarListViewController

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
    [self configureUI];
    
    //add observer for refresh notification we might get from the our custom nav bar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpinner) name:kBarGolfRefreshButtonNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //have to set our custom nav controller's title by hand each time by
    //casting to it for forward and backward navigation compatibility
    KKNavigationController *navController = (KKNavigationController *)self.navigationController;
    [navController setTitleLabelText:@"Find a Bar"];
    [navController shouldShowRefreshButton:YES];
    
    //wait until the view is about to appear to configure the view model so that
    //we don't prematurely display the "Bar Golf Wants to Use Your Location"
    //alert to the user when the app launches for the first time; this makes
    //it a more proactive thing on the user and a better experience
    [self configureViewModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //post a notification to hide our address bar as casting then telling the nav controller directly
    //seems to be a bit unreliable in doing so; need to double post here on on map view as this only
    //gets called when the map view is open
    [[NSNotificationCenter defaultCenter] postNotificationName:kBarGolfHideUserAddressBarNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //let our menu view know to close our map view in case it's been opened
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuShouldCloseMapViewNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)configureViewModel {
    @weakify(self)
    //update our table view anytime we get a list of bars from our view model
    [[[KKBarListAndMapViewModel sharedViewModel].updatedBarListSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSArray *bars) {
//        DLogOrange(@"bars: %@", bars);
        [KKAD hideSpinner];
        
    }];
    
    //show an error notification anytime we receive an error signal from our
    //view model
    [[[KKBarListAndMapViewModel sharedViewModel].sendErrorSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSError *error) {
        //error logging in, show error message
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [error localizedDescription]];
        [KKStatusBarNotification showWithStatus:message dismissAfter:2.0 customStyleName:KKStatusBarError];
        
        //hide any spinner
        [KKAD hideSpinner];
    }];
    
    //bind our view model to our tableview content offset so we can add a
    //parallax effect to our map view and recenter it was the view opens
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(NSValue *value) {
        @strongify(self)
        NSInteger y = floor(self.tableView.contentOffset.y);
        [KKBarListAndMapViewModel sharedViewModel].frontViewOffset = y;
    }];
    
    [KKAD showSpinnerWithMessage:@"Updating..."];
    //tell our view model to start looking for the user's location now
    [[KKBarListAndMapViewModel sharedViewModel] getUserLocation];
}

- (void)configureUI {
    self.tableView.backgroundColor = kMedGray;
    self.view.backgroundColor = kMedGray;
}

- (void)showSpinner {
    [KKAD showSpinnerWithMessage:@"Updating..."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 30;
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


@end
