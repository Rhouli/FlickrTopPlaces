//
//  GeneralHelper.h
//  flickerTopPlaces
//
//  Created by Ryan on 5/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralHelper : NSObject
+ (UIImage *)imageFromText:(NSString *)text;
+ (UIImage *)imageFromText:(NSString *)text withImage:(UIImage *)overlayImage forSize:(CGSize)size;
@end
