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
@property (strong, nonatomic) NSArray *menuItems;
@property (assign, nonatomic) NSInteger previousRow;
@property (strong, nonatomic) KKWelcomeViewController *welcomeViewController;
@property (strong, nonatomic) ICSDrawerController *drawerController;
@end


@implementation KKMenuViewController

#pragma mark - View Life Cycle and Lazy Instantiation
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization this is the only observer need to have
        //immediately at instantiation; the others can and should wait to be
        //added in the -addNotificationObservers method
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainInterface) name:kMenuShouldShowMainInterfaceNotification object:nil];
    }
    return self;
}

- (NSArray *)menuItems {
	if (!_menuItems) {
		_menuItems = @[@"My Scorecard", @"My Player Profile", @"Log Out"];
	}
	return _menuItems;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Methods
- (void)configureAndLoadInitialWelcomeView {
    DLogCyan(@"");
    [self showWelcomeView];
}

- (void)addNotificationObservers {
    DLogCyan(@"");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBars) name:kBarGolfShowBarsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTaxis) name:kBarGolfShowTaxisNotification object:nil];
}

#pragma mark - Private Methods
- (void)showWelcomeView {
    DLogCyan(@"");
    // Create the navigation controller with our welcome vc
	self.welcomeViewController = [[KKWelcomeViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    // This is the tits. Don't forget to do this! for STPTransitions
    navController.delegate = STPTransitionCenter.sharedInstance;
	navController.navigationBarHidden = YES;
    
    KKAD.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    KKAD.window.backgroundColor = kDrkGray;
    KKAD.window.rootViewController = navController;
    
    [KKAD.window makeKeyAndVisible];
}

- (void)showMainInterface {
    DLogCyan(@"");
    KKMenuViewController *menuVC = [[KKMenuViewController alloc] init];
    //the scorecard view will be the first view shown by default
    KKMyScorecardViewController *scorecardVC = [[KKMyScorecardViewController alloc] init];
    MBPullDownController *pullDownController = [self configurePullDownControllerWithBarGolfToolbarForFrontController:scorecardVC];
    
    KKNavigationController *navController = [[KKNavigationController alloc] initWithRootViewController:pullDownController andTitle:@"My Scorecard"];
    self.drawerController = [[ICSDrawerController alloc] initWithLeftViewController:menuVC
                                                                     centerViewController:navController];
    
    //drawer needs to be the main interface view so it's top view can hold any
    //navigation controllers while the menu view controller is not part of a
    //nav controller; hence, we set the drawer to window's root
    KKAD.window.rootViewController = self.drawerController;
}

//creates the layers pulldown view where a scrollview overlaps the find a
//bar/call a taxi toolbar view
- (MBPullDownController *)configurePullDownControllerWithBarGolfToolbarForFrontController:(UIViewController *)controller {
    //create the find a bar/call a taxi toolbar controller
    KKBarGolfToolbarViewController *barGolfToolbar = [[KKBarGolfToolbarViewController alloc] init];
    
    //create our pulldown view controller and set our passed-in top view and
    //then our toolbar as the background view
    MBPullDownController *pullDownController = [[MBPullDownController alloc] initWithFrontController:controller backController:barGolfToolbar];
    
    //configure things like the pulldown distance needed and spacing
    pullDownController.backgroundView.backgroundColor = kMedGray;
    [(MBPullDownControllerBackgroundView *)pullDownController.backgroundView setDropShadowVisible:NO];
    pullDownController.closedTopOffset += 20.f;
    pullDownController.openBottomOffset = KKAD.window.frame.size.height - (64.f + 64.f);
    pullDownController.openDragOffset = 45.f;
    pullDownController.closeDragOffset = 25.f;

    return pullDownController;
}

//used for the layered pulldown views where there's a list over top of map view
- (MBPullDownController *)configurePullDownControllerWithMapViewForFrontController:(UIViewController *)controller {
    DLogOrange(@"");
    KKBarListMapViewController *mapVC = [[KKBarListMapViewController alloc] init];
    MBPullDownController *pullDownController = [[MBPullDownController alloc] initWithFrontController:controller backController:mapVC];
    pullDownController.backgroundView.backgroundColor = kMedGray;
    [(MBPullDownControllerBackgroundView *)pullDownController.backgroundView setDropShadowVisible:NO];
    pullDownController.closedTopOffset += 20.f;
    pullDownController.openBottomOffset = KKAD.window.frame.size.height - (64.f + 164.f);
    pullDownController.openDragOffset = 45.f;
    pullDownController.closeDragOffset = 25.f;
    
    return pullDownController;
}

- (void)pushInNewViewController:(UIViewController *)vc withTitle:(NSString *)title {
    MBPullDownController *pullDownController = [self configurePullDownControllerWithBarGolfToolbarForFrontController:vc];
    KKNavigationController *newNavController = [[KKNavigationController alloc] initWithRootViewController:pullDownController andTitle:title];
    [self.drawer replaceCenterViewControllerWithViewController:newNavController];
}

- (void)showBars {
    KKBarListViewController *barListViewController = [[KKBarListViewController alloc] init];
    //pass our vc and it's title off to our helper method which will
    //create a new pulldown view controller to put them into
    [self pushInNewViewController:barListViewController withTitle:@"Find a Bar"];
}

- (void)showTaxis {
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
            DLogOrange(@"log user out");
			[KKAD logOut];
            
            //show the welcome view
            [self showWelcomeView];
			return;
		}
        
        //pass our vc and it's title off to our helper method which will
        //create a new pulldown view controller to put them into
        [self pushInNewViewController:newVC withTitle:menuItem];
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
