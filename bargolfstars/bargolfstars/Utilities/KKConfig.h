//
//  KKConfig.h
//  Bar Golf
//
//  Created by Kerry Knight on 1/4/14.
//  Copyright (c) 2014 Kerry Knight. All rights reserved.
//

@import Foundation;

#pragma mark - API keys
extern NSString *const kREV_MOB_APP_ID;
extern NSString *const kREV_MOB_FULLSCREEN_PLACEMENT_ID;
extern NSString *const kREV_MOB_BANNER_PLACEMENT_ID;
extern NSString *const kREV_MOB_AD_LINK_PLACEMENT_ID;
extern NSString *const kKKParseApplicationID;
extern NSString *const kKKParseApplicationClientKey;
extern NSString *const kKKFacebookAppID;
extern NSString *const kKKFacebookAppSecret;
extern NSString *const kKKTwitterConsumerKey;
extern NSString *const kKKTwitterConsumerSecret;
extern NSString *const kKKFoursquareEndpoint;
extern NSString *const kKKFoursquareClientId;
extern NSString *const kKKFoursquareClientSecret;


#pragma mark - NSUserDefaults
extern NSString *const kKKUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kKKUserDefaultsCacheFacebookFriendsKey;


#pragma mark - Default App Settings
extern int const kKKMinimumPasswordLength;
extern int const kKKMaximumPasswordLength;
extern int const kKKMinimumDisplayNameLength;
extern int const kKKMaximumDisplayNameLength;


#pragma mark - Launch URLs
extern NSString *const kKKLaunchURLHostTakePicture;


#pragma mark - NSNotification
extern NSString *const KKAppDelegateApplicationDidReceiveRemoteNotification;


#pragma mark - Installation Class

// Field keys
extern NSString *const kKKInstallationUserKey;
extern NSString *const kKKInstallationChannelsKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kKKUserAttributesPhotoCountKey;
extern NSString *const kKKUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kKKPushPayloadPayloadTypeKey;
extern NSString *const kKKPushPayloadPayloadTypeActivityKey;

extern NSString *const kKKPushPayloadActivityTypeKey;
extern NSString *const kKKPushPayloadActivityLikeKey;
extern NSString *const kKKPushPayloadActivityCommentKey;
extern NSString *const kKKPushPayloadActivityFollowKey;

extern NSString *const kKKPushPayloadFromUserObjectIdKey;
extern NSString *const kKKPushPayloadToUserObjectIdKey;
extern NSString *const kKKPushPayloadPhotoObjectIdKey;


// *********************************************** PARSE CLASSES *****************************************
#pragma mark - PFObject User Class
// Field keys
//displayName: name user signs up with or that comes from FB at signup; default
//that's displayed on scorecard
extern NSString *const kKKUserDisplayNameKey;
extern NSString *const kKKUserFacebookIDKey;
extern NSString *const kKKUserPhotoIDKey;
extern NSString *const kKKUserProfilePicSmallKey;
extern NSString *const kKKUserProfilePicMediumKey;
extern NSString *const kKKUserFacebookFriendsKey;
extern NSString *const kKKUserPrivateChannelKey;
extern NSString *const kKKUserFacebookProfileKey;
extern NSString *const kKKUserEmailKey;
extern NSString *const kKKUserUsernameKey;
extern NSString *const kKKUserEmailVerifiedKey;
//currentActiveRound: pointer to the Round the user is currently participating in
extern NSString *const kKKUserCurrentActiveRoundKey;
//currentRounds: number denoting how many rounds user is currently part of; not
//currently used
extern NSString *const kKKUserCurrentRoundsKey;
//roundsCreated: number that increments each time a user creates a round; perhaps
//use for stats later
extern NSString *const kKKUserRoundsCreatedKey;
extern NSString *const kKKUserTwitterIdKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kKKActivityClassKey;

// Field keys
//type: type of activity, i.e. photo, like, comment, award, etc.
extern NSString *const kKKActivityTypeKey;
//fromUser: pointer to User who initiated the Activity
extern NSString *const kKKActivityFromUserKey;
//toUser: pointer to User who receives the Activity
extern NSString *const kKKActivityToUserKey;
//content: message associated with activity, usually a comment from another user
extern NSString *const kKKActivityContentKey;
//hole: pointer to hole the activity was created for, i.e. a photo during a hole or
//a 'like' for a hole score
extern NSString *const kKKActivityHoleKey;
//round: pointer to round activity is associated with
extern NSString *const kKKActivityRoundKey;

// Type values
extern NSString *const kKKActivityTypeLike;
extern NSString *const kKKActivityTypeFollow;
extern NSString *const kKKActivityTypeComment;
extern NSString *const kKKActivityTypeJoined;


#pragma mark - PFObject Hole Class
// Class key
extern NSString *const kKKHoleClassKey;

// Field keys
//holeNum: number of hole in round (1-9)
extern NSString *const kKKHoleHoleNumKey;
//location: geopoint of hole location to enable locating on a map
extern NSString *const kKKHoleLocationKey;
//name: name of the bar/hole
extern NSString *const kKKHoleNameKey;
//par: number of par for the hole
extern NSString *const kKKHoleParKey;
//round: pointer to round hole is added for
extern NSString *const kKKHoleRoundKey;
//timeAtHole: number in milliseconds of duration of hole stay; not currently used but
//could be implemented in future as a timer
extern NSString *const kKKHoleTimeAtHoleKey;
//user: pointer to user who created hole entry
extern NSString *const kKKHoleUserKey;


#pragma mark - PFObject Player Class
// Class key
extern NSString *const kKKPlayerClassKey;

