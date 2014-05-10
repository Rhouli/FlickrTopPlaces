//
//  TopPlacesFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Ryan Houlihan on 5/8/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

#define MAX_PHOTOS 50
@implementation TopPlacesFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)fetchPhotos {
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:MAX_PHOTOS];
#warning Blocks Main Thread
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization
                                         JSONObjectWithData:jsonResults
                                         options:0
                                         error:NULL];
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    self.photos = photos;
}

@end
