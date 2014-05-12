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

#pragma mark - lazy instantiation

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Recent Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray* labels = [GeneralHelper GetCellLabel:self.photos[indexPath.row]];
    
    cell.textLabel.text = labels[INDEX_OF_TITLE];
    cell.detailTextLabel.text = labels[INDEX_OF_DESCRIPTION];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC isKindOfClass:[UINavigationController class]]) {
        detailVC = [((UINavigationController *)detailVC).viewControllers firstObject];
    }
    if ([detailVC isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detailVC toDisplayPhoto:self.photos[indexPath.row]];
    }
}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc
                    toDisplayPhoto:(NSDictionary *)photo {
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.photo = photo;
    
    NSArray *cellTitle = [GeneralHelper GetCellLabel:photo];
    ivc.title = cellTitle[INDEX_OF_TITLE];}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}


@end
