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
@property (strong, nonatomic) KKNavigationController *navController;
@property (strong, nonatomic) KKWelcomeViewController *welcomeViewController;
@property (strong, nonatomic) ICSDrawerController *drawerController;
@property (strong, nonatomic) MBPullDownController *toolbarPullDownController;
@property (strong, nonatomic) MBPullDownController *mapViewPullDownController;
@property (strong, nonatomic) KKBarGolfToolbarViewController *barGolfToolbarViewController;
@property (strong, nonatomic) KKBarListMapViewController *mapViewController;
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

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)menuItems {
	if (!_menuItems) {
		_menuItems = @[@"My Scorecard", @"My Player Profile", @"Log Out"];
	}
	return _menuItems;
}

- (MBPullDownController *)toolbarPullDownController {
    if (!_toolbarPullDownController) {
        _toolbarPullDownController = [[MBPullDownController alloc] init];
        _toolbarPullDownController.backController = self.barGolfToolbarViewController;
    }
    return _toolbarPullDownController;
}

- (MBPullDownController *)mapViewPullDownController {
    if (!_mapViewPullDownController) {
        _mapViewPullDownController = [[MBPullDownController alloc] init];
        KKBarListViewController *barListViewController = [[KKBarListViewController alloc] init];
        _mapViewPullDownController.frontController = barListViewController;
        _mapViewPullDownController.backController = self.mapViewController;
    }
    return _mapViewPullDownController;
}

- (KKBarGolfToolbarViewController *)barGolfToolbarViewController {
    if (!_barGolfToolbarViewController) {
        _barGolfToolbarViewController = [[KKBarGolfToolbarViewController alloc] init];
    }
    return _barGolfToolbarViewController;
}

- (KKBarListMapViewController *)mapViewController {
    if (!_mapViewController) {
        _mapViewController = [[KKBarListMapViewController alloc] init];
    }
    
    return _mapViewController;
}

#pragma mark - Public Methods
- (void)configureAndLoadInitialWelcomeView {
    [self showWelcomeView];
    
    //also, configure our pull downs once the app delegate window has had a
    //chance to load
    [self configureToolBarPullDownController];
    [self configureMapViewPullDownController];
}

- (void)addNotificationObservers {
    //these are posted by the bar golf toolbar buttons when pressed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBars) name:kBarGolfShowBarsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTaxis) name:kBarGolfShowTaxisNotification object:nil];
    //this is posted by the find a bar view when it disappears to ensure we
    //always return to it when the map view closed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMapViewPulldown) name:kMenuShouldCloseMapViewNotification object:nil];
}

#pragma mark - Private Methods that Create and/or Push New View Controllers
- (void)showWelcomeView {
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
    //the scorecard view will be the first view shown by default
    KKMyScorecardViewController *scorecardVC = [[KKMyScorecardViewController alloc] init];
    self.toolbarPullDownController.frontController = scorecardVC;
    
    self.navController = [[KKNavigationController alloc] initWithRootViewController:self.toolbarPullDownController andTitle:@"My Scorecard"];
    self.drawerController = [[ICSDrawerController alloc] initWithLeftViewController:self
                                                                     centerViewController:self.navController];
    
    //drawer needs to be the main interface view so it's top view can hold any
    //navigation controllers while the menu view controller is not part of a
    //nav controller; hence, we set the drawer to window's root
    KKAD.window.rootViewController = self.drawerController;
}

- (void)pushInNewViewController:(UIViewController *)vc withTitle:(NSString *)title {
    self.toolbarPullDownController.frontController = vc;
    [self.navController setViewControllers:@[self.toolbarPullDownController]];
    [self.drawer replaceCenterViewControllerWithViewController:self.navController];
}

- (void)showBars {
    [self.navController pushViewController:self.mapViewPullDownController animated:YES];
    //close the toolbar pull down after it's offscreen
    [self performSelector:@selector(closeToolbarPulldown) withObject:nil afterDelay:1.0];
}

- (void)showTaxis {
    //close the toolbar pull down after it's offscreen
    [self performSelector:@selector(closeToolbarPulldown) withObject:nil afterDelay:1.0];
}

- (void)closeToolbarPulldown {
    if (self.toolbarPullDownController.open) {
        [self.toolbarPullDownController setOpen:NO animated:YES];
    }
}

- (void)closeMapViewPulldown {
    if (self.mapViewPullDownController.open) {
        [self.mapViewPullDownController setOpen:NO animated:YES];
    }
}

#pragma mark - Configuration Methods
- (void)configureToolBarPullDownController {
    //configure things like the pulldown distance needed and spacing
    self.toolbarPullDownController.backgroundView.backgroundColor = kMedGray;
    [(MBPullDownControllerBackgroundView *)self.toolbarPullDownController.backgroundView setDropShadowVisible:NO];
    self.toolbarPullDownController.closedTopOffset += 20.f;
    self.toolbarPullDownController.openBottomOffset = KKAD.window.frame.size.height - (64.f + 64.f);
    //set distances to drage before opening/closing automatically kicks in
    self.toolbarPullDownController.openDragOffset = 64.f;
    self.toolbarPullDownController.closeDragOffset = 25.f;
}

//used for the layered pulldown views where there's a list over top of map view
- (void)configureMapViewPullDownController {
    self.mapViewPullDownController.backgroundView.backgroundColor = kMedGray;
    [(MBPullDownControllerBackgroundView *)self.mapViewPullDownController.backgroundView setDropShadowVisible:NO];
    self.mapViewPullDownController.closedTopOffset += 190.f;
    self.mapViewPullDownController.openBottomOffset = 100.f;//amount of top view controller left at bottom when open
    //set distances to drage before opening/closing automatically kicks in
    self.mapViewPullDownController.openDragOffset = 45.f;
    self.mapViewPullDownController.closeDragOffset = 25.f;
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
        //close the toolbar pull down after it's offscreen
        [self closeToolbarPulldown];
        
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

#pragma mark - ICSDrawerControllerPresenting Methods
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
