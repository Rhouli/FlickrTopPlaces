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

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [self extractPhotosAndTimes];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    // update number and position info

    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    Float64 textValue = [self.times[indexPath.row] floatValue];
    UIImage* iconImage;
    if (textValue > BLUE_STAR_LIMIT){
        iconImage = [UIImage imageNamed:@"BlueStarIcon"];
        textValue /= BLUE_STAR_LIMIT;
    } else
        iconImage = [UIImage imageNamed:@"StarIcon"];
    
    NSString* text = [[NSString stringWithFormat:@"%f", textValue] substringToIndex:3];
    
    if([ [NSString stringWithFormat:@"%c", [text characterAtIndex:2]] isEqualToString:@"."])
        text = [text substringToIndex:2];
    
    CGSize size;
    size.width = 40;
    size.height = 40;
    cell.imageView.image = [GeneralHelper imageFromText:text withImage:iconImage forSize:size];

    NSArray* labels = [GeneralHelper GetCellLabel:self.photos[indexPath.row]];
    
    cell.textLabel.text = labels[INDEX_OF_TITLE];
    cell.detailTextLabel.text = labels[INDEX_OF_DESCRIPTION];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self extractPhotosAndTimes];
    [self.tableView reloadData];
}

#pragma mark - Navigation

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
