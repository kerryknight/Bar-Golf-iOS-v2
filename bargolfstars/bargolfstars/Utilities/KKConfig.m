//
//  KKConfig.m
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import "KKConfig.h"

#ifdef RELEASE
//NSString *const kSomeConstant1                                = @"something 1";
#else
//NSString *const kSomeConstant1                                = @"something 2";
#endif

#ifdef DEBUG
//NSString *const kSomeConstant2                                = @"something 3";
#else
//NSString *const kSomeConstant2                                = @"something 4";
#endif


#pragma mark - API keys
NSString *const kREV_MOB_APP_ID                                 = @"5063a942d1a7040c00000027";
NSString *const kREV_MOB_FULLSCREEN_PLACEMENT_ID                = @"50f8496e1c5cb51a00000001";
NSString *const kREV_MOB_BANNER_PLACEMENT_ID                    = @"50f849607293dc0e00000003";
NSString *const kREV_MOB_AD_LINK_PLACEMENT_ID                   = @"50f849902af5fe1200000001";
NSString *const kKKParseApplicationID                           = @"PG4Fpi5KFo5RBN3RM0vK5bY19hqjXOYgATlwTdYo";
NSString *const kKKParseApplicationClientKey                    = @"k8b3CddAoTX1XkaNdCwGiydyvh24vintFl7eFYLz";
NSString *const kKKFacebookAppID                                = @"109998089149025";
NSString *const kKKFacebookAppSecret                            = @"40eb53711f6eea918f0a82fb9395c889";
NSString *const kKKTwitterConsumerKey                           = @"Sud9crv4umTDRXDzIJELA";
NSString *const kKKTwitterConsumerSecret                        = @"1C4tmO120pNAYzLMQ5B4TXqoBhNVx67uNaKY8Uzc6k";
NSString *const kKKFoursquareEndpoint                           = @"https://api.foursquare.com/v2/";
NSString *const kKKFoursquareCliendId                           = @"YGW04MPRBJIQKV3WVHTCJCOU5DUD5ILSAGEZ1KM2B2C5EQMT";
NSString *const kKKFoursquareClientSecret                       = @"M10XYKPZGNCVVR2ONGAEGX4VJ1J15GYTBMRWJ1Z3PS3UXGHQ";

#pragma mark - NSUserDefaults
NSString *const kKKUserDefaultsCacheFacebookFriendsKey          = @"com.kerryknight.bargolfstars.userDefaults.cache.facebookFriends";

#pragma mark - Default App Settings
int const kKKMinimumPasswordLength                              =   7;
int const kKKMaximumPasswordLength                              =   20;
int const kKKMinimumDisplayNameLength                           =   1;
int const kKKMaximumDisplayNameLength                           =   20;

#pragma mark - Launch URLs
NSString *const kKKLaunchURLHostTakePicture                     = @"camera";


#pragma mark - NSNotification

NSString *const KKAppDelegateApplicationDidReceiveRemoteNotification    = @"com.kerryknight.bargolfstars.appDelegate.applicationDidReceiveRemoteNotification";

#pragma mark - Installation Class

// Field keys
NSString *const kKKInstallationUserKey                          = @"user";
NSString *const kKKInstallationChannelsKey                      = @"channels";


#pragma mark - Cached User Attributes
// keys
NSString *const kKKUserAttributesPhotoCountKey                  = @"photoCount";
NSString *const kKKUserAttributesIsFollowedByCurrentUserKey     = @"isFollowedByCurrentUser";

#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey                                   = @"alert";
NSString *const kAPNSBadgeKey                                   = @"badge";
NSString *const kAPNSSoundKey                                   = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kKKPushPayloadPayloadTypeKey                    = @"p";
NSString *const kKKPushPayloadPayloadTypeActivityKey            = @"a";

NSString *const kKKPushPayloadActivityTypeKey                   = @"t";
NSString *const kKKPushPayloadActivityLikeKey                   = @"l";
NSString *const kKKPushPayloadActivityCommentKey                = @"c";
NSString *const kKKPushPayloadActivityFollowKey                 = @"f";

NSString *const kKKPushPayloadFromUserObjectIdKey               = @"fu";
NSString *const kKKPushPayloadToUserObjectIdKey                 = @"tu";
NSString *const kKKPushPayloadPhotoObjectIdKey                  = @"pid";

// *********************************************** PARSE CLOUD CODE **************************************
NSString *const kKKCloudCodeDeleteUserKey                       = @"deleteUserAccountAndData";


// *********************************************** PARSE CLASSES *****************************************
#pragma mark - PFObject User Class
// Field keys
NSString *const kKKUserDisplayNameKey                           = @"displayName";
NSString *const kKKUserFacebookIDKey                            = @"facebookId";
NSString *const kKKUserPhotoIDKey                               = @"photoId";
NSString *const kKKUserProfilePicSmallKey                       = @"profilePictureSmall";
NSString *const kKKUserProfilePicMediumKey                      = @"profilePictureMedium";
NSString *const kKKUserFacebookFriendsKey                       = @"facebookFriends";
NSString *const kKKUserPrivateChannelKey                        = @"channel";
NSString *const kKKUserFacebookProfileKey                       = @"profile";
NSString *const kKKUserEmailKey                                 = @"email";
NSString *const kKKUserUsernameKey                              = @"username";
NSString *const kKKUserEmailVerifiedKey                         = @"emailVerified";
NSString *const kKKUserCurrentActiveRoundKey                    = @"currentActiveRound";
NSString *const kKKUserCurrentRoundsKey                         = @"currentRounds";
NSString *const kKKUserRoundsCreatedKey                         = @"roundsCreated";
NSString *const kKKUserTwitterIdKey                             = @"twitterId";


