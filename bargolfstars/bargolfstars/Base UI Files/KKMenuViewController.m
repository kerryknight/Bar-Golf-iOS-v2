// KKMenuViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMenuViewController.h"

static NSString *const kMenuViewControllerCellReuseId = @"KKMenuCell";

@interface KKMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) NSInteger previousRow;

@end


@implementation KKMenuViewController

- (NSArray *)menuItems {
	if (!_menuItems) {
		_menuItems = @[@"My Scorecard", @"My Player Profile", @"Log Out"];
	}
	return _menuItems;
}

#pragma mark - Managing the view

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Public Methods
- (KKNavigationController *)getNavControllerForInitialDrawer {
    KKMyScorecardViewController *scorecardVC = [[KKMyScorecardViewController alloc] init];
    MBPullDownController *pullDownController = [self configurePullDownControllerForFrontController:scorecardVC];
    return [[KKNavigationController alloc] initWithRootViewController:pullDownController andTitle:@"My Scorecard"];
}

#pragma mark - Private Methods
- (MBPullDownController *)configurePullDownControllerForFrontController:(UIViewController *)controller {
    
    KKBarGolfToolbarViewController *barGolfToolbar = [[KKBarGolfToolbarViewController alloc] init];
    MBPullDownController *pullDownController = [[MBPullDownController alloc] initWithFrontController:controller backController:barGolfToolbar];
    pullDownController.backgroundView.backgroundColor = kMedGray;
    [(MBPullDownControllerBackgroundView *)pullDownController.backgroundView setDropShadowVisible:NO];
    pullDownController.closedTopOffset += 20.f;
    pullDownController.openBottomOffset = KKAD.window.frame.size.height - (64.f + 64.f);
    pullDownController.openDragOffset = 45.f;
    pullDownController.closeDragOffset = 25.f;

    return pullDownController;
}



#pragma mark - Configuring the view’s layout behavior

- (UIStatusBarStyle)preferredStatusBarStyle {
	// Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
	// status bar style to avoid a flicker when the drawer is dragged and then left to open.
	return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuViewControllerCellReuseId];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMenuViewControllerCellReuseId];
	}
    
	cell.textLabel.text = self.menuItems[indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = kMedGray;

	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (indexPath.row == self.previousRow) {
		// Close the drawer without no further actions on the center view controller
		[self.drawer close];
	}
	else {
		
		NSString *menuItem = self.menuItems[indexPath.row];
		UIViewController *newVC;

		if ([menuItem isEqualToString:@"My Scorecard"]) {
			newVC = [[KKMyScorecardViewController alloc] init];
		}
		else if ([menuItem isEqualToString:@"My Player Profile"]) {
			newVC = [[KKMyPlayerProfileViewController alloc] init];
		}
		else if ([menuItem isEqualToString:@"Log Out"]) {
			[self.drawer close];
			[KKAD logOut];
			return;
		}

        MBPullDownController *pullDownController = [self configurePullDownControllerForFrontController:newVC];
		KKNavigationController *newNavController = [[KKNavigationController alloc] initWithRootViewController:pullDownController andTitle:menuItem];
		[self.drawer replaceCenterViewControllerWithViewController:newNavController];
	}

	self.previousRow = indexPath.row;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController {
	self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController {
	self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController {
	self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController {
	self.view.userInteractionEnabled = YES;
}

@end
