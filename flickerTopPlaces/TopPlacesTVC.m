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
@end

@implementation TopPlacesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTopPlaces];
}

- (void) loadTopPlaces:(void (^)(NSArray *placesList, NSError *errror))completion {
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
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(places,error);
                                                 });
                                                 
                                             }
                                         }];
        [task resume];
    }
}
- (void)fetchTopPlaces {
    
    // Build a dictonary linking all countries and states/ regions in the country
     NSURL *url = [FlickrFetcher URLforTopPlaces];
     #warning Blocks Main Thread
     NSData *jsonResults = [NSData dataWithContentsOfURL:url];
     
     NSDictionary *propertyListResults = [NSJSONSerialization
     JSONObjectWithData:jsonResults
     options:0
     error:NULL];
     
     NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];


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
    
    self.sectionTitles = sortedKeys;
    self.placesDict = placesDictSorted;
}

@end
