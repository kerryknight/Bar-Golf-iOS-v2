//
//  KKConfig.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - API keys
extern NSString *const kREV_MOB_APP_ID;
extern NSString *const kREV_MOB_FULLSCREEN_PLACEMENT_ID;
extern NSString *const kREV_MOB_BANNER_PLACEMENT_ID;
extern NSString *const kREV_MOB_AD_LINK_PLACEMENT_ID;
extern NSString *const kParseApplicationID;
extern NSString *const kParseApplicationClientKey;
extern NSString *const kFacebookAppID;
extern NSString *const kFacebookAppSecret;
extern NSString *const kTwitterConsumerKey;
extern NSString *const kTwitterConsumerSecret;
extern NSString *const kFoursquareEndpoint;
extern NSString *const kFoursquareCallbackURL;
extern NSString *const kFoursquareClientId;
extern NSString *const kFoursquareClientSecret;


#pragma mark - NSUserDefaults
extern NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kUserDefaultsCacheFacebookFriendsKey;


#pragma mark - Default App Settings
extern int const kMinimumPasswordLength;
extern int const kMaximumPasswordLength;
extern int const kMinimumDisplayNameLength;
extern int const kMaximumDisplayNameLength;


#pragma mark - Launch URLs
extern NSString *const kLaunchURLHostTakePicture;


#pragma mark - NSNotification
extern NSString *const kAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const kMenuShouldShowMainInterfaceNotification;
extern NSString *const kMenuShouldCloseMapViewNotification;
extern NSString *const kBarGolfShowBarsNotification;
extern NSString *const kBarGolfShowTaxisNotification;


#pragma mark - Installation Class

// Field keys
extern NSString *const kInstallationUserKey;
extern NSString *const kInstallationChannelsKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kUserAttributesPhotoCountKey;
extern NSString *const kUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kPushPayloadPayloadTypeKey;
extern NSString *const kPushPayloadPayloadTypeActivityKey;

extern NSString *const kPushPayloadActivityTypeKey;
extern NSString *const kPushPayloadActivityLikeKey;
extern NSString *const kPushPayloadActivityCommentKey;
extern NSString *const kPushPayloadActivityFollowKey;

extern NSString *const kPushPayloadFromUserObjectIdKey;
extern NSString *const kPushPayloadToUserObjectIdKey;
extern NSString *const kPushPayloadPhotoObjectIdKey;

// *********************************************** PARSE CLOUD CODE **************************************
extern NSString *const kCloudCodeDeleteUserKey;

// *********************************************** PARSE CLASSES *****************************************
#pragma mark - PFObject User Class
// Field keys
//displayName: name user signs up with or that comes from FB at signup; default
//that's displayed on scorecard
extern NSString *const kUserDisplayNameKey;
extern NSString *const kUserFacebookIDKey;
extern NSString *const kUserPhotoIDKey;
extern NSString *const kUserProfilePicSmallKey;
extern NSString *const kUserProfilePicMediumKey;
extern NSString *const kUserFacebookFriendsKey;
extern NSString *const kUserPrivateChannelKey;
extern NSString *const kUserFacebookProfileKey;
extern NSString *const kUserEmailKey;
extern NSString *const kUserUsernameKey;
extern NSString *const kUserEmailVerifiedKey;
//currentActiveRound: pointer to the Round the user is currently participating in
extern NSString *const kUserCurrentActiveRoundKey;
//currentRounds: number denoting how many rounds user is currently part of; not
//currently used
extern NSString *const kUserCurrentRoundsKey;
//roundsCreated: number that increments each time a user creates a round; perhaps
//use for stats later
extern NSString *const kUserRoundsCreatedKey;
extern NSString *const kUserTwitterIdKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kActivityClassKey;

// Field keys
//type: type of activity, i.e. photo, like, comment, award, etc.
extern NSString *const kActivityTypeKey;
//fromUser: pointer to User who initiated the Activity
extern NSString *const kActivityFromUserKey;
//toUser: pointer to User who receives the Activity
extern NSString *const kActivityToUserKey;
//content: message associated with activity, usually a comment from another user
extern NSString *const kActivityContentKey;
//hole: pointer to hole the activity was created for, i.e. a photo during a hole or
//a 'like' for a hole score
extern NSString *const kActivityHoleKey;
//round: pointer to round activity is associated with
extern NSString *const kActivityRoundKey;

// Type values
extern NSString *const kActivityTypeLike;
extern NSString *const kActivityTypeFollow;
extern NSString *const kActivityTypeComment;
extern NSString *const kActivityTypeJoined;


#pragma mark - PFObject Hole Class
// Class key
extern NSString *const kHoleClassKey;

// Field keys
//holeNum: number of hole in round (1-9)
extern NSString *const kHoleHoleNumKey;
//location: geopoint of hole location to enable locating on a map
extern NSString *const kHoleLocationKey;
//name: name of the bar/hole
extern NSString *const kHoleNameKey;
//par: number of par for the hole
extern NSString *const kHoleParKey;
//round: pointer to round hole is added for
extern NSString *const kHoleRoundKey;
//timeAtHole: number in milliseconds of duration of hole stay; not currently used but
//could be implemented in future as a timer
extern NSString *const kHoleTimeAtHoleKey;
//user: pointer to user who created hole entry
extern NSString *const kHoleUserKey;


#pragma mark - PFObject Player Class
// Class key
extern NSString *const kPlayerClassKey;