#pragma mark - PFObject Activity Class
// Class key
NSString *const kKKActivityClassKey                             = @"Activity";

// Field keys
NSString *const kKKActivityTypeKey                              = @"type";
NSString *const kKKActivityFromUserKey                          = @"fromUser";
NSString *const kKKActivityToUserKey                            = @"toUser";
NSString *const kKKActivityContentKey                           = @"content";
NSString *const kKKActivityHoleKey                              = @"hole";
NSString *const kKKActivityRoundKey                             = @"round";

// Type values
NSString *const kKKActivityTypeLike                             = @"like";
NSString *const kKKActivityTypeFollow                           = @"follow";
NSString *const kKKActivityTypeComment                          = @"comment";
NSString *const kKKActivityTypeJoined                           = @"join";


#pragma mark - PFObject Hole Class
// Class key
NSString *const kKKHoleClassKey                                 = @"round";

// Field keys
NSString *const kKKHoleHoleNumKey                               = @"holeNum";
NSString *const kKKHoleLocationKey                              = @"location";
NSString *const kKKHoleNameKey                                  = @"name";
NSString *const kKKHoleParKey                                   = @"par";
NSString *const kKKHoleRoundKey                                 = @"round";
NSString *const kKKHoleTimeAtHoleKey                            = @"timeAtHole";
NSString *const kKKHoleUserKey                                  = @"user";


#pragma mark - PFObject Player Class
// Class key
NSString *const kKKPlayerClassKey                               = @"Player";

// Field keys
NSString *const kKKPlayerDisplayNameKey                         = @"displayName";
NSString *const kKKPlayerHandicapKey                            = @"handicap";
NSString *const kKKPlayerHolesPlayedKey                         = @"holesPlayed";
NSString *const kKKPlayerIsUserAccountKey                       = @"isUserAccount";
NSString *const kKKPlayerMaxHolePlayedKey                       = @"maxHolePlayed";
NSString *const kKKPlayerParsInPlayTotalKey                     = @"parsInPlayTotal";
NSString *const kKKPlayerPlayerNumKey                           = @"playerNum";
NSString *const kKKPlayerRoundKey                               = @"round";
NSString *const kKKPlayerScorecardKey                           = @"scorecard";
NSString *const kKKPlayerScoresKey                              = @"scores";
NSString *const kKKPlayerTotalRoundStrokesKey                   = @"totalRoundStrokes";
NSString *const kKKPlayerUserKey                                = @"user";


#pragma mark - PFObject Round Class
// Class key
NSString *const kKKRoundClassKey                                = @"Round";

// Field keys
NSString *const kKKRoundEndDateKey                              = @"endDate";
NSString *const kKKRoundIsActiveKey                             = @"isActive";
NSString *const kKKRoundIsPublicKey                             = @"isPublic";
NSString *const kKKRoundRulesKey                                = @"rules";
NSString *const kKKRoundStartDateKey                            = @"startDate";
NSString *const kKKRoundTitleKey                                = @"title";
NSString *const kKKRoundUserKey                                 = @"user";


#pragma mark - PFObject Rule Class
// Class key
NSString *const kKKRuleClassKey                                 = @"Rule";

// Field keys
NSString *const kKKRuleDescriptionKey                           = @"description";
NSString *const kKKRuleIsDefaultKey                             = @"isDefault";
NSString *const kKKRuleModifiedDefaultKey                       = @"modifiedDefault";
NSString *const kKKRuleNameKey                                  = @"name";
NSString *const kKKRuleRoundKey                                 = @"round";
NSString *const kKKRuleTypeKey                                  = @"type";
NSString *const kKKRuleUserKey                                  = @"user";
NSString *const kKKRuleValueKey                                 = @"value";


#pragma mark - PFObject Score Class
// Class key
NSString *const kKKScoreClassKey                                = @"Score";

// Field keys
NSString *const kKKScoreCountKey                                = @"count";
NSString *const kKKScoreHoleKey                                 = @"hole";
NSString *const kKKScorePlayerKey                               = @"player";
NSString *const kKKScoreRoundKey                                = @"round";
NSString *const kKKScoreRuleKey                                 = @"rule";
NSString *const kKKScoreScorecardKey                            = @"scorecard";
NSString *const kKKScoreTimeAtScoreKey                          = @"timeAtScore";
NSString *const kKKScoreUserKey                                 = @"user";


#pragma mark - PFObject Scorecard Class
// Class key
NSString *const kKKScorecardClassKey                            = @"Scorecard";

// Field keys
NSString *const kKKScorecardIsActiveKey                         = @"isActive";
NSString *const kKKScorecardRoundKey                            = @"round";
NSString *const kKKScorecardUserKey                             = @"user";

