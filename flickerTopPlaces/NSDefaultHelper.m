//
//  NSDefaultHelper.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "NSDefaultHelper.h"

@implementation NSDefaultHelper
+ (void) saveImageViewingHistory:(NSDictionary *)photo  {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];

    if([userDefaults objectForKey:NS_USR_DEFAULTS_RECENT_KEY])
        array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:NS_USR_DEFAULTS_RECENT_KEY]];
    

    [array removeObject:photo];
    [array insertObject:photo atIndex:0];

    if([array count] > MAX_RECENT_HISTORY)
        [array removeLastObject];
    [userDefaults setObject:array forKey:NS_USR_DEFAULTS_RECENT_KEY];
    [userDefaults synchronize];
}

+ (void) saveImageFavoriteHistory:(NSDictionary *)photo forTime:(NSTimeInterval) viewingTime {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *innerArray = [[NSMutableArray alloc] init];
    
    if([userDefaults objectForKey:NS_USR_DEFAULTS_FAVORITE_KEY])
        array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:NS_USR_DEFAULTS_FAVORITE_KEY]];
    
    int position = -1;
    if([array count] == 0)
        position = 0;
    
    BOOL alreadyChoosen = NO;
    // if the image already exists in the list add its new time
    for(int i = 0; i < [array count]; i++){
        NSArray *tmp = (NSArray *) array[i];
        NSNumber *num = [NSNumber numberWithFloat:[tmp[TIME_INDEX] floatValue]];
        
        if ([photo isEqualToDictionary:(NSDictionary*)tmp[PHOTOS_INDEX]]){
            viewingTime += [num floatValue];
            [array removeObjectAtIndex:i];
        }
    }
    
    // if the image viewing time is long enough add to favorites list
    for(int i = (int)[array count]-1; i >= 0; i--){
        NSArray *tmp = (NSArray *) array[i];
        NSNumber *num = [NSNumber numberWithFloat:[tmp[TIME_INDEX] floatValue]];
        
      if (viewingTime > [num floatValue])
            position = i;
    }
    
    [innerArray insertObject:photo atIndex:PHOTOS_INDEX];
    [innerArray insertObject:[[NSNumber numberWithFloat:viewingTime] stringValue] atIndex:TIME_INDEX];
    
    if (position >= 0 && !alreadyChoosen){
        [array insertObject:innerArray atIndex:position];
    } else if ( [array count] < MAX_FAVORITES && !alreadyChoosen) {
        [array insertObject:innerArray atIndex:[array count]];
    }
    
    if([array count] > MAX_FAVORITES)
        [array removeLastObject];
    [userDefaults setObject:array forKey:NS_USR_DEFAULTS_FAVORITE_KEY];
    [userDefaults synchronize];
    
}
@end
