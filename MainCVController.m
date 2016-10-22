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
#import "PhotoController.h"

NSString *const DATA_VERSION_DATE = @"20161018";
NSString *const DATA_FORMAT = @"foursquare";
NSString *const HTTPURLVERSION = @"https://api.foursquare.com/v2";

@implementation MainCVController

- (void)viewDidLoad {
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"photos";
    self.collectionView.bounces = YES;
    
    //getting the value of accesstoken, this key is setted by the developer , if that already happened it wont be nil, if not it will be nil and will create it with the response of the SimpleAuth method
    PhotoController *photoController  = [PhotoController new];
    [photoController accessTokenWithcompletion:^(BOOL finished) {
        [self getVenuesData];
    }];
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
    
    //this session can be shared like in this example, we use the same session twice
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlLikedVenues = [NSString stringWithFormat:@"%@/users/self/venuelikes/?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
    NSURL *url = [NSURL URLWithString:urlLikedVenues];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.likedArrayIDS = [responseDict valueForKeyPath:@"response.venues.items.id"];
        
        NSLog(@"the ids are %@", self.likedArrayIDS);
        //Now get the venue by ID
        [self getVenueFromArrayOfIDS:self.likedArrayIDS withSession:session];
    }];
    
    [task resume];
}

- (void)getVenueFromArrayOfIDS:(NSArray *)likedArray withSession:(NSURLSession *)session {
    
    self.venueArray = [NSMutableArray new];
    
    for (NSString *venueID in likedArray) {
        
        NSURLSession *session1 = [NSURLSession sharedSession];
        
        NSString *urlVenueStr = [NSString stringWithFormat:@"%@/venues/%@?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, venueID,self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
        NSURL *urlForVenue = [NSURL URLWithString:urlVenueStr];
        NSURLRequest *venueRequest = [NSURLRequest requestWithURL:urlForVenue];
        
        NSURLSessionDownloadTask *venueTask = [session1 downloadTaskWithRequest:venueRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSData *venueData = [NSData dataWithContentsOfURL:location];
            NSDictionary *venuedictionary = [NSJSONSerialization JSONObjectWithData:venueData options:kNilOptions error:nil];
            
            VenueObject *venue = [VenueObject venueFromDict:venuedictionary];
            
            [self.venueArray addObject:venue];
            __weak MainCVController *weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.collectionView reloadData];
            });
        }];
       
        [venueTask resume];
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
