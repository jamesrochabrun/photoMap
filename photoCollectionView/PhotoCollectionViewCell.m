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

@implementation PhotoCollectionViewCell

- (void)setPhotoDataDictionary:(NSDictionary *)photoDataDictionary {
    
   // if(_photoDataDictionary == photoDataDictionary)return;
    _photoDataDictionary = photoDataDictionary;
    
    //Foursquare api require the phot prefix , a size and the photo prefix
    NSString *prefixURL = [photoDataDictionary valueForKeyPath:@"response.venue.bestPhoto.prefix"];
    NSString *size = @"100x100";
    NSString *sufixURL = [photoDataDictionary valueForKeyPath:@"response.venue.bestPhoto.suffix"];
    NSString *urlSTR = [NSString stringWithFormat:@"%@%@%@", prefixURL, size, sufixURL];
    NSURL *url = [NSURL URLWithString:urlSTR];
    [self.photoView setImageWithURL:url];
//    [PhotoController imageForPhoto:photoDataDictionary size:@"100x100" completion:^(UIImage *image) {
//        self.photoView.image = image;
//    }];
    
}








@end
