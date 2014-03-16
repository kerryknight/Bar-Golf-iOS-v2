//
//  KKConfig.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKConfig.h"

#pragma mark - API keys
NSString *const kREV_MOB_APP_ID                               = @"5063a942d1a7040c00000027";
NSString *const kREV_MOB_FULLSCREEN_PLACEMENT_ID              = @"50f8496e1c5cb51a00000001";
NSString *const kREV_MOB_BANNER_PLACEMENT_ID                  = @"50f849607293dc0e00000003";
NSString *const kREV_MOB_AD_LINK_PLACEMENT_ID                 = @"50f849902af5fe1200000001";
NSString *const kParseApplicationID                           = @"PG4Fpi5KFo5RBN3RM0vK5bY19hqjXOYgATlwTdYo";
NSString *const kParseApplicationClientKey                    = @"k8b3CddAoTX1XkaNdCwGiydyvh24vintFl7eFYLz";
NSString *const kFacebookAppID                                = @"109998089149025";
NSString *const kFacebookAppSecret                            = @"40eb53711f6eea918f0a82fb9395c889";
NSString *const kTwitterConsumerKey                           = @"Sud9crv4umTDRXDzIJELA";
NSString *const kTwitterConsumerSecret                        = @"1C4tmO120pNAYzLMQ5B4TXqoBhNVx67uNaKY8Uzc6k";
NSString *const kFoursquareEndpoint                           = @"https://api.foursquare.com/v2/";
NSString *const kFoursquareCallbackURL                        = @"bargolfstarsredirect://foursquare";
NSString *const kFoursquareClientId                           = @"YGW04MPRBJIQKV3WVHTCJCOU5DUD5ILSAGEZ1KM2B2C5EQMT";
NSString *const kFoursquareClientSecret                       = @"M10XYKPZGNCVVR2ONGAEGX4VJ1J15GYTBMRWJ1Z3PS3UXGHQ";

#pragma mark - NSUserDefaults
NSString *const kUserDefaultsCacheFacebookFriendsKey          = @"com.kerryknight.bargolfstars.userDefaults.cache.facebookFriends";

#pragma mark - Default App Settings
int const kMinimumPasswordLength                              =   7;
int const kMaximumPasswordLength                              =   20;
int const kMinimumDisplayNameLength                           =   1;
int const kMaximumDisplayNameLength                           =   20;

#pragma mark - Launch URLs
NSString *const kLaunchURLHostTakePicture                     = @"camera";


#pragma mark - NSNotification

NSString *const kAppDelegateApplicationDidReceiveRemoteNotification = @"com.kerryknight.bargolfstars.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const kMenuShouldShowMainInterfaceNotification      = @"KKMenuShouldShowMainInterfaceNotification";
NSString *const kMenuShouldCloseMapViewNotification           = @"kMenuShouldCloseMapViewNotification";
NSString *const kScrollViewOffsetDidChangeForParallax         = @"kScrollViewOffsetDidChangeForParallax";
NSString *const kBarGolfShowBarsNotification                  = @"kBarGolfShowBarsNotification";
NSString *const kBarGolfShowTaxisNotification                 = @"kBarGolfShowTaxisNotification";
NSString *const kBarGolfHideUserAddressBarNotification        = @"kBarGolfHideUserAddressBarNotification";
NSString *const kBarGolfRefreshButtonNotification             = @"kBarGolfRefreshButtonNotification";

#pragma mark - Installation Class

// Field keys
NSString *const kInstallationUserKey                          = @"user";
NSString *const kInstallationChannelsKey                      = @"channels";


#pragma mark - Cached User Attributes
// keys
NSString *const kUserAttributesPhotoCountKey                  = @"photoCount";
NSString *const kUserAttributesIsFollowedByCurrentUserKey     = @"isFollowedByCurrentUser";

#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey                                 = @"alert";
NSString *const kAPNSBadgeKey                                 = @"badge";
NSString *const kAPNSSoundKey                                 = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kPushPayloadPayloadTypeKey                    = @"p";
NSString *const kPushPayloadPayloadTypeActivityKey            = @"a";

NSString *const kPushPayloadActivityTypeKey                   = @"t";
NSString *const kPushPayloadActivityLikeKey                   = @"l";
NSString *const kPushPayloadActivityCommentKey                = @"c";
NSString *const kPushPayloadActivityFollowKey                 = @"f";

NSString *const kPushPayloadFromUserObjectIdKey               = @"fu";
NSString *const kPushPayloadToUserObjectIdKey                 = @"tu";
NSString *const kPushPayloadPhotoObjectIdKey                  = @"pid";

// *********************************************** PARSE CLOUD CODE **************************************
NSString *const kCloudCodeDeleteUserKey                       = @"deleteUserAccountAndData";


