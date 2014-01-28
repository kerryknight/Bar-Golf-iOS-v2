//
//  KKMacros.h
//
//  Created by Kerry Knight on 1/23/14.
//

// Debug logger
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLogGreen(fmt, ...) DDLogInfo((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLogRed(fmt, ...) DDLogError((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLogOrange(fmt, ...) DDLogWarn((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLogError(fmt, ...) DDLogError((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLogWarning(fmt, ...) DDLogWarn((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#define DLogGreen(...)
#define DLogRed(...)
#define DLogOrange(...)
#define DLogError(...)
#define DLogWarning(...)
#endif

// Device detection
#define IS_IPAD				(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_TALL		(IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_CLASSIC	(IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPOD				([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
#define IS_RETINA			([[UIScreen mainScreen] scale] == 2.0)

// IOS version detection
#define IOS_VERSION_EQUAL_TO(v)					([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)				([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)				([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Latitude & Longitude to miles (approximation)
#define LAT_TO_MILES(l)	(l / 69.1f)
#define LON_TO_MILES(l)	(l / 53.0f)

// colors
#define kLtGray     [UIColor colorWithRed:51/255.0f green:63/255.0f blue:77/255.0f alpha:1.0]
#define kMedGray    [UIColor colorWithRed:45/255.0f green:57/255.0f blue:69/255.0f alpha:1.0]
#define kDrkGray    [UIColor colorWithRed:31/255.0f green:44/255.0f blue:53/255.0f alpha:1.0]
#define kLtWhite    [UIColor colorWithRed:243/255.0f green:246/255.0f blue:253/255.0f alpha:1.0]
#define kMedWhite   [UIColor colorWithRed:231/255.0f green:234/255.0f blue:243/255.0f alpha:1.0]
#define kLtGreen    [UIColor colorWithRed:116/255.0f green:192/255.0f blue:166/255.0f alpha:1.0]
#define kFBBlue     [UIColor colorWithRed:61/255.0f green:94/255.0f blue:150/255.0f alpha:1.0]

//font
#define kHelveticaLight     @"HelveticaNeue-Light"

//welcome/login/signup/forgot password view formatting
#define kWelcomButtonHeight         50
#define kWelcomeButtonWidth         270
#define kWelcomeTextFieldMargin     35