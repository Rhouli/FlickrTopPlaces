//
//  RecentlyViewedTVC.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "RecentlyViewedTVC.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "NSDefaultHelper.h"
#import "GeneralHelper.h"

@interface RecentlyViewedTVC ()
@end

@implementation RecentlyViewedTVC

#pragma mark - View Controller Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.photos = [userDefaults objectForKey:NS_USR_DEFAULTS_RECENT_KEY];
    [self.tableView reloadData];
}

@end
