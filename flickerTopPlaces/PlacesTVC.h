//
//  PlacesTVC.h
//  flickerTopPlaces
//
//  Created by Ryan on 5/8/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTVC : UITableViewController
@property (strong, nonatomic) NSDictionary *placesDict;
@property (strong, nonatomic) NSArray *sectionTitles;
@end
