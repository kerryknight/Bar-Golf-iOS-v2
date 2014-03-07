//
//  KKAppDelegate.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKAppDelegate.h"
#import "KKWelcomeViewController.h"
#import "KKMenuViewController.h"
#import "KKNavigationController.h"
#import "KKMyScorecardViewController.h"

@interface KKAppDelegate () {
}

@property (strong, nonatomic) KKWelcomeViewController *welcomeViewController;

@property (strong, nonatomic) Reachability *hostReach;
@property (strong, nonatomic) Reachability *internetReach;
@property (strong, nonatomic) Reachability *wifiReach;
@property (assign, nonatomic, readwrite) int networkStatus;
@property (assign, nonatomic) BOOL firstLaunch;
@property (strong, nonatomic) NSMutableData *data;;

@end

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // START 3RD PARTY INSTANTIATIONS ********************************************************
    // RevMob
    //RevMob initilization
//    [RevMobAds startSessionWithAppID:kREV_MOB_APP_ID];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"72614ec4b03fbf638deccdb46a34d1ef0b3a0a62"];
    
    // Parse
    [Parse setApplicationId:kKKParseApplicationID clientKey:kKKParseApplicationClientKey];
    [PFFacebookUtils initializeFacebook];
//    [PFTwitterUtils initializeWithConsumerKey:kKKTwitterConsumerKey consumerSecret:kKKTwitterConsumerSecret];
    
    
    //Configure Parse setup
    PFACL *defaultACL = [PFACL ACL];
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    // END 3RD PARTY INSTANTIATIONS **********************************************************
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    [self showWelcomeView];
    [self.window makeKeyAndVisible];
    
    [self handlePush:launchOptions];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    return YES;
}

#pragma mark - Public methods
- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)logOut {
    // clear cache
    [[KKCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKKUserDefaultsCacheFacebookFriendsKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKKUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kKKInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kKKInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
}

#pragma mark - Private Methods
- (void)showWelcomeView {
    // Create the navigation controller with our welcome vc
	self.welcomeViewController = [[KKWelcomeViewController alloc] init];
	self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    // This is the tits. Don't forget to do this! for STPTransitions
    self.navController.delegate = STPTransitionCenter.sharedInstance;
	
	// Create the window and add our nav controller to it
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
	self.navController.navigationBarHidden = YES;
    self.window.rootViewController = self.navController;
}

- (void)showMainInterface {
    KKMenuViewController *menuVC = [[KKMenuViewController alloc] init];
    KKNavigationController *navController = [menuVC getNavControllerForInitialDrawer];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:menuVC
                                                                     centerViewController:navController];
    self.window.rootViewController = drawer;
}

#pragma mark - Reachability
- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
//    DLogRed(@"Reachability changed: %ld", [curReach currentReachabilityStatus]);
    self.networkStatus = [curReach currentReachabilityStatus];
    
//    if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
//        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
//        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
//        [self.homeViewController loadObjects];
//    }
    
    if (![self isParseReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KKStatusBarNotification showWithStatus:NSLocalizedString(@"Bar Golf service is disconnected.", nil) customStyleName:KKStatusBarError];
        });
    } else {
        DLogBlue(@"BAR GOLF BACK ONLINE!!!!");
        dispatch_async(dispatch_get_main_queue(), ^{
           [KKStatusBarNotification dismiss];
        });
    }
    
}

#pragma mark - Notifications
// Called every time the app is launched, so if a user is logged in, we ensure he is
// registered to the proper channel
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    //    NSLog(@"%s", __FUNCTION__);
    [PFPush storeDeviceToken:newDeviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:kKKInstallationChannelsKey];
    
    if ([PFUser currentUser]) {
        // Make sure they are subscribed to their private push channel
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kKKUserPrivateChannelKey];
        
        if (privateChannelName && privateChannelName.length > 0) {
            DLog(@"Subscribing user to %@", privateChannelName);
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kKKInstallationChannelsKey];
        }
    }
    // Save the added channel(s)
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        DLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        DLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    NSLog(@"%s", __FUNCTION__);
    //    [PFPush handlePush:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KKAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([PFUser currentUser]) {
//        if ([self.tabBarController viewControllers].count > KKActivityTabBarItemIndex) {
//            UITabBarItem *tabBarItem = [[[self.tabBarController viewControllers] objectAtIndex:KKActivityTabBarItemIndex] tabBarItem];
//            
//            NSString *currentBadgeValue = tabBarItem.badgeValue;
//            
//            if (currentBadgeValue && currentBadgeValue.length > 0) {
//                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
//                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
//                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
//            } else {
//                tabBarItem.badgeValue = @"1";
//            }
//        }
    }
}

- (void)handlePush:(NSDictionary *)launchOptions {
    DLog(@"");
    //    If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotificationPayload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KKAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        
        if ([PFUser currentUser]) {
            //            if the push notification payload references a photo, we will attempt to push this view controller into view
//            NSString *photoObjectId = [remoteNotificationPayload objectForKey:kKKPushPayloadPhotoObjectIdKey];
//            NSString *fromObjectId = [remoteNotificationPayload objectForKey:kKKPushPayloadFromUserObjectIdKey];
//            if (photoObjectId && photoObjectId.length > 0) {
//                //                check if this photo is already available locally.
//                
//                PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:kKKPhotoClassKey objectId:photoObjectId];
//                for (PFObject *photo in self.homeViewController.objects) {
//                    if ([photo.objectId isEqualToString:photoObjectId]) {
//                        DLog(@"Found a local copy");
//                        targetPhoto = photo;
//                        break;
//                    }
//                }
//                
//                //                if we have a local copy of this photo, this won't result in a network fetch
//                [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                    if (!error) {
//                        UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:KKHomeTabBarItemIndex];
//                        [self.tabBarController setSelectedViewController:homeNavigationController];
//                        
//                        KKPhotoDetailsViewController *detailViewController = [[KKPhotoDetailsViewController alloc] init];
//                        detailViewController.photo = object;
//                        [homeNavigationController pushViewController:detailViewController animated:YES];
//                    }
//                }];
//            } else if (fromObjectId && fromObjectId.length > 0) {
//                //                load fromUser's profile
//                
//                PFQuery *query = [PFUser query];
//                query.cachePolicy = kPFCachePolicyCacheElseNetwork;
//                [query getObjectInBackgroundWithId:fromObjectId block:^(PFObject *user, NSError *error) {
//                    if (!error) {
//                        UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:KKHomeTabBarItemIndex];
//                        [self.tabBarController setSelectedViewController:homeNavigationController];
//                        
//                        KKAccountViewController *accountViewController = [[KKAccountViewController alloc] initWithStyle:UITableViewStylePlain];
//                        [accountViewController setUser:(PFUser *)user];
//                        [homeNavigationController pushViewController:accountViewController animated:YES];
//                    }
//                }];
//                
//            }
        }
    }
}

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        DLog(@"Bar Golf successfully subscribed to push notifications on the broadcast channel.");
    } else {
        DLog(@"Bar Golf failed to subscribe to push notifications on the broadcast channel.");
    }
}

#pragma mark - Facebook 
// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

#pragma mark - KKAppDelegate
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
