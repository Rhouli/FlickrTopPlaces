//
//  GeneralHelper.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "GeneralHelper.h"
#import "FlickrFetcher.h"

#define FONT_SIZE 12.0
#define CORRECTION_FACTOR 3.0

@implementation GeneralHelper

+ (UIImage *)imageFromText:(NSString *)text {
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary *attrsDictionary =
    [NSDictionary dictionaryWithObject:font
                                forKey:NSFontAttributeName];
    CGSize size  = [text sizeWithAttributes:attrsDictionary];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:attrsDictionary];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromText:(NSString *)text withImage:(UIImage *)overlayImage forSize:(CGSize)size {
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary *attrsDictionary =
    [NSDictionary dictionaryWithObject:font
                                forKey:NSFontAttributeName];
    
    CGSize textSize = [text sizeWithAttributes:attrsDictionary];
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(overlayImage.size);
    
    [overlayImage drawInRect:CGRectMake(0,0,size.width,size.height)];
    // draw in context, you can use also drawInRect:withFont:
    Float64 x = size.width/2-textSize.width/2;
    Float64 y = size.height/2-textSize.height/2 + CORRECTION_FACTOR;
    CGRect rect = CGRectMake(x, y, size.width, size.height);
    [text drawInRect:CGRectIntegral(rect) withAttributes:attrsDictionary];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSArray *)GetCellLabel:(NSDictionary *) photo {
    NSMutableArray* newStrings = [[NSMutableArray alloc] init];
    if(![[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]){
        [newStrings addObject:[photo valueForKeyPath:FLICKR_PHOTO_TITLE]];
        [newStrings addObject:[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]];
    } else if(![[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]){
        [newStrings addObject:[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]];
        [newStrings addObject:@""];
    } else {
        [newStrings addObject:@"Unkown"];
        [newStrings addObject:@""];
    }
    
    return (NSArray *)newStrings;
}

@end
