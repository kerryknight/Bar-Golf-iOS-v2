// KKMenuViewController.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface KKMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation KKMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // topViewController is the first view loaded into the navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"My Scorecard", @"My Player Profile", @"Log Out"];
    
    return _menuItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.textLabel.text = menuItem;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    UIViewController *newVC;
    
    if ([menuItem isEqualToString:@"My Scorecard"]) {
        newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KKMyScorecardViewController"];
    } else if ([menuItem isEqualToString:@"My Player Profile"]) {
        newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KKMyPlayerProfileViewController"];
    } else if ([menuItem isEqualToString:@"Log Out"]) {
        DLog(@"Should log out");
        return;
    }
    
    //after instantiating the correct view controller, reset our nav controller's
    //root view with it
    self.transitionsNavigationController.viewControllers = @[newVC];
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
