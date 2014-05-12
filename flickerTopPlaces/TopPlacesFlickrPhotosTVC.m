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

@interface TopPlacesFlickrPhotosTVC ()
@property UIActivityIndicatorView* spinner;
@end

@implementation TopPlacesFlickrPhotosTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 200, 30, 30)];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner setColor:[UIColor blueColor]];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    [self performSelector:@selector(fetchPhotos) withObject:self.spinner afterDelay:0.4];
}

- (void) fetchPhotos {
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:MAX_PHOTOS];
    if (url){
        // NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task =[session
                                         downloadTaskWithURL:url
                                         completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                             NSArray *photos;
                                             if(!error){
                                                 photos = [[NSJSONSerialization
                                                            JSONObjectWithData:[NSData dataWithContentsOfURL:location]
                                                            options:0
                                                            error:NULL] valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     self.photos = photos;
                                                 });
                                             }
                                         }];
        [task resume];
        [self.spinner stopAnimating];
    }
}


@end
