//
//  KKAppDelegate.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "KKLogInViewController.h"
#import "KKSignUpViewController.h"
#import "KKWelcomeViewController.h"

@interface KKAppDelegate () {
}

@property (strong, nonatomic) KKWelcomeViewController *welcomeViewController;
//@property (strong, nonatomic) KKHomeViewController *homeViewController;
//@property (strong, nonatomic) KKActivityFeedViewController *activityViewController;
//@property (strong, nonatomic) KKSearchViewController *searchViewController;
//@property (strong, nonatomic) KKAccountViewController *myProfileViewController;

@property (strong, nonatomic) Reachability *hostReach;
@property (strong, nonatomic) Reachability *internetReach;
@property (strong, nonatomic) Reachability *wifiReach;
@property (assign, nonatomic, readwrite) int networkStatus;
@property (assign, nonatomic) BOOL firstLaunch;
@property (strong, nonatomic) NSMutableData *data;;

- (void)setupAppearance;
- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (BOOL)handleActionURL:(NSURL *)url;
@end

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // START 3RD PARTY INSTANTIATIONS ********************************************************
    // RevMob
    //RevMob initilization
//    [RevMobAds startSessionWithAppID:kREV_MOB_APP_ID];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"72614ec4b03fbf638deccdb46a34d1ef0b3a0a62"];
    
    
    // CocoaLumberjack logging
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    
    
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
    
    // Create the navigation controller with our welcome vc
	self.welcomeViewController = [[KKWelcomeViewController alloc] init];
	self.regularNavController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
	
	// Create the window and add our nav controller to it
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
	self.regularNavController.navigationBarHidden = YES;
    self.window.rootViewController = self.regularNavController;
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
    [self.regularNavController popToRootViewControllerAnimated:NO];
    
    [self presentLoginViewController];
    
//    self.homeViewController = nil;
//    self.activityViewController = nil;
//    self.searchViewController = nil;
//    self.myProfileViewController = nil;
}

#pragma mark - PFLogInViewControllerDelegate
- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    DLog(@"");
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[KKLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    [logInViewController setFields:PFLogInFieldsUsernameAndPassword | /*PFLogInFieldsTwitter |*/ PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton /*| PFLogInFieldsDismissButton*/ | PFLogInFieldsPasswordForgotten];
    
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"user_about_me", @"friends_about_me", nil]];
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[KKSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    //main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Present the log in view controller
        [self.welcomeViewController presentViewController:logInViewController animated:NO completion:NULL];
    });
}


- (void)presentLoginViewController {
    DLog(@"");
    [self presentLoginViewControllerAnimated:YES];
}

// Called on successful login. This is likely to be the place where we register
// the user to the "user_xxxxxxxx" channel
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    DLog(@"");
    
    //check what type of login we have
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        // user has logged in - we need to fetch all of their Facebook data before we let them in if they logged in with FB
        if (![self shouldProceedToMainInterface:user]) {
//            self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view  animated:YES];
//            self.hud.color = kMint4;
//            [self.hud setDimBackground:YES];
//            [self.hud setLabelText:@"Loading"];
        }
