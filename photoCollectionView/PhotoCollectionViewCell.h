//
//  PhotoCollectionViewCell.h
//  photoCollectionView
//
//  Created by James Rochabrun on 8/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>
@class VenueObject;

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) VenueObject *venue;
@end