// *********************************************** PARSE CLASSES *****************************************
#pragma mark - PFObject User Class
// Field keys
NSString *const kUserDisplayNameKey                           = @"displayName";
NSString *const kUserFacebookIDKey                            = @"facebookId";
NSString *const kUserPhotoIDKey                               = @"photoId";
NSString *const kUserProfilePicSmallKey                       = @"profilePictureSmall";
NSString *const kUserProfilePicMediumKey                      = @"profilePictureMedium";
NSString *const kUserFacebookFriendsKey                       = @"facebookFriends";
NSString *const kUserPrivateChannelKey                        = @"channel";
NSString *const kUserFacebookProfileKey                       = @"profile";
NSString *const kUserEmailKey                                 = @"email";
NSString *const kUserUsernameKey                              = @"username";
NSString *const kUserEmailVerifiedKey                         = @"emailVerified";
NSString *const kUserCurrentActiveRoundKey                    = @"currentActiveRound";
NSString *const kUserCurrentRoundsKey                         = @"currentRounds";
NSString *const kUserRoundsCreatedKey                         = @"roundsCreated";
NSString *const kUserTwitterIdKey                             = @"twitterId";


#pragma mark - PFObject Activity Class
// Class key
NSString *const kActivityClassKey                             = @"Activity";

// Field keys
NSString *const kActivityTypeKey                              = @"type";
NSString *const kActivityFromUserKey                          = @"fromUser";
NSString *const kActivityToUserKey                            = @"toUser";
NSString *const kActivityContentKey                           = @"content";
NSString *const kActivityHoleKey                              = @"hole";
NSString *const kActivityRoundKey                             = @"round";

// Type values
NSString *const kActivityTypeLike                             = @"like";
NSString *const kActivityTypeFollow                           = @"follow";
NSString *const kActivityTypeComment                          = @"comment";
NSString *const kActivityTypeJoined                           = @"join";


#pragma mark - PFObject Hole Class
// Class key
NSString *const kHoleClassKey                                 = @"round";

// Field keys
NSString *const kHoleHoleNumKey                               = @"holeNum";
NSString *const kHoleLocationKey                              = @"location";
NSString *const kHoleNameKey                                  = @"name";
NSString *const kHoleParKey                                   = @"par";
NSString *const kHoleRoundKey                                 = @"round";
NSString *const kHoleTimeAtHoleKey                            = @"timeAtHole";
NSString *const kHoleUserKey                                  = @"user";


#pragma mark - PFObject Player Class
// Class key
NSString *const kPlayerClassKey                               = @"Player";

// Field keys
NSString *const kPlayerDisplayNameKey                         = @"displayName";
NSString *const kPlayerHandicapKey                            = @"handicap";
NSString *const kPlayerHolesPlayedKey                         = @"holesPlayed";
NSString *const kPlayerIsUserAccountKey                       = @"isUserAccount";
NSString *const kPlayerMaxHolePlayedKey                       = @"maxHolePlayed";
NSString *const kPlayerParsInPlayTotalKey                     = @"parsInPlayTotal";
NSString *const kPlayerPlayerNumKey                           = @"playerNum";
NSString *const kPlayerRoundKey                               = @"round";
NSString *const kPlayerScorecardKey                           = @"scorecard";
NSString *const kPlayerScoresKey                              = @"scores";
NSString *const kPlayerTotalRoundStrokesKey                   = @"totalRoundStrokes";
NSString *const kPlayerUserKey                                = @"user";


#pragma mark - PFObject Round Class
// Class key
NSString *const kRoundClassKey                                = @"Round";

// Field keys
NSString *const kRoundEndDateKey                              = @"endDate";
NSString *const kRoundIsActiveKey                             = @"isActive";
NSString *const kRoundIsPublicKey                             = @"isPublic";
NSString *const kRoundRulesKey                                = @"rules";
NSString *const kRoundStartDateKey                            = @"startDate";
NSString *const kRoundTitleKey                                = @"title";
NSString *const kRoundUserKey                                 = @"user";


#pragma mark - PFObject Rule Class
// Class key
NSString *const kRuleClassKey                                 = @"Rule";

// Field keys
NSString *const kRuleDescriptionKey                           = @"description";
NSString *const kRuleIsDefaultKey                             = @"isDefault";
NSString *const kRuleModifiedDefaultKey                       = @"modifiedDefault";
NSString *const kRuleNameKey                                  = @"name";
NSString *const kRuleRoundKey                                 = @"round";
NSString *const kRuleTypeKey                                  = @"type";
NSString *const kRuleUserKey                                  = @"user";
NSString *const kRuleValueKey                                 = @"value";


#pragma mark - PFObject Score Class
// Class key
NSString *const kScoreClassKey                                = @"Score";

// Field keys
NSString *const kScoreCountKey                                = @"count";
NSString *const kScoreHoleKey                                 = @"hole";
NSString *const kScorePlayerKey                               = @"player";
NSString *const kScoreRoundKey                                = @"round";
NSString *const kScoreRuleKey                                 = @"rule";
NSString *const kScoreScorecardKey                            = @"scorecard";
NSString *const kScoreTimeAtScoreKey                          = @"timeAtScore";
NSString *const kScoreUserKey                                 = @"user";


#pragma mark - PFObject Scorecard Class
// Class key
NSString *const kScorecardClassKey                            = @"Scorecard";

// Field keys
NSString *const kScorecardIsActiveKey                         = @"isActive";
NSString *const kScorecardRoundKey                            = @"round";
NSString *const kScorecardUserKey                             = @"user";

