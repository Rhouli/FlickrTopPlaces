//
//  NSDefaultHelper.h
//  flickerTopPlaces
//
//  Created by Ryan on 5/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NS_USR_DEFAULTS_RECENT_KEY @"Recently Viewed"
#define NS_USR_DEFAULTS_FAVORITE_KEY @"Favorite Viewed"
#define MAX_RECENT_HISTORY 20
#define MAX_FAVORITES 30
#define PHOTOS_INDEX 0
#define TIME_INDEX 1
#define BLUE_STAR_LIMIT 1000

@interface NSDefaultHelper : NSObject
+ (void) saveImageViewingHistory:(NSDictionary *)photo;
+ (void) saveImageFavoriteHistory:(NSDictionary *)photo forTime:(NSTimeInterval) viewingTime;
@end