//        //we're logged in with Facebook so request the user's name and pic data
//        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:@"me/?fields=name,picture"];
//        [request setDelegate:self];
//        [request startWithCompletionHandler:NULL];
        
        
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            DLog(@"FB request completion: %@", result);
        }];
        
        
        
        
    } /*else if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]] ) {
       //we're logged in with Twitter //TODO:
       DLog(@"logged into twitter, now retrieve twitter name and picture");
       } */else {
           //we're logged with via a Parse account so dismiss the overlay
//           [self presentTabBarController];
           [self.regularNavController dismissViewControllerAnimated:YES completion:^{
               //
           }];
       }
    
    // Subscribe to private push channel
    if (user) {
        DLog(@"subscribe to private push channel");
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
        // Add the user to the installation so we can track the owner of the device
        [[PFInstallation currentInstallation] setObject:user forKey:kKKInstallationUserKey];
//        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kKKInstallationUserKey];
        // Subscribe user to private channel
        [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kKKInstallationChannelsKey];
        // Save installation object
        [[PFInstallation currentInstallation] saveEventually];
        [user setObject:privateChannelName forKey:kKKUserPrivateChannelKey];
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    
    DLog(@"Failed to log in with error: %@", error);
    alertMessage(@"Uh oh. Something happened and logging in failed with error: %@. Please try again.", [error localizedDescription]);
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    DLog(@"");
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        //make sure all fields are filled in
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
        //ensure password is long enough
        if ([key isEqualToString:@"password"] && field.length < kKKMinimumPasswordLength) {
            alertMessage(@"Password must be at least %i characters.", kKKMinimumPasswordLength);
            informationComplete = NO;
            return informationComplete;
        }
        
        //check the characters used in the password field; new passwords must contain at least 1 digit
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([key isEqualToString:@"password"] && [field rangeOfCharacterFromSet:set].location == NSNotFound) {
            //no numbers found
            alertMessage(@"Password must contain at least one number");
            informationComplete = NO;
            return informationComplete;
        }
        
        //ensure our display name doesn't include any special characters so we don't get lots of dicks and stuff for names 8======D
        set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
        if ([key isEqualToString:@"password"] && [field rangeOfCharacterFromSet:set].location != NSNotFound) {
            //special characters found
            alertMessage(@"Display names can only contain letters and numbers.");
            informationComplete = NO;
            return informationComplete;
        }
    }
    
    if (!informationComplete) {
        
        //knightka replaced a regular alert view with our custom subclass
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) andMessage:NSLocalizedString(@"Make sure you fill out all of the information!", nil)];
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"OK Clicked");
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    DLog(@"");
    [self.welcomeViewController dismissViewControllerAnimated:YES completion:NULL];
    
    //knightka replaced a regular alert view with our custom subclass
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"Success!", nil) andMessage:NSLocalizedString(@"Please look for an email asking you to verify your email address to get the most from Bar Golf.", nil)];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"OK Clicked");
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    DLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    DLog(@"User dismissed the signUpViewController");
}


#pragma mark - Private Methods
- (void)setupAppearance {
    DLog(@"");
    //create all our global styles here
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    DLog(@"");
    if ([KKUtility userHasValidFacebookData:[PFUser currentUser]]) {
        DLog(@"User has valid Facebook data, granting permission to use app.");
//        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
//        [self presentTabBarController];
        
        [self.regularNavController dismissViewControllerAnimated:YES completion:^{
            //
        }];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)handleActionURL:(NSURL *)url {
    DLog(@"");
    if ([[url host] isEqualToString:kKKLaunchURLHostTakePicture]) {
        if ([PFUser currentUser]) {
            DLog(@"******************* CALLING A METHOD I DELETED BUT DON'T KNOW WHEN THIS WOULD OCCUR************************");
            //            return [self.tabBarController shouldPresentPhotoCaptureController];
        }
    }
    
    return NO;
}


#pragma mark - Reachability
- (void)monitorReachability {
    DLog(@"");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    DLog(@"");
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    //    DLog(@"Reachability changed: %@", curReach);
    self.networkStatus = [curReach currentReachabilityStatus];
    
//    if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
//        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
//        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
//        [self.homeViewController loadObjects];
//    }
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
    //    NSLog(@"%s", __FUNCTION__);
    if ([result boolValue]) {
        DLog(@"Kollections successfully subscribed to push notifications on the broadcast channel.");
    } else {
        DLog(@"Kollections failed to subscribe to push notifications on the broadcast channel.");
    }
}

#pragma mark - Facebook 
// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session] fallbackHandler:^(FBAppCall *call) {
        DLogWarning(@"Need to use the FB fallback handler somehow");
    }];
}

#pragma mark - KKAppDelegate
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
