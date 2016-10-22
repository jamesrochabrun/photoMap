//
//  PhotoCollectionViewCell.m
//  photoCollectionView
//
//  Created by James Rochabrun on 8/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoController.h"
#import "VenueObject.h"


@implementation PhotoCollectionViewCell

- (void)setVenue:(VenueObject *)venue {
    _venue = venue;
    
    NSString *size = @"100x100";
    NSString *urlSTR = [NSString stringWithFormat:@"%@%@%@", venue.prefix, size, venue.sufix];
    NSURL *url = [NSURL URLWithString:urlSTR];
    NSLog(@"URLSTR %@" , urlSTR);
    
    [self.photoView setImageWithURL:url];
}








@end