// Field keys
//displayName: name of player to display on scorecard
extern NSString *const kKKPlayerDisplayNameKey;
//handicap: player's handicap for use in scoring
extern NSString *const kKKPlayerHandicapKey;
//holesPlayed: convenience relation column we'll add unique holes to anytime a new score
//is added for a player; use this to make it easier for building the leaderboard and the
//parTotalInPlay value
extern NSString *const kKKPlayerHolesPlayedKey;
//isUserAccount: boolean to denote whether player is also the current User; only player's
//that are user account will have stats that can be collected beyond the current round for
//historical record keeping
extern NSString *const kKKPlayerIsUserAccountKey;
//maxHolePlayed: initially 0; number of highest hole played; updated every time a score is
//saved for the player via cloud code
extern NSString *const kKKPlayerMaxHolePlayedKey;
//parsInPlayTotal: convenience number column used to keep track of the par total of all
//holes the player has a score for
extern NSString *const kKKPlayerParsInPlayTotalKey;
//playerNum: number of player on scorecard for ordering purposes (1-4)
extern NSString *const kKKPlayerPlayerNumKey;
//round: pointer to round the player was added for
extern NSString *const kKKPlayerRoundKey;
//scorecard: pointer to scorecard the player is added on
extern NSString *const kKKPlayerScorecardKey;
//scores: relation of score entries (similar to an array) for that player; for player entries
//that are for user accounts, this array could contain scores from more than one round so
//querying will need to take that into account; for non-user account players, this field will
//only contain scores for the current round
extern NSString *const kKKPlayerScoresKey;
//totalRoundStrokes: number of total strokes for a player in the current round; reset to 0
//every round; updated every time a score is saved for a player via cloud code; does not
//include handicap or par values
extern NSString *const kKKPlayerTotalRoundStrokesKey;
//user: pointer to user who created the player
extern NSString *const kKKPlayerUserKey;


#pragma mark - PFObject Round Class
// Class key
extern NSString *const kKKRoundClassKey;

// Field keys
//endDate: date when round was completed; entered when user ends round; not currently used
extern NSString *const kKKRoundEndDateKey;
//isActive: boolean denoting the currently active round for a User; can only be 1 per User
//currently
extern NSString *const kKKRoundIsActiveKey;
//isPublic: not currently used; eventually could be toggled at round creation so the user
//can denote if a round can be joined by anyone searching for a round to play in locally or,
//if private, players will be required to enter code; currently all rounds are private
extern NSString *const kKKRoundIsPublicKey;
//rules: array of all rules being played in that round; at generic round creation, this will
//be populated with all the default rules; if a user modifies/adds/deletes rules, this array
//will be updated accordingly so that deleted rules won't reappear on user's scorecards
extern NSString *const kKKRoundRulesKey;
//startDate: date round is started; not currently used but could be implemented for FB event
//invites
extern NSString *const kKKRoundStartDateKey;
//title: name of current round; displayed to other players attempting to joing user's round
extern NSString *const kKKRoundTitleKey;
//user: pointer to user who created round
extern NSString *const kKKRoundUserKey;


#pragma mark - PFObject Rule Class
// Class key
extern NSString *const kKKRuleClassKey;

// Field keys
//description: longer text explanation of what the rule is
extern NSString *const kKKRuleDescriptionKey;
//isDefault: default set of rules for play out of the box; cannot be modified by users; if
//a default rule is modified by a user, a copy of the rule that is not default is added to
//the list and that rule is played
extern NSString *const kKKRuleIsDefaultKey;
//modifiedDefault: boolean denoting whether a rule was created based on a default rule that
//was attempted to be edited and thus a copy was created
extern NSString *const kKKRuleModifiedDefaultKey;
//name: title of rule
extern NSString *const kKKRuleNameKey;
//round: pointer to round the rule is being added for
extern NSString *const kKKRuleRoundKey;
//type: type of rule, i.e. drink/bonus/penalty
extern NSString *const kKKRuleTypeKey;
//user: pointer to user who created the rule
extern NSString *const kKKRuleUserKey;
//value: number of stroke value for rule; decided to make these only be whole numbers to
//ease calculations
extern NSString *const kKKRuleValueKey;


#pragma mark - PFObject Score Class
// Class key
extern NSString *const kKKScoreClassKey;

// Field keys
//count: number of rules to be added, i.e. 3 beers, instead of adding a separate entry for
//each, i.e. 3 entries of 1 beer each
extern NSString *const kKKScoreCountKey;
//hole: pointer to hole score was added for
extern NSString *const kKKScoreHoleKey;
//player: pointer to player score was added for
extern NSString *const kKKScorePlayerKey;
//round: pointer to round score was added for
extern NSString *const kKKScoreRoundKey;
//rule: pointer to rule the score is being entered for, i.e. Beer, Wine, Dressing Up, etc
extern NSString *const kKKScoreRuleKey;
//scorecard: pointer to scorecard score was added for
extern NSString *const kKKScoreScorecardKey;
//timeAtScore: datetime when score added
extern NSString *const kKKScoreTimeAtScoreKey;
//user: pointer to user of device who entered the score, not necessarily the same as the player
//score is being entered for
extern NSString *const kKKScoreUserKey;


#pragma mark - PFObject Scorecard Class
// Class key
extern NSString *const kKKScorecardClassKey;

// Field keys
//isActive: boolean denoting the active scorecard; created when a user creates/joins a round;
//can only be 1 active at a time currently; user must have an active scorecard before scores
//can be added to players in the round
extern NSString *const kKKScorecardIsActiveKey;
//round: pointer to round scorecard is associated with
extern NSString *const kKKScorecardRoundKey;
//user: pointer to user who created the scorecard
extern NSString *const kKKScorecardUserKey;

