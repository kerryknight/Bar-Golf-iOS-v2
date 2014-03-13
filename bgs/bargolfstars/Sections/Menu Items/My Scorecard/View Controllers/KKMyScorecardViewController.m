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
        CGFloat y = self.tableView.contentOffset.y;
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

@end
