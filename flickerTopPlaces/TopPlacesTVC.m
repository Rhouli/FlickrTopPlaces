//
//  TopPlacesTVC.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/8/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"

@interface TopPlacesTVC ()
@property (strong, nonatomic) NSArray* places;
@property UIActivityIndicatorView* spinner;
@end

@implementation TopPlacesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 200, 30, 30)];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner setColor:[UIColor blueColor]];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    [self performSelector:@selector(fetchTopPlaces) withObject:self.spinner afterDelay:0.4];

    [super viewDidLoad];
}

- (void) fetchTopPlaces {
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    if (url){
        // NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task =[session
                                         downloadTaskWithURL:url
                                         completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                             NSArray *places;
                                             if(!error){
                                                 places = [[NSJSONSerialization
                                                                     JSONObjectWithData:[NSData dataWithContentsOfURL:location]
                                                                     options:0
                                                                     error:NULL] valueForKeyPath:FLICKR_RESULTS_PLACES];
                                                 
                                                 NSMutableDictionary *placesDict = [[NSMutableDictionary alloc] init];
                                                 
                                                 NSMutableOrderedSet *countries = [[NSMutableOrderedSet alloc] init];
                                                 for(NSDictionary *place in places)
                                                     [countries addObject:[FlickrFetcher extractCountryNameFromPlaceInformation:place]];
                                                 
                                                 for(NSString* country in countries)
                                                     [placesDict setObject:[NSMutableArray array] forKey:country];
                                                 
                                                 for(NSDictionary *place in places)
                                                     [[placesDict objectForKey:[FlickrFetcher extractCountryNameFromPlaceInformation:place]] addObject:place];
                                                 
                                                 // sort the dictonary in alphabetical order (keys and objects)
                                                 NSMutableDictionary *placesDictSorted = [[NSMutableDictionary alloc] init];
                                                 NSArray *sortedKeys = [[placesDict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
                                                 
                                                 for(NSString *key in sortedKeys){
                                                     NSArray* tmp = [placesDict objectForKey:key];
                                                     NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME
                                                                                                                ascending:YES];
                                                     NSArray *sortedArray = [tmp sortedArrayUsingDescriptors:
                                                                             [NSArray arrayWithObject:descriptor]];
                                                     
                                                     [placesDictSorted setObject:sortedArray forKey:key];
                                                 }

                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     self.sectionTitles = sortedKeys;
                                                     self.placesDict = placesDictSorted;
                                                 });
                                             }
                                         }];
        [task resume];
        [self.spinner stopAnimating];
    }
}
@end
