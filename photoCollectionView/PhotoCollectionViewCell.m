//
//  PhotoCollectionViewCell.m
//  photoCollectionView
//
//  Created by James Rochabrun on 8/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)setPhotoDataDictionary:(NSDictionary *)photoDataDictionary {
    
    if(_photoDataDictionary == photoDataDictionary)return;
    _photoDataDictionary = photoDataDictionary;
    
    //Foursquare api require the phot prefix , a size and the photo prefix
    NSString *prefixURL = [photoDataDictionary valueForKeyPath:@"response.venue.bestPhoto.prefix"];
    NSString *size = @"100x100";
    NSString *sufixURL = [photoDataDictionary valueForKeyPath:@"response.venue.bestPhoto.suffix"];
    NSString *urlSTR = [NSString stringWithFormat:@"%@%@%@", prefixURL, size, sufixURL];
    
    //NSLog(@"PATH:%@", urlSTR);
    
    [self downloadImageFromURL:urlSTR];
}

- (void)downloadImageFromURL:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //its safer to create a nsdata before
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        __weak PhotoCollectionViewCell *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoView.image = image;
        });
    }];
    [task resume];
}

@end
