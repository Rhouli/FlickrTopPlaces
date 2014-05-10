//
//  FavoriteImagesTVC.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "FavoriteImagesTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "NSDefaultHelper.h"
#import "GeneralHelper.h"

@interface FavoriteImagesTVC ()

@end

@implementation FavoriteImagesTVC

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Favorite Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSString* text = (NSString *) [self.times[indexPath.row] substringToIndex:3];
    if([ [NSString stringWithFormat:@"%c", [text characterAtIndex:2]] isEqualToString:@"."])
        text = [text substringToIndex:2];
    UIImage* iconImage = [UIImage imageNamed:@"StarIcon"];
    CGSize size;
    size.width = 40;
    size.height = 40;
    cell.imageView.image = [GeneralHelper imageFromText:text withImage:iconImage forSize:size];

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
    
    // set ivc title
    if(![[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]){
        ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    } else if(![[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]){
        ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else {
        ivc.title = @"Unkown";
    }

}

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

- (void)viewWillAppear:(BOOL)animated {
    [self extractPhotosAndTimes];
    [self.tableView reloadData];
    
}

- (void)extractPhotosAndTimes {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* tmp = [userDefaults objectForKey:NS_USR_DEFAULTS_FAVORITE_KEY];
    NSMutableArray* photos = [[NSMutableArray alloc] init];
    NSMutableArray* times = [[NSMutableArray alloc] init];
    for(int i = 0; i < [tmp count]; i++){
        NSArray* tmp2 = tmp[i];
        [photos addObject:tmp2[PHOTOS_INDEX]];
        [times addObject:tmp2[TIME_INDEX]];
    }
    
    self.photos = (NSArray*) photos;
    self.times = (NSArray*) times;
}

@end