//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor on 5/2/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

#define NS_USR_DEFAULTS_KEY @"Recently Viewed"
#define MAX_RECENT_HISTORY 20

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.photos[indexPath.row];
    if(![[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]){
        cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
        cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else if(![[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]){
        cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = @"Unkown";
        cell.detailTextLabel.text = @"";
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                [self saveImageViewingHistory:self.photos[indexPath.row]];
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}

- (void) saveImageViewingHistory:(UIImage *)photo  {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];

    if([userDefaults objectForKey:NS_USR_DEFAULTS_KEY])
        array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:NS_USR_DEFAULTS_KEY]];
    [array insertObject:photo atIndex:0];

    if([array count] > MAX_RECENT_HISTORY)
        [array removeLastObject];
    [userDefaults setObject:array forKey:NS_USR_DEFAULTS_KEY];
    [userDefaults synchronize];
}
@end
