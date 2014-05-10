//
//  PlacesTVC.m
//  flickerTopPlaces
//
//  Created by Ryan on 5/8/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "PlacesTVC.h"

@interface PlacesTVC ()

@end
//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor on 5/2/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "PlacesTVC.h"
#import "TopPlacesFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface PlacesTVC ()

@end

@implementation PlacesTVC

- (void)setPlacesDict:(NSDictionary *)placesDict
{
    _placesDict = placesDict;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionTitles count];
}

//- (UITableView *)tableView:(UITableView *)tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:section];
    NSArray *sectionItems = [self.placesDict objectForKey:sectionTitle];
    return [sectionItems count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [self.placesDict objectForKey:sectionTitle];
    NSDictionary *place = [sectionItems objectAtIndex:(NSUInteger) indexPath.row];
    
    cell.textLabel.text = [FlickrFetcher extractNameOfPlace:[place valueForKey:FLICKR_PLACE_ID] fromPlaceInformation:place];
    cell.detailTextLabel.text = [FlickrFetcher extractRegionNameFromPlaceInformation:place];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC isKindOfClass:[UINavigationController class]]) {
        detailVC = [((UINavigationController *)detailVC).viewControllers firstObject];
    }
    if ([detailVC isKindOfClass:[TopPlacesFlickrPhotosTVC class]]) {
        NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionItems = [self.placesDict objectForKey:sectionTitle];
        [self prepareTopPlacesFlickrPhotosTVS:detailVC toListImagesWithLocation:sectionItems[indexPath.row]];
    }
}

#pragma mark - Navigation

- (void)prepareTopPlacesFlickrPhotosTVS:(TopPlacesFlickrPhotosTVC *)tvc
                    toListImagesWithLocation:(NSDictionary *)location
{
    tvc.placeID = [location valueForKey:FLICKR_PLACE_ID];
    tvc.title = [FlickrFetcher extractNameOfPlace:[location valueForKey:FLICKR_PLACE_ID] fromPlaceInformation:location];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"List Photos"]) {
                if ([segue.destinationViewController isKindOfClass:[FlickrPhotosTVC class]]) {
                    NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
                    NSArray *sectionItems = [self.placesDict objectForKey:sectionTitle];
                    [self prepareTopPlacesFlickrPhotosTVS:segue.destinationViewController toListImagesWithLocation:sectionItems[indexPath.row]];
                }
            }
        }
    }
}

@end