// Field keys
//displayName: name of player to display on scorecard
extern NSString *const kPlayerDisplayNameKey;
//handicap: player's handicap for use in scoring
extern NSString *const kPlayerHandicapKey;
//holesPlayed: convenience relation column we'll add unique holes to anytime a new score
//is added for a player; use this to make it easier for building the leaderboard and the
//parTotalInPlay value
extern NSString *const kPlayerHolesPlayedKey;
//isUserAccount: boolean to denote whether player is also the current User; only player's
//that are user account will have stats that can be collected beyond the current round for
//historical record keeping
extern NSString *const kPlayerIsUserAccountKey;
//maxHolePlayed: initially 0; number of highest hole played; updated every time a score is
//saved for the player via cloud code
extern NSString *const kPlayerMaxHolePlayedKey;
//parsInPlayTotal: convenience number column used to keep track of the par total of all
//holes the player has a score for
extern NSString *const kPlayerParsInPlayTotalKey;
//playerNum: number of player on scorecard for ordering purposes (1-4)
extern NSString *const kPlayerPlayerNumKey;
//round: pointer to round the player was added for
extern NSString *const kPlayerRoundKey;
//scorecard: pointer to scorecard the player is added on
extern NSString *const kPlayerScorecardKey;
//scores: relation of score entries (similar to an array) for that player; for player entries
//that are for user accounts, this array could contain scores from more than one round so
//querying will need to take that into account; for non-user account players, this field will
//only contain scores for the current round
extern NSString *const kPlayerScoresKey;
//totalRoundStrokes: number of total strokes for a player in the current round; reset to 0
//every round; updated every time a score is saved for a player via cloud code; does not
//include handicap or par values
extern NSString *const kPlayerTotalRoundStrokesKey;
//user: pointer to user who created the player
extern NSString *const kPlayerUserKey;


#pragma mark - PFObject Round Class
// Class key
extern NSString *const kRoundClassKey;

// Field keys
//endDate: date when round was completed; entered when user ends round; not currently used
extern NSString *const kRoundEndDateKey;
//isActive: boolean denoting the currently active round for a User; can only be 1 per User
//currently
extern NSString *const kRoundIsActiveKey;
//isPublic: not currently used; eventually could be toggled at round creation so the user
//can denote if a round can be joined by anyone searching for a round to play in locally or,
//if private, players will be required to enter code; currently all rounds are private
extern NSString *const kRoundIsPublicKey;
//rules: array of all rules being played in that round; at generic round creation, this will
//be populated with all the default rules; if a user modifies/adds/deletes rules, this array
//will be updated accordingly so that deleted rules won't reappear on user's scorecards
extern NSString *const kRoundRulesKey;
//startDate: date round is started; not currently used but could be implemented for FB event
//invites
extern NSString *const kRoundStartDateKey;
//title: name of current round; displayed to other players attempting to joing user's round
extern NSString *const kRoundTitleKey;
//user: pointer to user who created round
extern NSString *const kRoundUserKey;


#pragma mark - PFObject Rule Class
// Class key
extern NSString *const kRuleClassKey;

// Field keys
//description: longer text explanation of what the rule is
extern NSString *const kRuleDescriptionKey;
//isDefault: default set of rules for play out of the box; cannot be modified by users; if
//a default rule is modified by a user, a copy of the rule that is not default is added to
//the list and that rule is played
extern NSString *const kRuleIsDefaultKey;
//modifiedDefault: boolean denoting whether a rule was created based on a default rule that
//was attempted to be edited and thus a copy was created
extern NSString *const kRuleModifiedDefaultKey;
//name: title of rule
extern NSString *const kRuleNameKey;
//round: pointer to round the rule is being added for
extern NSString *const kRuleRoundKey;
//type: type of rule, i.e. drink/bonus/penalty
extern NSString *const kRuleTypeKey;
//user: pointer to user who created the rule
extern NSString *const kRuleUserKey;
//value: number of stroke value for rule; decided to make these only be whole numbers to
//ease calculations
extern NSString *const kRuleValueKey;


#pragma mark - PFObject Score Class
// Class key
extern NSString *const kScoreClassKey;

// Field keys
//count: number of rules to be added, i.e. 3 beers, instead of adding a separate entry for
//each, i.e. 3 entries of 1 beer each
extern NSString *const kScoreCountKey;
//hole: pointer to hole score was added for
extern NSString *const kScoreHoleKey;
//player: pointer to player score was added for
extern NSString *const kScorePlayerKey;
//round: pointer to round score was added for
extern NSString *const kScoreRoundKey;
//rule: pointer to rule the score is being entered for, i.e. Beer, Wine, Dressing Up, etc
extern NSString *const kScoreRuleKey;
//scorecard: pointer to scorecard score was added for
extern NSString *const kScoreScorecardKey;
//timeAtScore: datetime when score added
extern NSString *const kScoreTimeAtScoreKey;
//user: pointer to user of device who entered the score, not necessarily the same as the player
//score is being entered for
extern NSString *const kScoreUserKey;


#pragma mark - PFObject Scorecard Class
// Class key
extern NSString *const kScorecardClassKey;

// Field keys
//isActive: boolean denoting the active scorecard; created when a user creates/joins a round;
//can only be 1 active at a time currently; user must have an active scorecard before scores
//can be added to players in the round
extern NSString *const kScorecardIsActiveKey;
//round: pointer to round scorecard is associated with
extern NSString *const kScorecardRoundKey;
//user: pointer to user who created the scorecard
extern NSString *const kScorecardUserKey;

