//
//  MainCVController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 8/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "MainCVController.h"
#import "PhotoCollectionViewCell.h"
#import "VenueObject.h"
#import "API.h"
//
//NSString *const DATA_VERSION_DATE = @"20161018";
//NSString *const DATA_FORMAT = @"foursquare";
//NSString *const HTTPURLVERSION = @"https://api.foursquare.com/v2";
@interface MainCVController()
@property (nonatomic, strong) API *api;

@end

@implementation MainCVController

- (void)viewDidLoad {
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"photos";
    self.collectionView.bounces = YES;
    
    //getting the value of accesstoken, this key is setted by the developer , if that already happened it wont be nil, if not it will be nil and will create it with the response of the SimpleAuth method
    _api  = [API new];
    [self getVenuesData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.venueArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    VenueObject *venue = [self.venueArray objectAtIndex:indexPath.row];
    cell.venue = venue;
    return cell;
}

- (void)getVenuesData {
    
    [_api getLikedVenuesID:^(NSArray *venuesID) {
        [self getVenuesFromArrayOfIDS:venuesID];
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
}

- (void)getVenuesFromArrayOfIDS:(NSArray *)likedArray {
    
    self.venueArray = [NSMutableArray new];
    
    for (NSString *venueID in likedArray) {
        
        [_api getVenueFromID:venueID success:^(VenueObject *venue) {
            [self.venueArray addObject:venue];
            
            NSLog(@"the count %lu", self.venueArray.count);
            __weak MainCVController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
        }];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        
        NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
        VenueObject *venue = self.venueArray[selectedPath.row];
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.venue = venue;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:self];
}








@end
