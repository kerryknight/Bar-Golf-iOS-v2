//
//  KKAppDelegate.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKAppDelegate.h"
#import "KKMenuViewController.h"
#import "KKConfig.h"

//#import "KKWelcomeViewController.h"
//#import "KKMenuViewController.h"
//#import "KKNavigationController.h"
//#import "KKMyScorecardViewController.h"

@interface KKAppDelegate () {
}

//@property (strong, nonatomic) KKWelcomeViewController *welcomeViewController;
@property (strong, nonatomic) KKMenuViewController *menuViewController;
@property (strong, nonatomic) Reachability *hostReach;
@property (strong, nonatomic) Reachability *internetReach;
@property (strong, nonatomic) Reachability *wifiReach;
@property (assign, nonatomic, readwrite) int networkStatus;
@property (assign, nonatomic) BOOL firstLaunch;
@property (strong, nonatomic) NSMutableData *data;;

@end

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configure3rdParties];
    
    [self configureMenuController];
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)configure3rdParties {
    // START 3RD PARTY INSTANTIATIONS ********************************************************
    // RevMob
    //RevMob initilization
    [RevMobAds startSessionWithAppID:kREV_MOB_APP_ID];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"72614ec4b03fbf638deccdb46a34d1ef0b3a0a62"];
    
    // Parse
    [Parse setApplicationId:kParseApplicationID clientKey:kParseApplicationClientKey];
    [PFFacebookUtils initializeFacebook];
    
    // Foursquare
    [Foursquare2 setupFoursquareWithClientId:kFoursquareClientId
                                      secret:kFoursquareClientSecret
                                 callbackURL:kFoursquareCallbackURL];
    
    //Configure Parse setup
    PFACL *defaultACL = [PFACL ACL];
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // END 3RD PARTY
    // INSTANTIATIONS **********************************************************
}

#pragma mark - Public methods
- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)logOut {
    // clear cache
    [[KKCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
}

#pragma mark - Private Methods
- (void)configureMenuController {
    //the menuViewController will control all view loading for the app
    //delegate and even sets the window's root view controller on app load;
    //eventhough the menu view controller won't have actual menu items for some
    //of the views we're having it load, it will make it easier to user it
    //essentially as a GCD for loading view controllers regardless
    self.menuViewController = [[KKMenuViewController alloc] init];
    [self.menuViewController configureAndLoadInitialWelcomeView];
    [self.menuViewController addNotificationObservers];
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
    self.networkStatus = [curReach currentReachabilityStatus];

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

#pragma mark - Facebook and Foursquare
// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DLogBlue(@"sourceapplication: %@", sourceApplication);
    
    if ([sourceApplication isEqualToString:@"Facebook"]) {
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:[PFFacebookUtils session]];
    }
    
    return [Foursquare2 handleURL:url];
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
