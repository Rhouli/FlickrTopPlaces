//
//  GeneralHelper.h
//  flickerTopPlaces
//
//  Created by Ryan on 5/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <Foundation/Foundation.h>

// Time helper functions
#define TIME_END self.endTime = [NSDate timeIntervalSinceReferenceDate];\
        NSTimeInterval elapsedTime = self.endTime - self.startTime;\
        [NSDefaultHelper saveImageFavoriteHistory:self.photo forTime:elapsedTime];\

#define TIME_START self.startTime = [NSDate timeIntervalSinceReferenceDate];

#define TIME_VARIABLES @property (nonatomic) NSTimeInterval startTime;\
@property (nonatomic) NSTimeInterval endTime;\

#define INDEX_OF_TITLE 0
#define INDEX_OF_DESCRIPTION 1

@interface GeneralHelper : NSObject

+ (UIImage *)imageFromText:(NSString *)text;
+ (UIImage *)imageFromText:(NSString *)text withImage:(UIImage *)overlayImage forSize:(CGSize)size;
+ (NSArray *)GetCellLabel:(NSDictionary *) photo;

@end
