//
//  KKMacros.h
//
//  Created by Kerry Knight on 1/23/14.
//

// Debug logger
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

// Always logger
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

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
#define kSomeColor [UIColor colorWithRed:235/255.0f green:128/255.0f blue:93/255.0f alpha:1.0]